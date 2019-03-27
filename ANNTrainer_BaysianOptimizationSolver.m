clear; clc

%% Primary Data

%% Data Preprocessing

%Import data from excel file after removing irrelevant columns 
filename = 'MLInput2.xlsx'; 
T = readtable(filename);
T = T(:,1:5); % Only keep DALY Mean and drop Upper and Lower for now

%Identify categorigal variables and give them numbers
VarNames = T.Properties.VariableNames;
cat = ~varfun(@isnumeric,T(:,1:end - 1),...
    'OutputFormat','uniform'); % Logical flag for categorical variables
catVars = find(cat);           % Indices of categorical variables

countCats = @(var)numel(categories(nominal(var)));
numCat = varfun(@(var)countCats(var),T(:,catVars),...
    'OutputFormat','uniform');

X = classreg.regr.modelutils.predictormatrix(T,'ResponseVar',...
    size(T,2));
Y = T.DALYMean;

% Determine training and validation indices
SampleSize = size(X,1); % sample size
TsInd = find(X(:,4) == 2017); % Set 2016 and 2017 for testing
ValInd = find(X(:,4) == 2016); % Set 2016 and 2017 for validation
TrInd = setdiff(1:SampleSize, [ValInd; TsInd])'; % set the remaining for training

%%

% Define hyperparameters to optimize
vars = [optimizableVariable('hiddenLayer1Size', [1,30], 'Type', 'integer'), ...
        optimizableVariable('hiddenLayer2Size', [1,30], 'Type', 'integer'), ...
        optimizableVariable('hiddenLayer3Size', [1,30], 'Type', 'integer'), ...
        optimizableVariable('hiddenLayer4Size', [1,30], 'Type', 'integer'), ...
        optimizableVariable('hiddenLayer5Size', [1,30], 'Type', 'integer')];
% Optimize
minfn = @(T)ANNValMSE(X', Y', TrInd, ValInd, TsInd, T.hiddenLayer1Size, ...
        T.hiddenLayer2Size, T.hiddenLayer3Size, T.hiddenLayer4Size, T.hiddenLayer5Size);
results = bayesopt(minfn, vars,'MaxObjectiveEvaluations',30, 'IsObjectiveDeterministic', false,...
    'AcquisitionFunctionName', 'expected-improvement-plus', 'UseParallel',true);
T = bestPoint(results)
% Train final model on full training set using the best hyperparameters
Mdl = feedforwardnet([T.hiddenLayer1Size T.hiddenLayer2Size T.hiddenLayer3Size, ...
                      T.hiddenLayer4Size, T.hiddenLayer5Size], 'trainbr');
Mdl.performParam.normalization = 'standard'; %Standardize the input features
Mdl.performFcn = 'mae';
Mdl.divideParam.trainInd = TrInd;
Mdl.divideParam.valInd= ValInd;
Mdl.divideParam.testInd= TsInd;
Mdl.trainParam.max_fail = 15;

[Mdl Mdltr] = train(Mdl, X', Y');
% Evaluate on test set and compute final rmse
finalrmse = Mdltr.best_tperf;

function rmse = ANNValMSE(x, y, trindex, valindex, tsindex, HL1, HL2, HL3, HL4, HL5)
% Train net.
net = feedforwardnet([HL1 HL2 HL3, HL4, HL5], 'trainbr');
net.performParam.normalization = 'standard'; %Standardize the input features
net.divideFcn = 'divideind';
net.performFcn = 'mae';
net.divideParam.trainInd = trindex;
net.divideParam.valInd= valindex;
net.divideParam.testInd= tsindex;
net.trainParam.max_fail = 15;

[net nettr] = train(net, x,y);

rmse = nettr.best_vperf; 
end
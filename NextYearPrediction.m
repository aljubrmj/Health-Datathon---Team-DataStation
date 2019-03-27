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

%Map categories: 

SexMap = values(containers.Map(X(:,1),table2cell(T(:,1))));
CauseMap = values(containers.Map(X(:,2),table2cell(T(:,2))));
ReiMap = values(containers.Map(X(:,3),table2cell(T(:,3))));
YearMap = {'2018', '2019', '2020'}; 

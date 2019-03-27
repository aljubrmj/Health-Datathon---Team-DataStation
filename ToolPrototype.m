clear; clc; close all; 

NextYearPrediction()

[SexInd,~] = listdlg('PromptString','Select Gender','SelectionMode','single','ListString',SexMap);
[CauseInd,~] = listdlg('PromptString','Select Cause','SelectionMode','single','ListString',CauseMap);
[ReiInd,~] = listdlg('PromptString','Select Risk/Etiology','SelectionMode','single','ListString',ReiMap);
[YearInd, ~] = listdlg('PromptString','Select Year','SelectionMode','single','ListString',YearMap);

%Find prediction indices
PredInd = find(X(:,4) == 2007);
Xpred = [X(PredInd, 1:end-1) str2double(YearMap(YearInd))*ones(length(PredInd), 1)]; 
Ypred = ANNModel(Xpred')'; 
%Ypred (Ypred<=0) = 0.0001; 

%Fitting a lognormal distribution and plotting on the same histogram
PDF = fitdist(Ypred,'Kernel'); %Gathers the mean and variance for a lognormal distribution from the data
Q = quantile(Ypred,[0 0.50 0.75]);
R1 = Q(1):0.1:Q(2); R2 = Q(2):0.1:Q(3); R3 = Q(3):0.1:150; 
figure (1); hold on;
xlim([Q(1) 150]);
area(R1, pdf(PDF, R1),'FaceColor', 'g'); 
area(R2, pdf(PDF, R2), 'FaceColor', 'y'); 
area(R3, pdf(PDF, R3), 'FaceColor', 'r');
xlabel('DALY Rate per 100,1000 Popoulation'); 
ylabel('DALY PDF'); 
PatientDALY = ANNModel([SexInd CauseInd ReiInd str2double(YearMap(YearInd))]'); 

if PatientDALY >Q(3)
    x = [0.85,0.85];
    y = [0.5,0.2];
    annotation('textarrow',x,y,'String','Your Health is in The Danger Zone', 'Color', 'Red');
elseif PatientDALY > Q(2)
    x = [0.6,0.6];
    y = [0.5,0.25];
    annotation('textarrow',x,y,'String','You Health is The Warning Zone', 'Color', 'Yellow');
else 
    x = [0.5,0.35];
    y = [0.7,0.7];
    annotation('textarrow',x,y,'String','You Health is The Safe Zone', 'Color', 'Green');
end

msgbox(['Your DALY Rate Per 100,000 Population is  ', num2str(round(PatientDALY))], 'DALY Result', 'error')

% Plot Example for Female, Cardiovascular diseases, and Low physical
% activity
subplot(3,3, 1)
PredInd = find(X(:,1) == 2 & X(:,2) == 1 & X(:,3) == 1); 
Time = X(PredInd, 4);
DALY = Y(PredInd);
plot(Time, DALY, 'o'); hold on;
Int = 2007:0.5:2020; 
plot(Int, Mdl([repmat([2 1 1], length(Int), 1) Int']')); 
title('DALY Rate of Age-Standardized Group Due to Cardiovascular Diseases & Low Physical Activity'); 
xlabel('Time')
ylabel('DALY Rate')
legend('Actual Data', 'ANN Prediction')

subplot(3,3, 2)
PredInd = find(X(:,1) == 1 & X(:,2) == 1 & X(:,3) == 1); 
Time = X(PredInd, 4);
DALY = Y(PredInd);
plot(Time, DALY, 'o'); hold on; 
plot(Int, Mdl([repmat([1 1 1], length(Int), 1) Int']')); 

subplot(3,3, 3)
PredInd = find(X(:,1) == 1 & X(:,2) == 12 & X(:,3) == 4); 
Time = X(PredInd, 4);
DALY = Y(PredInd);
plot(Time, DALY, 'o'); hold on;
plot(Int, Mdl([repmat([1 12 4], length(Int), 1) Int']')); 


subplot(3,3, 4)
PredInd = find(X(:,1) == 1 & X(:,2) == 1 & X(:,3) == 15); 
Time = X(PredInd, 4);
DALY = Y(PredInd);
plot(Time, DALY, 'o'); hold on;
plot(Int, Mdl([repmat([1 1 15], length(Int), 1) Int']')); 

subplot(3,3, 5)
PredInd = find(X(:,1) == 1 & X(:,2) == 14 & X(:,3) == 4); 
Time = X(PredInd, 4);
DALY = Y(PredInd);
plot(Time, DALY, 'o'); hold on;
plot(Int, Mdl([repmat([1 14 4], length(Int), 1) Int']')); 

subplot(3,3, 6)
PredInd = find(X(:,1) == 1 & X(:,2) == 4 & X(:,3) == 2); 
Time = X(PredInd, 4);
DALY = Y(PredInd);
plot(Time, DALY, 'o'); hold on;
plot(Int, Mdl([repmat([1 4 2], length(Int), 1) Int']'));

subplot(3,3, 7)
PredInd = find(X(:,1) == 1 & X(:,2) == 14 & X(:,3) == 10); 
Time = X(PredInd, 4);
DALY = Y(PredInd);
plot(Time, DALY, 'o'); hold on;
plot(Int, Mdl([repmat([1 14 10], length(Int), 1) Int']'));

subplot(3,3, 8)
PredInd = find(X(:,1) == 2 & X(:,2) == 1 & X(:,3) == 2); 
Time = X(PredInd, 4);
DALY = Y(PredInd);
plot(Time, DALY, 'o'); hold on;
plot(Int, Mdl([repmat([2 1 2], length(Int), 1) Int']'));

subplot(3,3, 9)
PredInd = find(X(:,1) == 1 & X(:,2) == 1 & X(:,3) == 19); 
Time = X(PredInd, 4);
DALY = Y(PredInd);
plot(Time, DALY, 'o'); hold on;
plot(Int, Mdl([repmat([1 1 19], length(Int), 1) Int']'));
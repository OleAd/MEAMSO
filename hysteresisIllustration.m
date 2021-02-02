% This script illustrates hysteresis in the MEAMSO
% Supplementary Figure 1 uses plots from here


% This example goes linearly from 1 to 2 to 1

exData = [linspace(1,2,20), linspace(2,1,20)];
brainPrior = 1.25;
brainC = 2;
exOutput=[];
exStates=[];

for n=1:length(exData)
    
    bestModel = exData(n);
    % Bayesian averageing
    brainStateMean = bayesianUpdateAverage(bestModel, brainC, brainPrior);
    % Update prior
    brainPrior = (brainPrior + (diff([brainPrior, brainStateMean])*.5));
    % This is the main output state
    currState = round(brainStateMean);
    exStates=[exStates, brainStateMean];
    exOutput=[exOutput, currState];

end


% hysteresis plot
figure;
dexData = diff(exData);
dexStates = diff(exStates);
plot(exData, exStates, 'b')
xlabel('Input')
ylabel('Output')
hold on
quiver(exData(1:end-1), exStates(1:end-1),dexData, dexStates, 0)
xticks([1,1.25,1.5,1.75,2])
xlim([.9,2.1])
yticks([1,1.25,1.5,1.75,2])
ylim([.9,2.1])
yline(1.5)
xline(1.5)




% This example starts at state 1, 
% goes linearly from state 1 to state 2, 
% stays at state 2, and then goes back again,
% then stays at state 1

exData = [repmat(1,10,1)', linspace(1,2,30), repmat(2,10,1)', linspace(2,1,30), repmat(1,10,1)'];
brainPrior = 1.25;
brainC = 2;
exOutput=[];
exStates=[];

for n=1:length(exData)
    
    bestModel = exData(n);
    % Bayesian averageing
    brainStateMean = bayesianUpdateAverage(bestModel, brainC, brainPrior);
    % Update prior
    brainPrior = (brainPrior + (diff([brainPrior, brainStateMean])*.5));
    % This is the main output state
    currState = round(brainStateMean);
    exStates=[exStates, brainStateMean];
    exOutput=[exOutput, currState];

end

% time plot

figure;
plot(exData)
hold on
plot(exOutput)



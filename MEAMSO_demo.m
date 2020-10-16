%% Minimal MEAMSO implementation
%{

This code is used in Heggli et. al. A Metastable Attractor Model of
Self-Other integration (MEAMSO).

The code loads an example trial, and runs the MEAMSO on the trial.


Contact: Ole Adrian Heggli - oleheggli@gmail.com
This version: October 2020
%}


%% Read in data
% This is data transition from mutual adaptation to leading-following

mutToLeadAction = load('empiricalData/MutAdapt_to_LeadFoll_action.mat');
mutToLeadPerception = load('empiricalData/MutAdapt_to_LeadFoll_perception.mat');
mutToLeadAction = mutToLeadAction.mutToLeadAction;
mutToLeadPerception = mutToLeadPerception.mutToLeadPerception;


% Uncomment below to see plot.
%{
figure;
plot(diff(mutToLeadAction))
hold on
plot(diff(mutToLeadPerception))
%}
% 

%% Run MEAMSO

% Set prior and scaling (c) for the bayesian averaging
prior = 0;
c = 4;
% Set prior and scaling (c) for the bayesian averaging in the hysteresis loop.
brainPrior = 1.5;
brainC = 4;
% Set the max asynchrony for the instantaneous comparisons, and the slope.
instCompMS=50;
instCompSlope=20;

% Run the model
% This is from participant 2's perspective
output = runMEAMSObehavioural(mutToLeadPerception*1000, mutToLeadAction*1000, prior, c, brainPrior, brainC, instCompMS, instCompSlope);

% Collect the output
brainStateMean = output(:,13);
bestModel = output(:,6);
brainState = output(:,7);
uncertainty = output(:,10);

% Plot the output
% In the paper, this is the output for participant 2
figure;
plot(brainStateMean)
hold on
plot(brainState)

% Rerun the model
% This is from participant 1's perspective
output = runMEAMSObehavioural(mutToLeadAction*1000, mutToLeadPerception*1000, prior, c, brainPrior, brainC, instCompMS, instCompSlope);

% Collect the output
brainStateMean = output(:,13);
bestModel = output(:,6);
brainState = output(:,7);
uncertainty = output(:,10);

% Plot the output
% In the paper, this is the output for participant 1
figure;
plot(brainStateMean)
hold on
plot(brainState)
% 



%% Plot windowed cross correlation
actionITI=diff(mutToLeadAction);
perceptionITI=diff(mutToLeadPerception);
lagHolder=[];
for n=16:15:length(actionITI)
    thisWindowAction = actionITI(n-15:n);
    thisWindowPerception = perceptionITI(n-15:n);
    coeffs = crosscorr(thisWindowAction, thisWindowPerception,1);
    lagHolder=[lagHolder,coeffs];
end

figure;
for n=1:length(lagHolder)
    subplot(1,length(lagHolder),n)
    bar(lagHolder(:,n))
    ylim([-.9, .9])
end
% 

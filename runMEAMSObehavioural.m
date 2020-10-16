function output = runMEAMSObehavioural(action, perception, prior, c, brainPrior, brainC, ...
    maxInstCompTime, slopeInstCompTime)

    outputHolder = [];
    nPrevInstCompTime=[];
    ITIactions=[];
    ITIperceptions=[];
    thisCorrCompSim_zeroSig=0;
    thisCorrCompSim_minusoneSig=0;

    maxLength = min(length(action),length(perception));
    evidHolder = [];
    previousModel = 1;
    modHyst=0;
    currState = 1;
    bestCorr=0;
    corrEvidence=0;

    for n=1:maxLength
        thisAction=action(n);
        thisPerception=perception(n);
    %     Do instant comparison of time
        thisInstCompTime=instCompTime(thisAction, thisPerception,0,maxInstCompTime,slopeInstCompTime);
        thisInstCompAudFeature=instCompAudFeature();
    %     Add to memory
        nPrevInstCompTime=[nPrevInstCompTime,thisInstCompTime];
        meanPrevInstCompTime=mean(nPrevInstCompTime);
    %   Do n-back instantaneous comparison.
        bayesMeanInstCompTime = bayesianUpdateAverage(nPrevInstCompTime, c, prior);
        prior = bayesMeanInstCompTime;
        
    %     Check for length
        if length(nPrevInstCompTime)>4
            nPrevInstCompTime(1)=[];
        end
    %     Check if more than 2 events, to calculate ITIs.
        if n>=2
            thisITIaction=thisAction-previousAction;
            ITIactions=[ITIactions,thisITIaction];
            thisITIperception=thisPerception-previousPerception;
            ITIperceptions=[ITIperceptions,thisITIperception];
            if n>=4
                [thisCorrCompSimITI_zero,thisCorrCompSimITI_minusone, bounds] = corrCompSimITI(ITIactions, ITIperceptions);
                [bestCorr, bestLag] = max([thisCorrCompSimITI_minusone;thisCorrCompSimITI_zero]);
                % Set a correlation threshold
                if bestCorr >= 0.4
                    corrEvidence = bestCorr;
                else
                    corrEvidence = 0;
                end
            else
                thisCorrCompSim_zeroSig=0;
                thisCorrCompSim_minusoneSig=0;
                bestCorr=0;
            end

            if n>=8
                ITIactions(1)=[];
                ITIperceptions(1)=[];
            end


        end

        previousAction=thisAction;
        previousPerception=thisPerception;

        evidOne = 0;
        evidTwo = 0;
        % Scaling for evidence, instantaneous comparison
        if thisInstCompTime > 0
            evidOne = evidOne + (thisInstCompTime * .5);
        elseif thisInstCompTime < 0
            evidTwo = evidTwo + (abs(thisInstCompTime) * .5);
        end
        % Scaling for evidence, bayesian mean.
        if bayesMeanInstCompTime > 0
            evidOne = evidOne + (bayesMeanInstCompTime * .5);
        elseif bayesMeanInstCompTime < 0
            evidTwo = evidTwo + (abs(bayesMeanInstCompTime) * .5);
        end
        
        % Auditory features comparison is not implemented yet.
        if thisInstCompAudFeature > 0
            %evidOne = evidOne + thisInstCompAudFeature;
        elseif thisInstCompAudFeature < 0
            %evidTwo = evidTwo + abs(thisInstCompAudFeature);
        end
        
        % Correlation evidence + scaling.
        if corrEvidence > 0
            evidOne = evidOne + (corrEvidence * 1.25);
        else
            evidTwo = evidTwo + 0.25;
        end
        
        evidHolder = [evidHolder;evidOne,evidTwo];
        softMaxChoose = softmax([evidOne;evidTwo]);
        [~, bestModel] = max(softMaxChoose);
        % Measure uncertainty as difference in evidence
        thisUncertainty = abs(diff([evidOne, evidTwo]));

        % Bayesian averageing
        brainStateMean = bayesianUpdateAverage(bestModel, brainC, brainPrior);
        % Update prior
        brainPrior = (brainPrior + (diff([brainPrior, brainStateMean])*.5));
        % This is the main output state
        currState = round(brainStateMean);

        previousModel = bestModel;
        % Collect output
        outputHolder = [outputHolder; ...
            thisInstCompTime,thisInstCompAudFeature, ...
            meanPrevInstCompTime,thisCorrCompSim_zeroSig, ...
            thisCorrCompSim_minusoneSig,bestModel,currState, ...
            bayesMeanInstCompTime, corrEvidence, thisUncertainty, ...
            evidOne, evidTwo, brainStateMean, thisAction, thisPerception];

    end


output = outputHolder;



end
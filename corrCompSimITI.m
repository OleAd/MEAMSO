function [zeroCorr, minusCorr, bounds]=corrCompSimITI(inputsAction, inputsPerception)

    [corrs,~,bounds]=crosscorr(inputsAction,inputsPerception,1);
    corrs(isnan(corrs)) = 0;
    zeroCorr=abs(corrs(2));
    minusCorr=abs(corrs(1));

end
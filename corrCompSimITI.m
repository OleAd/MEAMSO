function [zeroCorr, minusCorr, bounds]=corrCompSimITI(inputsAction, inputsPerception)
    % FIX change to use regular corr, and manually shift
    
    % Check if crosscorr from the econometrics toolbox exist
    % If not, then use a simpler version
    
    isCrossCorr = exist('crosscorr');
    
    if isCrossCorr > 0
        [corrs,~,bounds]=crosscorr(inputsAction,inputsPerception,1);
        corrs(isnan(corrs)) = 0;
        zeroCorr=abs(corrs(2));
        minusCorr=abs(corrs(1));
    else
        warning('crosscorr.m function not found, reverting to fallback method!')
        if length(inputsActions) ~= length(inputsPerception)
            error('Differing length of action and perception arrays.Please pad your inputs, or use the crosscorr function from the econometrics toolbox.')
        end
        bounds=0;
        zeroCorr = abs(corr2(inputsAction, inputsPerception));
        minusCorr = abs(corr2(inputsAction(2:end), inputsPerception(1:end-1)));
        
    end

end
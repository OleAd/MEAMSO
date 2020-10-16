function output=instCompTime(thisAction,thisPerception, minLevel, maxLevel, rateOfChange)
    % Should output value close to 1 if deemed same, close to -1 if deemed
    % different.


    thisTimeDifference = thisPerception-thisAction;
    % Value is positive if perception follows action.
    % Value is negative if perception precedes action.


    if thisTimeDifference > 0
        output = reverseSigmoid(thisTimeDifference, minLevel, maxLevel, rateOfChange);
    elseif thisTimeDifference <= 0
        output = reverseSigmoid(abs(thisTimeDifference), minLevel, maxLevel*.5, rateOfChange);   
    end

end

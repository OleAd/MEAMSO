function output=reverseSigmoid(input, minLevel, maxLevel, rateOfChange)
    
    scaledInput = rescale(input, -1, 1, 'InputMin', minLevel, 'InputMax', maxLevel);
    output = 2./(1+exp(rateOfChange.*(scaledInput)))-1;

end

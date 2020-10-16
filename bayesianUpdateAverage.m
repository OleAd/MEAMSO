function bMean = bayesianUpdateAverage(data, c, prior)
    
    bMean = ((c*prior) + sum(data)) / (c + length(data));

end
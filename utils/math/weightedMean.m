function value = weightedMean( data, weights )

sumOfWeights = sum( weights );

if sumOfWeights == 0

    value = mean( data );

else
    
    weights = weights ./ sumOfWeights;
    value = weights' * data;

end

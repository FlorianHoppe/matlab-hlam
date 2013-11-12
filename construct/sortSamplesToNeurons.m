function [ setOfSamples, setOfWeights ] = sortSamplesToNeurons( app, neurons, data, weights )

if nargin < 4
   weights = ones( size( data, 1 ), 1 );
end

BMUs = getBestMatchingUnit( app, neurons, data );

for i = 1 : size( neurons, 1 )
    setOfSamples{ i, 1 } = [];
    setOfWeights{ i, 1 } = [];
end

for i = 1 : size( data, 1 )
    setOfSamples{ BMUs( i ), 1 } = [ setOfSamples{ BMUs(i) }; data( i, : ) ];
    setOfWeights{ BMUs( i ), 1 } = [ setOfWeights{ BMUs(i) }; weights( i, : ) ];
end

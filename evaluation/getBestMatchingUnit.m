function [ BMUs, distancesToNeurons ] = getBestMatchingUnit( app, neurons, data )

if size( neurons, 1 ) > 1
   
    distancesToNeurons = distanceToNeuron( app, neurons, data );
    [ discard BMUs ] = min( distancesToNeurons );
   
else

    distancesToNeurons = zeros( 1, size( data, 1 ) );
    BMUs = ones( 1, size( data, 1 ) );
    
end

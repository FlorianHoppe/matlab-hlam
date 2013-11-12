function distance = distanceToNeuron( app, neuron, data )

if size( neuron, 2 ) == size( data, 2 )
    distance = dist( neuron, data' );
else
    distance = dist( neuron, getGatingInput( app, data )' );
end

function [ newNeurons, newTrainsets, newErrorsets ] = redistributeSamplesToNeurons( app, neurons, trainsets, errorsets )

if size( trainsets{ 1 }, 1 ) < app.netInfo.minTrainSamples
   sourceID = 2; targetID = 1;
else
   sourceID = 1; targetID = 2;
end

numberOfSamplesToAdd = app.netInfo.minTrainSamples - size( trainsets{ targetID }, 1 );
distancesToNeuron = distanceToNeuron( app, neurons( targetID, : ), trainsets{ sourceID } );

samplesToAdd = [];
errorsToAdd = [];

for i = 1 : numberOfSamplesToAdd
    
    [ discard index ] = min( distancesToNeuron' );

    distancesToNeuron( index ) = [];
    
    samplesToAdd = [ samplesToAdd; trainsets{ sourceID }( index, : ) ];
    errorsToAdd = [ errorsToAdd; errorsets{ sourceID }( index, : ) ];
    
    trainsets{ sourceID, 1 }( index, : ) = [];
    errorsets{ sourceID, 1 }( index, : ) = [];
    
end

newTrainsets{ sourceID, 1 } = trainsets{ sourceID };
newTrainsets{ targetID, 1 } = [ trainsets{ targetID }; samplesToAdd ];

newErrorsets{ sourceID, 1 } = errorsets{ sourceID };
newErrorsets{ targetID, 1 } = [ errorsets{ targetID }; errorsToAdd ];

neu1 = weightedMean( getGatingInput( app, newTrainsets{ 1 } ), newErrorsets{ 1 } );
neu2 = weightedMean( getGatingInput( app, newTrainsets{ 2 } ), newErrorsets{ 2 } );

newNeurons = [ neu1; neu2 ];

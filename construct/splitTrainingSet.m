function gatingNeurons = splitTrainingSet( app, trainData, approximationErrorOfSamples )

absI = getGatingInput( app, trainData );

if nargin < 3
	weights = ones( size( trainData, 1 ), 1 );
else
	weights = approximationErrorOfSamples;
end

newAbsI = [];
newWeights = [];

while size( absI, 1 ) > 0
    
    sampleToAdd = absI(1, :);
    idx = find( eqRowWise( absI, sampleToAdd ) );
    absI( idx, : ) = [];

    weightToAdd = max( weights( idx ) );
    weights( idx ) = [];
    
    newAbsI = [ newAbsI; sampleToAdd ];   
    newWeights = [ newWeights; weightToAdd ];
    
end

if length( newWeights ) < 2
    
    display 'splitTrainingSet: Samples differ but not their generate input.'
    gatingNeurons = newAbsI;

else   

    rand( 'state', sum( 100 * clock ) );
    
    Ms = weightedKMeans( newAbsI', size( trainData, 2 ) , newWeights );
    gatingNeurons = Ms;

end

function candidatePairs = selectionCriterionClusterMaxSamples( app )

a          = -1;
maxSamples = -1;

for x = 1 : size( app.net.neighborhoodGraph, 1 )
   
    numOfSamples = sum( app.net.neighborhoodGraph( x, : ) );
   
    if numOfSamples > maxSamples
        a          = x;
        maxSamples = numOfSamples;
    end
    
end

candidatePairs( :, 2 ) = find( app.net.neighborhoodGraph( :, a ) );
candidatePairs( :, 1 ) = a;

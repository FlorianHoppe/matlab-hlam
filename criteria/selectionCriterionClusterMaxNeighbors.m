function candidatePairs = selectionCriterionClusterMaxNeighbors( app )

a            = -1;
maxNeighbors = -1;

for x = 1 : size( app.net.neighborhoodGraph, 1 )
    
    row = app.net.neighborhoodGraph( x, : );
    numOfNeighbors = length( find( row ) );
    
    if numOfNeighbors > maxNeighbors
        a            = x;
        maxNeighbors = numOfNeighbors;
    end
    
end

candidatePairs( :, 2 ) = find( app.net.neighborhoodGraph( :, a ) );
candidatePairs( :, 1 ) = a;

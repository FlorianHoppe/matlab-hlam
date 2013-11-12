function candidatePairs = selectionCriterionMax( app )

allPairsGraph = app.net.neighborhoodGraph .* triu( ones( size( app.net.experts, 1 ) ), 1 );

candidatePairs = zeros( size( allPairsGraph, 1 ), 2 );

for i = 1 : size( allPairsGraph, 1 )
    
   [ discard candidatePairs( i, 2 ) ] = max( allPairsGraph( i, : ) );
             candidatePairs( i, 1 )   = i;
   
end

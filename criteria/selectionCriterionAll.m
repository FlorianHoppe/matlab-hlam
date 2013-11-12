function candidatePairs = selectionCriterionAll( app )

allPairsGraph = app.net.neighborhoodGraph .* triu( ones( size( app.net.experts, 1 ) ), 1 );

[ candidatePairs( :, 1 ) candidatePairs( :, 2 ) ] = find( allPairsGraph );

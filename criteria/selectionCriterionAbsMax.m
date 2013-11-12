function candidatePairs = selectionCriterionAbsMax( app )

[ discard candidatePairs( 1, 1 ) candidatePairs( 1, 2 ) ] = extremeOfMatrix( app.net.neighborhoodGraph, @max );

function candidatePairs = selectionCriterionMinMax( app )

tmp = zeros( size( app.net.experts, 1 ), 1 );

for e = 1 : size( app.net.experts, 1 )
   tmp( e ) = size( app.net.experts{ e }.trainData, 1 );
end

[ discard s ] = min( tmp );

[ discard candidatePairs( :, 2 ) ] = max( app.net.neighborhoodGraph( :, s ) );
          candidatePairs( :, 1 )   = s;

function dists = getEllipsoidDistances( data, W, b, c )

dists = zeros( size( data, 1 ), 1 );

if nargin < 4
   
    for i = 1 : size( data, 1 )
        dists( i ) = ellipsoidDist( data( i, : ), W, b );
    end
   
else
       
    for i = 1 : size( data, 1 )
        dists( i ) = ellipsoidDist( data( i, : ), W, b, c );
    end
   
end

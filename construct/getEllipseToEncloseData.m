function [ W, b, c, threshold ] = getEllipseToEncloseData( data )

[ coeff score ] = princomp( data );

W = coeff;
b = mean( data, 1 );

if size( data, 1 ) ~= 1
    c = max( abs( score ) );
else
    c = zeros( size( data, 1 ), 1 );
end

dists = getEllipsoidDistances( data, W, b, c );

threshold = min( dists );

if threshold == 0
    disp( 'getEllipseToEncloseData: Domain diameter equals zero.' )
end

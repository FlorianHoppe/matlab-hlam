function isEqual = eqRowWise( matrix, vector )

isEqual = zeros( size( matrix, 1 ), 1 );

sz = size( vector, 2 );

for i = 1 : size( matrix, 1 )
    isEqual( i ) = sum( matrix( i, : ) == vector ) == sz;
end

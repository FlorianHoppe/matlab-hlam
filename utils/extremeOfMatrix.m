function [ val row col ] = extremeOfMatrix( M, FUN )

if nargin < 2, FUN = @max; end;

[ m mi ] = FUN( M );
[ val col ] = FUN( m );
row = mi( col );

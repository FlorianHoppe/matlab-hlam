function approxErrors = getExpertsApproximationError( app, expert, testData )

approxErrors = zeros( size( testData, 1 ), 1 );

for i = 1 : size( testData, 1 )
    approxErrors(i) = getApproximationError( app, expert, testData(i, :) );
end

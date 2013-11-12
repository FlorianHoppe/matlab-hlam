function data = generateTestSamples( app, data )

tmp = union( app.dataSample.targetOutputIndices, app.dataSample.outputIndices );
data( :, tmp ) = zeros( size( data, 1 ), length( tmp ) );

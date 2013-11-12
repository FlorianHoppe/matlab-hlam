function [ in, out ] = getExpertInputOutput( app, data )

in  = data( :, app.dataSample.modelSpaceIndices );
out = data( :, app.dataSample.targetOutputIndices );

function [ error expID numOfMatchingExperts ] = getApproximationError( app, data, expert )

question = generateTestSamples( app, data );

if nargin < 3
    [ answer expID numOfMatchingExperts ] = getNetAnswer( app, question );
else
    answer = getExpertAnswer( app, question, expert );
end

error = dist( answer( :, app.dataSample.outputIndices ), data( :, app.dataSample.targetOutputIndices )' );

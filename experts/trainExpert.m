function expert = trainExpert( app, data )

if isfield( app.netInfo, 'orderOfPolynom' )
    orderOfPolynom = app.netInfo.orderOfPolynom;
else
    orderOfPolynom = 1;  
end

if isfield( app.netInfo, 'nFoldCrossValidation' )
    
    setIndices = generateNFoldSetIndices( app.netInfo.nFoldCrossValidation, size( data, 1 ) );

    expert.meanTrainingError = 0;
    
    for i = 1 : app.netInfo.nFoldCrossValidation

        trainSet = data( setIndices ~= i, : );
        testSet = data( setIndices == i, : );

        [ in out ] = getExpertInputOutput( app, trainSet );
        expert.C  = linearRegression( [ in out ], size( app.dataSample.outputIndices, 2 ), orderOfPolynom );

        singleTestError = 0;

        for k = 1 : size( testSet, 1 )
            singleTestError = singleTestError + getExpertsApproximationError( app, expert, testSet( k, : ) );
        end

        singleTestError = singleTestError / size( testSet, 1 );
        expert.meanTrainingError  = expert.meanTrainingError + singleTestError;
    
    end
    
    expert.meanTrainingError = expert.meanTrainingError / app.netInfo.nFoldCrossValidation;

    [ in out ] = generateExpertInputOutput( app, data );
    [ expert.C discard allTrainingErrors ] = linearRegression( [ in out ], size( app.dataSample.outputIndices, 2 ), orderOfPolynom );

    expert.allTrainingErrors = allTrainingErrors;
    
else
  
    [ in out ] = getExpertInputOutput( app, data );
    [ expert.C discard allTrainingErrors ] = linearRegression( [ in out ], size( app.dataSample.outputIndices, 2 ), orderOfPolynom );

    expert.meanTrainingError = mean( allTrainingErrors );
    expert.stdTrainingError = std( allTrainingErrors );
    expert.allTrainingErrors = allTrainingErrors;
    
end

expert.trainData = data;
expert.numOfTrainingSamples = size( data, 1 );

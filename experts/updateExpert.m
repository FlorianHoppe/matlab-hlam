function app = updateExpert( app, expID, sample )

trainData = app.net.experts{ expID }.trainData;

if size( trainData, 1) < app.netInfo.sizeOfHistoryBuffer
    
    trainData( size( trainData, 1 ) + 1, : ) = sample; % append sample
    
else

    trainData( 1, : ) = sample;                   % overwrite first
                                                  % (=oldest) sample
    
    trainData = circshift( trainData, [ -1 0 ] ); % shift traindata one up,
                                                  % thus moving the updated
                                                  % sample to the "most
                                                  % recent" position
    
end

expert = trainExpert( app, trainData );

expert.trainData = trainData;
expert.numOfTrainingSamples = size( trainData, 1 );

expert.neuron = mean( getGatingInput( app, trainData ) );

if strcmp(app.netInfo.domainType, 'HED')

    [ expert.domainModel.eigenSpace ...
      expert.domainModel.position   ...
      expert.domainModel.variance   ...
      expert.domainModel.minDistance ] = getEllipseToEncloseData( getGatingInput( app, trainData ) );

end

if strcmp(app.netInfo.domainType, 'SVM')

    [ expert.domainModel.SVM         ...
      expert.domainModel.minDistance ...
      expert.domainModel.sparseness ] = getSVMToEncloseData( app, getGatingInput( app, trainData ) );

end

app.net.experts{ expID, 1 } = expert;

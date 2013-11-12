function app = addNewExpert( app, trainData )

% create expert
expert = trainExpert( app, trainData );

% standard neuron initialization
expert.trainData = trainData;
expert.numOfTrainingSamples = size( trainData, 1 );
expert.neuron = mean( getGatingInput( app, trainData ), 1 );

% store enclosing ellipse
if (strcmp(app.netInfo.domainType, 'HED'))
  
    [ expert.domainModel.eigenSpace   ...
      expert.domainModel.position     ...
      expert.domainModel.variance     ...
      expert.domainModel.minDistance ] = getEllipseToEncloseData( getGatingInput( app, trainData ) );
  
end

% store enclosing SVM
if (strcmp(app.netInfo.domainType, 'SVM'))

    [ expert.domainModel.SVM         ...
      expert.domainModel.minDistance ...
      expert.domainModel.sparseness ] = getSVMToEncloseData( app, getGatingInput( app, trainData ) );
  
end

% add expert
if ~isfield( app, 'net' )
    
    % create net and add expert
    app.net.experts{ 1 } = expert;
    app.net.gatingNeurons = expert.neuron;
    
    % create neuron mapping
    app.net.neuronToExpertMap = 1;
    
else

    % add expert to existing net
    app.net.experts{ size( app.net.experts, 1 ) + 1, 1 } = expert;
    app.net.gatingNeurons = [ app.net.gatingNeurons; expert.neuron ];
    
    % update neuron mapping
    app.net.neuronToExpertMap( size( app.net.gatingNeurons, 1 ) ) = size( app.net.experts, 1 );
     
end

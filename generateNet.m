function app = generateNet( app, trainData )

%% offline algorithm
%
if strcmp(app.learningAlgorithmType, 'offline')
   
    tic;
    
    % create first expert
    firstExpert = trainExpert( app, trainData );
    firstExpert.neuron = mean( getGatingInput( app, trainData ) );
    
    % optimize expert, results in even more experts
    finalExperts = optimizeExpert( app, firstExpert, trainData );

    % pre-allocate matrix
    app.net.gatingNeurons = zeros( size( finalExperts, 1 ), size( firstExpert.neuron, 2 ) );
    trainingErrorOfExperts = zeros( size( finalExperts, 1 ), 1 );
    
    % copy experts and merge neurons into one matrix
    for e = 1 : size( finalExperts, 1 )
        
        app.net.experts{ e, 1 }       = finalExperts{ e };
        app.net.gatingNeurons( e, : ) = finalExperts{ e }.neuron;
        
        trainingErrorOfExperts( e )   = finalExperts{ e }.meanTrainingError;
        
    end
    
    % measure time
    app.net.timeNeededForTraining = toc;

    % set error statistics
    app.net.meanTrainingErrorOfExperts = mean( trainingErrorOfExperts );
    app.net.stdTrainingErrorOfExperts  = std( trainingErrorOfExperts );
    
end

%% online algorithm
%
if strcmp(app.learningAlgorithmType, 'online')

    tic;
    
    sampleSinceLastFusion = 0;
	
    % feed one sample at a time
    for i = 1 : size( trainData, 1 )
        
        % update net
        app = updateNet( app, trainData( i, : ) );
        sampleSinceLastFusion = sampleSinceLastFusion + 1;

        % fuse, if applicable
        if isfield( app.netInfo, 'numOfSamplePassedForOnlineFusion' ) ...
            && sampleSinceLastFusion >= app.netInfo.numOfSamplePassedForOnlineFusion
            
            disp( sprintf( 'Calling fusion algorithm for sample no. %d...', i ) );
            
            app = removeRedundantModel( app, app.netInfo.fuseCriterion );
            sampleSinceLastFusion = 0;
            
        end
        
    end

    % measure time
    app.net.timeNeededForTraining = toc;
    
end

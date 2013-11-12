function experiment = evaluateExperiment( app, data, plotIt )

if nargin < 3, plotIt = 0; end

% create experiment
experiment.app = app;

% error for each sample
err = zeros( size( data, 1 ), 1 );

% expert stats
experiment.matchingExpertsPerSample = zeros( size( data, 1 ), 1 );
experiment.usageOfExpert.hits       = zeros( size( app.net.experts, 1 ), 1 );

% calculate errors
for i = 1 : size( data, 1 )
    
    [ err(i) expID experiment.matchingExpertsPerSample(i) ] = getApproximationError( app, data( i, : ) );

    experiment.usageOfExpert.hits( expID ) = experiment.usageOfExpert.hits( expID ) + 1;

end

% more stats
experiment.ME   = mean( err );
experiment.std  = std( err );
experiment.MSE  = mean( err .^ 2 );
experiment.RMSE = experiment.MSE ^ .5;
experiment.maxE = max( err );

% even more stats
experiment.usageOfExpert.maxHits      = max( experiment.usageOfExpert.hits );
experiment.usageOfExpert.minHits      = min( experiment.usageOfExpert.hits );
experiment.usageOfExpert.medianHits   = median( experiment.usageOfExpert.hits );
experiment.usageOfExpert.meanHits     = mean( experiment.usageOfExpert.hits );
experiment.usageOfExpert.numOfNotUsed = sum( experiment.usageOfExpert.hits == 0 );

% perhaps a few more stats
if length( app.dataSample.targetOutputIndices ) == 1
   
	varianceOfOutput = var( data( :, app.dataSample.targetOutputIndices ) );
	experiment.nMSE = experiment.MSE / varianceOfOutput;

end

% plot?
if plotIt
    
    imgData = getGatingInput( app, data );
    plotWeightedSamples( imgData( :, 1 : 2 ), err );

    if strcmp(app.net.learningAlgorithmType, 'offline')

        ish = ishold;
        hold on;
        
        plot( app.net.gatingNeurons( :, 1 ), app.net.gatingNeurons( :, 2 ), 'xr', 'MarkerSize', 15 );
        axis( [ 0 1 0 app.image.height / app.image.width ] );
        
        title 'Test Data and its Approximation Error in Image Space';
        
        if ~ish, hold off, end;

    end

end

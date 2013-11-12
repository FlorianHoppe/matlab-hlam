function [ output expID numOfMatchingExperts ] = getNetAnswer( app, data )

if isfield( app.netInfo, 'withSmoothing' )

    [ matchingScores belongsTo ] = getAllExpertsMatchingScores( app, data );

    numOfMatchingExperts = sum( belongsTo );
    expID = 1;

    if isfield( app.netInfo, 'smoothingWithStrictMatchingScore' )
        
        matchingScores = matchingScores .* belongsTo;
        
    end

    if isfield( app.netInfo, 'smoothingWithNeighborhoodGraph' )
        
        bmx = getBestMatchingExpert( app, data );
        neighbors = app.net.neighborhoodGraph( :, bmx ) ~= 0;
        matchingScores = matchingScores .* neighbors;
        
    end

    matchingScores = matchingScores / sum( matchingScores ); % ./ ?
    
    onlyOutput = zeros( 1, size( app.dataSample.outputIndices, 2 ) );

    for e = 1 : size( app.net.experts, 1 )
        
        tmpOutput = matchingScores( e ) * getExpertAnswer( app, app.net.experts{ e }, data );
        onlyOutput = onlyOutput + tmpOutput( app.dataSample.outputIndices );
        
    end
    
    output = data;
    output( app.dataSample.outputIndices ) = onlyOutput;

else
    
    [ bmx sndBmx any belongsTo ] = getBestMatchingExpert( app, data );

    numOfMatchingExperts = sum( belongsTo );

    if bmx == 0
        output( app.dataSample.outputIndices ) = inf;
    else
        output = getExpertAnswer( app, data, app.net.experts{ bmx } );
    end

    expID = bmx;
    
end

if isfield( app.dataSample, 'discreteOutputIndices' )
    
    output( app.dataSample.outputIndices( app.dataSample.discreteOutputIndices ) ) = round( output( app.dataSample.outputIndices( app.dataSample.discreteOutputIndices) ) );
    
end

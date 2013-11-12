function [ bmx, sndBmx, matchingScoresSave, belongsTo ] = getBestMatchingExpert( app, data )

if ~isfield( app, 'net' )

    bmx = 0;
    sndBmx = 0;
    matchingScoresSave = [];
    belongsTo = [];

    return;
   
end

if (strcmp(app.netInfo.domainType, 'CD'))
    
    bmx = bestMatchingUnit( app, app.net.gatingNeurons, data );

    if isfield( app.net, 'neuronToExpertMap' )
        bmx = app.net.neuronToExpertMap( bmx );
    end

    sndBmx = bmx;
    matchingScoresSave = [];
    belongsTo = [];
    
    return;

end
   
[ matchingScoresSave belongsTo relativeMatchingScores ] = getAllExpertsMatchingScores( app, data );

if ~isfield( app.netInfo, 'relativeActivationGatingLaw' )
    matchingScores = matchingScoresSave;
else
    matchingScores = relativeMatchingScores;
end

if isfield( app.netInfo, 'domainParameters' ) ...
    && isfield( app.netInfo.domainParameters, 'onlyMaxScoreDecision' ) ...
    && app.netInfo.domainParameters.onlyMaxScoreDecision == 1

    [ discard bmx ] = max( matchingScores );
    matchingScores( bmx ) = realmin;
    [ discard sndBmx ] = max( matchingScores );

else

    if sum( belongsTo ) == 0 % i.e. outlier detected

        if isfield( app.netInfo, 'rejectOutlier' )
            
            error( 'outlier detected' );
            
        else

            if (isfield( app.netInfo, 'domainParameters' ) ...
                 && isfield( app.netInfo.domainParameters, 'maxScoreDecisionForOutliers' ) ...
                 && app.netInfo.domainParameters.maxScoreDecisionForOutliers == 1)
                
                [ discard bmx ] = max( matchingScores ); % max score decision for outliers
                
            else

                bmx = getBestMatchingUnit( app, app.net.gatingNeurons, data ); % NN decision for outliers
                
            end

            if isfield( app.net, 'neuronToExpertMap' )
                bmx = app.net.neuronToExpertMap( bmx );
            end

            sndBmx = bmx;

        end
    else

        % bestimmt wird derjenige Experte, der den besten matching score hat und in dessen Domain d liegt:
        
        idx = 1 : size( app.net.experts, 1 );

        matchingScores( ~belongsTo ) = [];
        idx( ~belongsTo ) = [];
        
        [ discard bmxIdx ] = max( matchingScores );

        bmx = idx( bmxIdx );

        if size( matchingScores, 1 ) == 1
            
            sndBmx = bmx;
            
        else

            matchingScores( bmxIdx ) = [];
            idx( bmxIdx ) = [];
            
            [ discard sndBmxIdx ] = max( matchingScores );
            sndBmx = idx( sndBmxIdx );
            
        end

    end
end

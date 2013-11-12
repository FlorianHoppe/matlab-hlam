function app = updateNet( app, sample )

if app.netInfo.sizeOfHistoryBuffer < app.netInfo.minTrainSamples
    app.netInfo.minTrainSamples = app.netInfo.sizeOfHistoryBuffer;
end

error = getSmallestExpertError( app, sample );

% performance good?
if error <= app.netInfo.maxError

    % updated matched expert
    bestExpID = getBestMatchingExpert( app, sample );
    app = updateExpert( app, bestExpID, sample );

else

    % no net?
    if ~isfield( app, 'net' )

        % collect training data
        if ~isfield( app, 'unusedTrainData' )
            app.unusedTrainData = sample;
        else
            app.unusedTrainData = [ app.unusedTrainData; sample ];
        end

        % create net and add expert
        if size( app.unusedTrainData, 1 ) >= app.netInfo.minTrainSamples
            app = addNewExpert( app, app.unusedTrainData );
            app.unusedTrainData = [];
        end

    else

        [ bestExpID, discard, discard, belongsTo ] = getBestMatchingExpert( app, sample );

        % bad performance, update expert?
        if belongsTo( bestExpID )

            app = updateExpert( app, bestExpID, sample );

            % counter
            if ~isfield( app, 'badPerformaceAlthoughBelongsTo' )
                app.badPerformaceAlthoughBelongsTo = 1;
            else
                app.badPerformaceAlthoughBelongsTo = app.badPerformaceAlthoughBelongsTo + 1;
            end

        end

        % update training data and create graph
        app.unusedTrainData = [ app.unusedTrainData; sample ];
        [ neighborhoodGraph samplesToGraphMapping ] = growEdgesBetweenExperts( app, app.unusedTrainData );

        [ val id1 id2 ] = extremeOfMatrix( neighborhoodGraph );

        % add new expert, if enough samples available
        if val >= app.netInfo.minTrainSamples

            sampleToUse = app.unusedTrainData( samplesToGraphMapping{ id1, id2 }, : );
            app.unusedTrainData( samplesToGraphMapping{ id1, id2 }, : ) = [];

            app = addNewExpert( app, sampleToUse );
            
        end
        
    end
end

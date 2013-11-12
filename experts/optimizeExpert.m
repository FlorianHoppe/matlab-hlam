function newExperts = optimizeExpert( app, expert, trainData )

if expert.meanTrainingError > app.netInfo.maxError ...
    && size( trainData, 1 ) >= app.netInfo.minTrainSamples * 2

    newNeurons = splitTrainingSet( app, trainData, expert.allTrainingErrors );

    if size( newNeurons, 1 ) == 1
        
        newExperts{ 1 } = fixDomainOfExpert( app, expert, trainData );
        
    else

        trainsets = sortSamplesToNeurons( app, newNeurons, trainData, expert.allTrainingErrors );

%         if ~isfield( app.netInfo, 'allowBadSplitting' )
% 
%             badSplitting = 0;
% 
%             for i = 1 : size( newNeurons, 1 )
%                 if size( trainsets{ i }, 1 ) < app.netInfo.minTrainSamples
%                     badSplitting = 1;
%                 end
%             end
% 
%             if badSplitting
%                 [ newNeurons trainsets ] = redistributeSamplesToNeurons( app, newNeurons, trainsets, errorsets );
%                 display(trainsets)
%             end
% 
%         end

        expertIndex = 1;

        for i = 1 : size( newNeurons, 1 )

            tmpExpert  = trainExpert( app, trainsets{ i } );
            tmpExperts = optimizeExpert( app, tmpExpert, trainsets{ i } );

            for e = 1 : size( tmpExperts, 1 )

                newExperts{ expertIndex, 1 } = tmpExperts{ e };
                expertIndex = expertIndex + 1;

            end

        end

    end

else

    newExperts{ 1 } = fixDomainOfExpert( app, expert, trainData );

end

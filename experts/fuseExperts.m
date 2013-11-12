function fusedExpert = fuseExperts( app, exp1, exp2 )

fusedExpert = trainExpert( app, [ exp1.trainData; exp2.trainData ] );
fusedExpert.trainData = [ exp1.trainData; exp2.trainData ];

if fusedExpert.meanTrainingError >= app.netInfo.maxError
    
    fusedExpert = 0;
    
else

    fusedExpert.wasFused = 1;

    if isfield( exp1, 'neuron' )
        fusedExpert.neurons = exp1.neuron;
    else
        fusedExpert.neurons = exp1.neurons;
    end

    if isfield( exp2, 'neuron' )
        fusedExpert.neurons = [ fusedExpert.neurons; exp2.neuron ];
    else
        fusedExpert.neurons = [ fusedExpert.neurons; exp2.neurons ];
    end

    if ~strcmp( app.netInfo.domainType, 'CD' )
        
        if isfield( exp1, 'domainModel' )
            fusedExpert.domainModels{ 1 } = exp1.domainModel;
        else
            fusedExpert.domainModels = exp1.domainModels;
        end
        
        if isfield( exp2, 'domainModel' )
            
            fusedExpert.domainModels{ size( fusedExpert.domainModels, 1 ) + 1, 1 } = exp2.domainModel;
            
        else

            tmpAlreadyAddedModels = size( fusedExpert.domainModels, 1 );
            
            for i =  1 : size( exp2.domainModels, 1 )
                fusedExpert.domainModels{ tmpAlreadyAddedModels + i, 1 } = exp2.domainModels{ i };
            end
            
        end
    end

end

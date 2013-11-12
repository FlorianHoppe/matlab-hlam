function expert = fixDomainOfExpert( app, expertWithoutDomain, trainData )

expert = expertWithoutDomain;

if (strcmp( app.netInfo.domainType, 'HED' ))
  
    [ expert.domainModel.eigenSpace    ...
      expert.domainModel.position      ...
      expert.domainModel.variance      ...
      expert.domainModel.minDistance ] = getEllipseToEncloseData( getGatingInput( app, trainData ) );
  
end

if (strcmp( app.netInfo.domainType, 'SVM' ))
    
    [ expert.domainModel.SVM         ...
      expert.domainModel.minDistance ...
      expert.domainModel.sparseness ] = getSVMToEncloseData( app, getGatingInput( app, trainData ) );
end

if (~strcmp( app.netInfo.domainType, 'CD' ))
   
    expert.domainModel.maxMatchingScoreOfTrainingSet = 0;

    for i = 1 : size( trainData, 1 )

        currentMatchingScore = getExpertsMatchingScore( app, expert, trainData( i, : ) );
        
        if expert.domainModel.maxMatchingScoreOfTrainingSet < currentMatchingScore
            expert.domainModel.maxMatchingScoreOfTrainingSet = currentMatchingScore;
        end
        
    end
   
end

if (strcmp( app.netInfo.domainType, 'CD' ))
    expert.neuron = mean( getGatingInput( app, trainData ) );
end

if (strcmp( app.netInfo.domainType, 'HED' ))
    expert.neuron = mean( getGatingInput( app, trainData ) );
end

if (strcmp( app.netInfo.domainType, 'SVM' ))
    expert.neuron = mean( expert.domainModel.SVM.supportVectors );
end

expert.allTrainingErrors = [];

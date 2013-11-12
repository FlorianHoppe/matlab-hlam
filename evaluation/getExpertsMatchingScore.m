function [ score, belongsTo, relativeScore ] = getExpertsMatchingScore( app, expert, data )

gd = getGatingInput( app, data );

if isfield( expert, 'wasFused' )
   
    score = -inf;
    
    for i = 1 : size( expert.domainModels, 1 )

        if strcmp( app.netInfo.domainType, 'HED' )
            
            tmpScore = ellipsoidDist( gd, expert.domainModels{ i }.eigenSpace, expert.domainModels{i}.position, expert.domainModels{ i }.variance );
            
        end

        if strcmp( app.netInfo.domainType, 'SVM' )

            kernel = 'gaussian';
            kerneloption = app.netInfo.domainParameters.muForGaussianSVMKernel;
            
            tmpScore = svmoneclassval( gd, expert.domainModels{ i }.SVM.supportVectors, expert.domainModels{ i }.SVM.alphas, 1, kernel, kerneloption );
            
        end

        if tmpScore > score

            score = tmpScore;
            belongsTo = score >= expert.domainModels{ i }.minDistance;

            if isfield( app.netInfo, 'relativeActivationGatingLaw' ) && expert.domainModels{ i }.maxMatchingScoreOfTrainingSet ~= 0
                relativeScore = score / expert.domainModel.maxMatchingScoreOfTrainingSet;
            else
                relativeScore = score;
            end
            
        end
    
    end
    
else
    
    if (strcmp( app.netInfo.domainType, 'CD' ))
        
        score = exp( -distanceToNeuron( app, expert.neuron, data ) );
        belongsTo = 1;
        relativeScore = score;
        
    else

        if strcmp( app.netInfo.domainType, 'HED' )
            
            score = ellipsoidDist( gd, expert.domainModel.eigenSpace, expert.domainModel.position, expert.domainModel.variance );
            
        end
        
        if strcmp( app.netInfo.domainType, 'SVM' )
            
            kernel = 'gaussian';
            kerneloption = app.netInfo.domainParameters.muForGaussianSVMKernel;
            
            score = svmoneclassval( gd, expert.domainModel.SVM.supportVectors, expert.domainModel.SVM.alphas, 1, kernel, kerneloption );
            
        end
        
        belongsTo = score >= expert.domainModel.minDistance;

        if isfield( app.netInfo, 'relativeActivationGatingLaw' ) && expert.domainModel.maxMatchingScoreOfTrainingSet ~= 0
            relativeScore = score / expert.domainModel.maxMatchingScoreOfTrainingSet;
        else
            relativeScore = score;
        end

    end

end

function [ expID1 expID2 fusedExpert ] = getBestUnifiedExpert( app, EXPERT_SELECTION_METHOD )

% assume failure
expID1      = -1;
expID2      = -1;
fusedExpert = -1;

% find candidates
candidatePairs = EXPERT_SELECTION_METHOD( app );

error = inf;

% fuse candidates and minimize error
for i = 1 : size( candidatePairs, 1 )
   
    expert = fuseExperts( app, app.net.experts{ candidatePairs( i, 1 } ), ...
                               app.net.experts{ candidatePairs( i, 2 } ) );

    % successful fusion
    if isstruct( expert ) && expert.meanTrainingError < error

        error = expert.meanTrainingError;

        expID1 = candidatePairs( i, 1 );
        expID2 = candidatePairs( i, 2 );
        fusedExpert = expert;
        
    end
    
end

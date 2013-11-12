function app = removeRedundantModel( app, EXPERT_SELECTION_METHOD )

% return, if only one expert available
if length( app.net.experts ) == 1
   app.net.neighborhoodGraph = 0;
   return;
end

% build neighborhood graph
app.net.neighborhoodGraph = growEdgesBetweenExperts( app );

% try fusion
[ expID1 expID2 fusedExpert ] = getBestUnifiedExpert( app, EXPERT_SELECTION_METHOD );

% was fused
if isstruct( fusedExpert )
   
    disp( sprintf( 'Fused expert %d with expert %d.', expID1, expID2 ) );

    % rebuild expert collection, beginning with fused expert
    newExperts{ 1, 1 } = fusedExpert;
    
    % add remaining experts
    expertID = 2;
    
    for e = 1 : size( app.net.experts, 1 )
        if e ~= expID1 && e ~= expID2
            newExperts{ expertID, 1 } = app.net.experts{ e };
            expertID = expertID + 1;
        end
    end
    
    % replace experts
    app.net.experts = newExperts;

    % rebuild neuron collection and map
    app.net.gatingNeurons = [];
    app.net.neuronToExpertMap = [];

    for e = 1 : length( app.net.experts )
        if ~isfield( app.net.experts{e}, 'wasFused' )
            app.net.gatingNeurons     = [ app.net.gatingNeurons; app.net.experts{e}.neuron ];
            app.net.neuronToExpertMap = [ app.net.neuronToExpertMap; e ];
        else
            app.net.gatingNeurons     = [ app.net.gatingNeurons; app.net.experts{e}.neurons ];
            app.net.neuronToExpertMap = [ app.net.neuronToExpertMap; e * ones( size( app.net.experts{e}.neurons, 1 ), 1 ) ];
        end
    end

    % try fusing another pair
    app = removeRedundantModel( app, EXPERT_SELECTION_METHOD );
   
end

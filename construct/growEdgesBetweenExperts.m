function [ graph samplesToGraphMapping ] = growEdgesBetweenExperts( app, data )

% create default neuron map
if ~isfield( app.net, 'neuronToExpertMap' )
    app.net.neuronToExpertMap = ( 1 : size( app.net.gatingNeurons, 1 ) )';
end

% pre-allocate neighborhood graph
graph = zeros( size( app.net.experts, 1 ) );

if nargin < 2 
   
    for e = 1 : size( app.net.experts, 1 )

        distances = dist( app.net.gatingNeurons, getGatingInput( app, app.net.experts{ e }.trainData )' );

        for i = 1 : size( distances, 2 )

            % find and mark nearest neuron for sample i
            [ discard minID1 ] = min( distances( :, i ) );
            distances( minID1, i ) = realmax;

            % find next nearest neuron belonging to a different expert
            go_on = 1;
            
            while go_on
                
                [ discard minID2 ] = min( distances( :, i ) );
                distances( minID2, i ) = realmax;
                
                if app.net.neuronToExpertMap( minID1 ) ~= app.net.neuronToExpertMap( minID2 )
                    go_on = 0;
                end
                
            end
            
            % map neurons to expert
            id1 = app.net.neuronToExpertMap( minID1 );
            id2 = app.net.neuronToExpertMap( minID2 );

            % grow (undirected) edge between expert
            graph( id1, id2 ) = graph( id1, id2 ) + 1;
            graph( id2, id1 ) = graph( id2, id1 ) + 1;

        end

    end
   
else
   
    % only one expert available
    if size( app.net.experts, 1 ) == 1
        
        % cont every sample for this one expert
        graph( 1, 1 ) = size( data, 1 );
        samplesToGraphMapping{ 1, 1 } = ( 1 : size( data, 1 ) )';
        
        return;
        
    end

    distances = dist( app.net.gatingNeurons, getGatingInput( app, data )' );
    samplesToGraphMapping{ size( app.net.experts, 1 ), size( app.net.experts, 1 ) } = [];

    for i = 1 : size( distances, 2 )

        % find and mark nearest neuron for sample i
        [ discard minID1 ] = min( distances( :, i ) );
        distances( minID1, i ) = realmax;

        % find next nearest neuron belonging to a different expert
        go_on = 1;

        while go_on

            [ discard minID2 ] = min( distances( :, i ) );
            distances( minID2, i ) = realmax;

            if app.net.neuronToExpertMap( minID1 ) ~= app.net.neuronToExpertMap( minID2 )
                go_on = 0;
            end

        end
        
        % map neurons to expert
        id1 = app.net.neuronToExpertMap( minID1 );
        id2 = app.net.neuronToExpertMap( minID2 );

        % grow (undirected) edge between expert
        graph( id1, id2 ) = graph( id1, id2 ) + 1;
        graph( id2, id1 ) = graph( id2, id1 ) + 1;

        % map samples to graph
        if isempty( samplesToGraphMapping{ id1, id2 } )
            samplesToGraphMapping{ id1, id2 } = i;
            samplesToGraphMapping{ id2, id1 } = i;
        else
            samplesToGraphMapping{ id1, id2 } = [ samplesToGraphMapping{ id1, id2 }; i ];
            samplesToGraphMapping{ id2, id1 } = [ samplesToGraphMapping{ id2, id1 }; i ];
        end
        
    end
    
end

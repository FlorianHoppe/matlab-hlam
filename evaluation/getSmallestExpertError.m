function [ error, bestExpID ] = getSmallestExpertError( app, sample )

error = inf;

if ~isfield( app, 'net' )
   
    bestExpID = 0;
    return;
    
end

for e = 1 : size( app.net.experts, 1 )
    
	tmp = getApproximationError( app, sample, app.net.experts{ e } );
   
    if tmp < error
        error = tmp;
        bestExpID = e;
    end
    
end

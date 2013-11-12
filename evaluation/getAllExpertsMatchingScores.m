function [ matchingScores, belongsTos, relativeMatchingScores ] = getAllExpertsMatchingScores( app, data )

if ~isfield( app, 'net' )
   
    matchingScores = realmin;
    belongsTos = 0;
    relativeMatchingScores = realmin;

    return;
    
end

matchingScores = zeros( length( app.net.experts ), 1 );
belongsTos = zeros( length( app.net.experts ), 1 );
relativeMatchingScores = zeros( length( app.net.experts ), 1 );

for i = 1 : length( app.net.experts )
    
    [ matchingScores(i) ...
      belongsTos(i)     ...
      relativeMatchingScores(i) ] = getExpertsMatchingScore( app, app.net.experts{ i }, data );
    
end

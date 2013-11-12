function dist = ellipsoidDist( x, W, b, a )

if size( x, 1 ) > 1
    
    dist = zeros( size( x, 1 ), 1 );
    
    for i = 1  : size( x, 1 )
        dist(i) = ellipsoidDist( x( i, : ), W, b, a ); 
    end
    
    return;
    
end

d = 0;
    
if nargin < 4
    
    for i = 1 : size( W, 1 )
        d = d + ( W( i, : ) * (x - b)' ) ^ 2;
    end
 
else
   
    for i = 1 : size( W, 1 )

        if a( i ) ~= 0
            
            d = d + ( W( i, : ) * (x - b)' / a( i ) ) ^ 2;
            
        else
            if x(i) - b(i) ~= 0
                d = inf;
            end
        end

    end   

end

dist = exp( -d );

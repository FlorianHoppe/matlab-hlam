function i = scaleR2I( r, dims, exponential )

minR = dims( 1 );
maxR = dims( 2 );

minI = dims( 3 );
maxI = dims( 4 );

if r > maxR
    i = maxI;
else

    if r < minR
        i = minI;
    else

        if nargin == 3
            
            i = maxI - floor( exp( -exponential * (r - minR) ) * (maxI - minI) );
            
        else
            
            if maxR ~= minR
                scale = (maxI - minI) / (maxR - minR);
                i = minI + floor( (r - minR) * scale );
            else
                i = minI + floor( ( maxI - minI ) / 2 );
            end

        end
    end
end

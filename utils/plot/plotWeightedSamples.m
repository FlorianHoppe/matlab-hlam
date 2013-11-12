function plotWeightedSamples( samples, weights )

if size( samples, 2 ) == 2
   
    minE = min( abs( weights ) ); 
    maxE = median( abs( weights ) ) * 4;

    ish = ishold;
    hold on;

    for i = 1  : size( samples, 1 )
        plot( samples(i, 1), samples(i, 2), 'b.', 'MarkerSize', scaleR2I( weights( i ), [ minE maxE 5 35 ] ) );
    end

    if ~ish, hold off, end;

end

function indices = generateNFoldSetIndices( sets, numOfSamples )

if sets > numOfSamples
   error 'generateNFoldSetIndices: less samples than sets to create!'
end

indices = zeros( numOfSamples, 1 );

m = floor( numOfSamples / sets );

for i = 1 : sets
   indices( ((i - 1) * m + 1) : i * m ) = i;
end

for i = 1 : mod( numOfSamples, sets )
   indices( i + m * sets ) = i;
end

indices = indices( randperm( numOfSamples ) );

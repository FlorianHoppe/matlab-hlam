function output = getExpertAnswer( app, sample, expert )

output = sample;

input = getExpertInput( app, sample );

if isfield( app.netInfo, 'orderOfPolynom' )
    orderOfPolynom = app.netInfo.orderOfPolynom;
else
    orderOfPolynom = 1;
end

dim = size( input, 2 );
in = ones( 1, orderOfPolynom * dim + 1 );

for o = 1 : orderOfPolynom
    in( (orderOfPolynom - o) * dim + 1 : (orderOfPolynom - o + 1) * dim ) = input .^ o;
end

for i = 1 : size( app.dataSample.outputIndices, 2 )
    output( app.dataSample.outputIndices( i ) ) = in * expert.C( :, i );
end

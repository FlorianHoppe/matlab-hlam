function [ C V err ] = linearRegression( data, dimOfOutput, degOfPolynom )

if nargin < 3, degOfPolynom = 1; end;
if nargin < 2, dimOfOutput = 1; end

if dimOfOutput >= size( data, 2 )
    dimOfOutput = 1;
end

dimOfInput = size( data, 2 ) - dimOfOutput;

dataInput = data( :, 1 : dimOfInput);
dataOutput = data( :, dimOfInput + 1 : size( data, 2 ) );

numOfSamples = size( data, 1 );

V = ones( numOfSamples, 1 );

for i = 1 : degOfPolynom
    V = [ dataInput .^ i V ];
end

C = [];
err = 0;

for i = 1 : dimOfOutput
    
   if size( V, 1 ) == 1

       coeffs = zeros( size( V, 2 ), 1 );
       coeffs( : ) = dataOutput( :, i );
       
       dimErr = 0;
      
   else

       s = warning('off', 'stats:regress:RankDefDesignMat');

       [ coeffs discard dimErr ] = regress( dataOutput( :, i ), V );
       warning(s);

   end

   C = [ C coeffs ];
   err = err + abs( dimErr );
   
end

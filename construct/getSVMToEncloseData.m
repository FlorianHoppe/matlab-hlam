function [ SVM minValue sparseness ] = getSVMToEncloseData( app, data )

kernel       = 'gaussian';
kerneloption = app.netInfo.domainParameters.muForGaussianSVMKernel;
nu           = app.netInfo.domainParameters.nu;
verbose      = 0;

[ SVM.supportVectors, SVM.alphas ] = svmoneclass( data, kernel, kerneloption, nu, verbose );

valOfSup = zeros( size( SVM.supportVectors, 1 ), 1 );

for i = 1 : size( SVM.supportVectors, 1 )
   valOfSup( i ) = svmoneclassval( SVM.supportVectors( i, : ), SVM.supportVectors, SVM.alphas, 0, kernel, kerneloption );
end

sparseness = size( SVM.supportVectors, 1 ) / size( data, 1 );

minValue = min( valOfSup );

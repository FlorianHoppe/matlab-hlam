function C = weightedKMeans( X, num_centers, weights, Init_centers )
% KMEANS K-means clustering algorithm.
% 
% Synopsis:
%  [model,y] = kmeans(X,num_centers)
%  [model,y] = kmeans(X,num_centers,Init_centers)
%
% Description:
%  [model,y] = kmeans(X,num_centers) runs K-means clustering 
%   where inital centers are randomly selected from the 
%   input vectors X. The output are found centers stored in 
%   structure model.
%   
%  [model,y] = kmeans(X,num_centers,Init_centers) uses
%   init_centers as the starting point.
%
% Input:
%  X [dim x num_data] Input vectors.
%  num_centers [1x1] Number of centers.
%  Init_centers [1x1] Starting point of the algorithm.
%    
% Output:
%  model [struct] Found clustering:
%   .X [dim x num_centers] Found centers.
%
%   .y [1 x num_centers] Implicitly added labels 1..num_centers.
%   .t [1x1] Number of iterations.
%   .MsErr [1xt] Mean-Square error at each iteration.
%
%  y [1 x num_data] Labels assigned to data according to 
%   the nearest center.
%
% Example:
%  data = load('riply_trn');
%  [model,data.y] = kmeans( data.X, 4 );
%  figure; ppatterns(data); 
%  ppatterns(model,12); pboundary( model );
%
% See also 
%  EMGMM, KNNCLASS.
%

% This file is based on the kmeans implementation included in the
% Statistical Pattern Recognition Toolbox by Vojtech Franc and Vaclav
% Hlavac

% Copyright (C) 1999-2006, Vojtech Franc and Vaclav Hlavac
% Czech Technical University Prague, Faculty of Electrical Engineering, 
% Center for Machine Perception. All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, is permitted provided that the following conditions
% are met:
% 
%  1. Redistributions of source code must retain the above copyright
%     notice, this list of conditions and the following disclaimer.
%  
%  2. Redistributions in binary form must reproduce the above copyright
%     notice, this list of conditions and the following disclaimer in
%     the documentation and/or other materials provided with the
%     distribution.
% 
%  3. The name of the authors and its contributors must not be used to 
%     endorse or promote products derived from this software without prior 
%     written permission. For written permission, please contact 
%     xfrancv@cmp.felk.cvut.cz.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND 
% ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
% THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A 
% PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE REGENTS
% OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
% LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
% DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
% THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
% (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

% (c) Statistical Pattern Recognition Toolbox, (C) 1999-2003,
% Written by Vojtech Franc and Vaclav Hlavac,
% <a href="http://www.cvut.cz">Czech Technical University Prague</a>,
% <a href="http://www.feld.cvut.cz">Faculty of Electrical engineering</a>,
% <a href="http://cmp.felk.cvut.cz">Center for Machine Perception</a>

% Modifications:
% 12-may-2004, VF

[dim,num_data] = size(X);

% random inicialization of class centers
%-----------------------------------------------
if nargin < 4,
  inx=randperm(num_data);
  model.X = X(:,inx(1:num_centers));
  model.y = 1:num_centers;
  model.K = 1;
end

model.fun = 'knnclass';

old_y = zeros(1,num_data);
t = 0;

% main loop
%-------------------------
while 1,
  
  t = t+1;
  
  % classificitation
  y = knnclass( X, model );
  
  % computation of class centers
  err = 0;
  for i=1:num_centers,
    inx = find(y == i);

    if ~isempty(inx),
      
      % compute approximation error
      ori = ((X(:,inx) - model.X(:,i)*ones(1,length(inx))).^2);
      qqq = weights(inx)' * ori';
      
      err = err + sum( sum( qqq ) );
      
      % compute new centers
      weights_selection  = weights( inx ) ./ sum( weights( inx ) );
      model.X(:,i) = X(:,inx) * weights_selection;
      
    end
  end

  % Number of iterations and Mean-Square Error 
  model.t = t;
  model.MsErr(t) = err/num_data;
  
  if sum( abs(y - old_y) ) == 0,
     C = model.X';
    return;
  end

  old_y = y;
end

C = model.X';
return;
% EOF

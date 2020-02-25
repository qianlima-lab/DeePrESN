function [ output_weights ] = train_reservoir( M, T )

% M : a matrix of Num_data*(1+Num_reservoirUnits)
% T :  a vector of Num_data*1
% Output_weights : a weight of (1+Num_reservoirUnits)*1

%  According by : MW=T
%  M'MW=M'T
%  W = (M'M)^{-1}M'T

lambda = 1.0e-4;
output_weights = pinv(M'*M+lambda.*eye(size(M,2)))*(M'*T);  

% output_weights = regress(T,M);

end
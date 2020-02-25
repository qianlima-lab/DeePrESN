function [ mappedX, R  ]= elmae( X, k )

%   INPUTS
%   X: Data matrix, of which each column is a point.
%   K: Dimension of reduced data.

%   OUTPUT
%   Y: Reduced data matrix.

% X{D, N} = w{D,d}H{d, N}


d = k;
D=size(X, 1);

% Randomly initialize H
w_temp = rand(D, d);
H = w_temp'*X;

%  According by : wH=X
lambda = 1.0e-5;
% disp(size(X))
% disp(size(H'))
w = (X*H')*pinv(H*H'+lambda.*eye(size(H,1)));  
R = w'; 

mappedX = R*X;

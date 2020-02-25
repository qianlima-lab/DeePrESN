function [ reservoir ] = generate_reservoir( nInputUnits, nInternalUnits, varargin )

reservoir.nInputUnits = nInputUnits;
reservoir.nInternalUnits = nInternalUnits;

reservoir.sparseDegree = 0.01;
reservoir.internalWeights_UnitSR = generate_internalweights(nInternalUnits, reservoir.sparseDegree);
reservoir.inputWeights = 2.0 * rand(nInternalUnits, nInputUnits)- 1;

reservoir.inputScaling  = ones(nInputUnits, 1);
reservoir.inputShift    = zeros(nInputUnits, 1);

reservoir.ActivationFunction = 'tanh';
reservoir.spectralRadius = 1 ;
reservoir.bias = 0.1; 
reservoir.leakage = 0.5; 
reservoir.noiseLevel = 0.0 ;

args = varargin; 
nargs= length(args);

for i=1:2:nargs
        switch args{i},
        case 'inputScaling', reservoir.inputScaling = args{i+1} ; 
        case 'inputShift', reservoir.inputShift = args{i+1} ; 
        case 'ActivationFunction',reservoir.ActivationFunction = args{i+1};
        case 'spectralRadius', reservoir.spectralRadius = args{i+1} ; 
        case 'sparseDegree', reservoir.sparseDegree = args{i+1} ; 
        case 'noiseLevel', reservoir.noiseLevel = args{i+1} ; 
        case 'leakage' , reservoir.leakage = args{i+1} ;    
        case 'bias', reservoir.bias = args{i+1} ;
        otherwise
            error('the option does not exist');
        end  
end

reservoir.internalWeights = reservoir.spectralRadius * reservoir.internalWeights_UnitSR;
reservoir.biasVector = 2*reservoir.bias*randn(reservoir.nInternalUnits, 1)-reservoir.bias;

% error checking
% check that inputScaling has correct format
if length(reservoir.inputScaling(:,1)) ~= reservoir.nInputUnits
    error('the size of the inputScaling does not match the number of input units'); 
end
if length(reservoir.inputScaling(1,:)) ~= 1
    error('inputScaling should be provided as a column vector of size nInputUnits x 1'); 
end
% check that inputShift has correct format
if length(reservoir.inputShift(:,1)) ~= reservoir.nInputUnits
    error('the size of the inputScaling does not match the number of input units'); 
end
if length(reservoir.inputShift(1,:)) ~= 1
    error('inputScaling should be provided as a column vector of size nInputUnits x 1'); 
end



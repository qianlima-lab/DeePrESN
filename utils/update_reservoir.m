function [ stateMatrix] = update_reservoir( reservoir, x, nForgetPoints)

assert(nForgetPoints>=0, 'nForgetPoints should be positive!')

nDataPoints = length(x(:,1));

if  nForgetPoints >= 0
        stateMatrix = zeros(nDataPoints - nForgetPoints, reservoir.nInternalUnits);
end

totalstate = zeros(reservoir.nInputUnits + reservoir.nInternalUnits, 1);

collectIndex = 0;
for i = 1:nDataPoints
        in = reservoir.inputScaling .* x(i,:)' + reservoir.inputShift;
        totalstate(reservoir.nInternalUnits+1:reservoir.nInternalUnits + reservoir.nInputUnits) = in;        
        previousInternalState = totalstate(1:(reservoir.nInternalUnits), 1);
        internalState = (1 -  reservoir.leakage) .* previousInternalState + reservoir.leakage.*...
                feval(reservoir.ActivationFunction , [ reservoir.internalWeights, reservoir.inputWeights] * totalstate) ;
        internalState = internalState + reservoir.noiseLevel * (rand(reservoir.nInternalUnits,1) - 0.5) ;
        totalstate = [internalState; in];
        if i > nForgetPoints
                collectIndex = collectIndex+1;
                stateMatrix(collectIndex,:) = internalState';
        end
end


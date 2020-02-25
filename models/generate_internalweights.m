function internalWeights = generate_internalweights(nInternalUnits, sparseDegree)

success = 0 ;                                               
while success == 0
    % following block might fail, thus we repeat until we obtain a valid
    % internalWeights matrix
    try
        internalWeights = sprand(nInternalUnits, nInternalUnits, sparseDegree);
        internalWeights(internalWeights ~= 0) = internalWeights(internalWeights ~= 0)  - 0.5;
        maxVal = max(abs(eigs(internalWeights,1)));
        internalWeights = internalWeights/maxVal;
        success = 1 ;
    catch
        success = 0 ; 
    end
end 
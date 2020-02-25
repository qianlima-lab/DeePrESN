function error = function_DeePrESN_w_ELMAE(parms)

%% parameter checking
num_parms = size(parms, 2);
assert(rem(num_parms, 3)== 0);
layers_res = num_parms/3;

% dimension reduction
techniques = {'PCA', 'MDS', 'ProbPCA', 'FactorAnalysis', 'GPLVM', 'Sammon', 'Isomap', ...
    'LandmarkIsomap', 'LLE', 'Laplacian', 'HessianLLE', 'LTSA', 'MVU', 'CCA', 'LandmarkMVU', ...
    'FastMVU', 'DiffusionMaps', 'KernelPCA', 'GDA', 'SNE', 'SymSNE', 'tSNE', 'LPP', 'NPE', ...
    'LLTSA', 'SPE', 'Autoencoder', 'LLC', 'ManifoldChart', 'CFA'};
dim_reduc_name = 'PCA';


%% network configuration
series = data_mnimum_daily_temperatures(1);
[ x_train, y_train, x_test, y_test ] = split_series(series, 1, 0, 1, 0.8, 1);

% initialize networks
assert(layers_res>1);

dim_encoder = 60;
nForgetPoints = 100;

try
    for i = 1:layers_res
            if  i ~= layers_res
                    if i ==1
                            nInputUnits{i} = size(x_train, 2);
                    else
                            nInputUnits{i} = dim_encoder;
                    end
                    nInternalUnits{i} = 300;
                    reservoir{i} = generate_reservoir(nInputUnits{i}, nInternalUnits{i}, 'spectralRadius', 0.95, ...
                            'inputScaling', 0.1*ones(nInputUnits{i},1), 'inputShift', 0.0001*ones(nInputUnits{i},1), ...
                            'leakage', 1, 'ActivationFunction', 'tanh', 'sparseDegree',0.1, 'bias', 0.05);
                    dim{i} = dim_encoder;
            elseif   i == layers_res
                    nInputUnits{i} = dim_encoder;
                    nInternalUnits{i} = 300;
                    reservoir{i} = generate_reservoir(nInputUnits{i}, nInternalUnits{i}, 'spectralRadius', 0.95, ...
                    'inputScaling', 0.1*ones(nInputUnits{i},1), 'inputShift', 0.0001*ones(nInputUnits{i},1), ...
                    'leakage', 1, 'ActivationFunction', 'tanh', 'sparseDegree',0.1, 'bias', 0.05);
            end

    end

    opts.numepochs =  20;
    opts.batchsize = 100;


    %% processing
    [ x_train, y_train, x_val, y_val ] = split_data_val( x_train, y_train, 0.8, opts.batchsize) ;         

    for j = 1:layers_res
            IS = parms((j-1)*3+1);
            SR = parms((j-1)*3+2);
            LK = parms((j-1)*3+3);

            if j == 1
                     reservoir{j}.inputScaling = IS;
            else
                     reservoir{j}.inputScaling = IS;
            end
            reservoir{j}.spectralRadius = SR;
            reservoir{j}.leakage = LK;

            reservoir{j}.internalWeights = reservoir{j}.spectralRadius * reservoir{j}.internalWeights_UnitSR;       
    end

    input_temp = x_train;
    for j = 1:layers_res
            if j~=layers_res              
                    input = input_temp;
                    [stateMatrix{j}] = update_reservoir( reservoir{j}, input, nForgetPoints);

                    [mappedX, mapping{j}] = compute_mapping_elmae(stateMatrix{j}, floor(dim{j}));

                    x_direct = input(nForgetPoints+1:end, :);
                    y_train = y_train(nForgetPoints+1:end,:);

                    input_temp = [ mappedX ];

            elseif j == layers_res
                    input = input_temp;
                    [stateMatrix{j}] = update_reservoir( reservoir{j}, input, nForgetPoints);      

                    x_direct = input(nForgetPoints+1:end, :);
                    y_train = y_train(nForgetPoints+1:end,:);

                    % collect the direct information               
                    matrix_collect = [stateMatrix{j}];
            end
    end

    % Traning phrase
    x_direct = [matrix_collect ones(size(matrix_collect, 1),1)];
    y_train = y_train;
    [ output_weights ] = train_reservoir( x_direct, y_train );  

    % Testing phrase
    input_temp = x_val;
    for j = 1:layers_res
            if j~=layers_res              
                    input = input_temp;
                    [stateMatrix{j}] = update_reservoir( reservoir{j}, input, nForgetPoints);

                    mappedX = out_of_sample_elmae(stateMatrix{j}, mapping{j});

                    x_direct = input(nForgetPoints+1:end, :);
                    y_val =y_val(nForgetPoints+1:end,:);

                    input_temp = [ mappedX ];

            elseif j == layers_res
                    input = input_temp;
                    [stateMatrix{j}] = update_reservoir( reservoir{j}, input, nForgetPoints);                

                    x_direct = input(nForgetPoints+1:end, :);
                    y_val = y_val(nForgetPoints+1:end,:);

                    % collect the direct information               
                    matrix_collect = [stateMatrix{j}];
            end
    end

    x_direct = [matrix_collect ones(size(matrix_collect, 1),1)];
    y_val = y_val;
    predicted_y =  x_direct * output_weights;
    error = error_measure( predicted_y(:,end), y_val(:,end), 'nrmse');

    format short
    disp(parms)
    fprintf('Training error = %f  ...\n', error);
    disp('----------------------------------------------------------------------------------------------------')

catch
    error = 1000;
end








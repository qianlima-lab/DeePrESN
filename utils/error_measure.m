function [ error ] = error_measure( input_signal, target_signal, type_string )

if nargin <1
        type_string = 'nrmse';
end

assert(length(input_signal)==length(target_signal), 'Their lengths are inqual....')

switch type_string
        case 'nrmse'
                %disp('Computing NRMSE ........')
                error = nrmse(input_signal, target_signal);
        case 'nmse'
                %disp('Computing NMSE ........')
                error = nmse(input_signal, target_signal);
        case 'rmse'
                %disp('Computing RMSE ........')   
                error = rmse(input_signal, target_signal);
        case 'mse'
                %disp('Computing MSE ........')
                error = mse(input_signal, target_signal);
        case 'mape'
                %disp('Computing MAPE ........')
                error = mape(input_signal, target_signal);
        case 'smape'
                %disp('Computing SMAPE ........')
                error = smape(input_signal, target_signal);        
        otherwise
                %disp('There is a invalid charater!')        
end    


function  [error] = nrmse(input_signal, target_signal)
        nPoints = length(input_signal) ;        
        var_y = var(target_signal);
        meanerror = sum((input_signal - target_signal).^2)/nPoints ;
        error = sqrt(meanerror/var_y);

function  [error] = mape(input_signal, target_signal)
        error_temp = target_signal - input_signal ; 
        error = mean(abs(error_temp./target_signal)) ;

function  [error] = smape(input_signal, target_signal)
        error_temp = target_signal - input_signal ;
        error_temp_2 = target_signal + input_signal ; 
        error = mean(abs(error_temp./error_temp_2))*2 ;       

function  [error] = nmse(input_signal, target_signal)
        var_y = var(target_signal);
        error_temp = (input_signal - target_signal).^2;
        error = mean(error_temp)/var_y;

function  [error] = rmse(input_signal, target_signal)
        error_temp = (input_signal - target_signal).^2;
        error = sqrt(mean(error_temp));

function  [error] = mse(input_signal, target_signal)
        error_temp = (input_signal - target_signal).^2;
        error = mean(error_temp);
















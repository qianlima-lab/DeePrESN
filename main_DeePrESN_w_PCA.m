clc, clear;
close all;

% add all files to current path
current_folder = pwd;
addpath(genpath(current_folder)); clear current_folder

options = gaoptimset('PopulationSize',40,'Generations',60,...
                    'PlotFcns', {@gaplotbestf});

layers =2;
lb = zeros(3*layers,1);
ub = ones(3*layers,1);

[parms, fval, exitflag, output] = ga(@function_DeePrESN_w_PCA,3*layers,[],[],[],[],lb,ub,[],options);

disp('============================================================================================================')
format short
disp(['the optimization results: [' num2str(parms) ']'])
for i=1:10
        tic
         err= testing_DeePrESN_w_PCA(parms);
         error(i,1) = err{1};
         error(i,2) = err{2};
         error(i,3) = err{3};
        fprintf('Testing error = %f, %f ,%f   ...\n',error(i,1), error(i,2),error(i,3));
        tim(i) = toc;
end
disp('============================================================================================================')
format short e
disp(mean(error))
disp(std(error))

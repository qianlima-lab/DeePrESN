function [data] = data_mnimum_daily_temperatures(index, ratio)

if nargin < 2
        ratio = 1;
end

data_temp = load('mnimum_daily_temperatures.txt');

max_num = size(data_temp, 1);

 row = round( ratio*max_num );

data = smooth(data_temp(1:row, index));

% data = data/100;
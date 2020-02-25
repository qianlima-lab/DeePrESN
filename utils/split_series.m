function [ x_train, y_train, x_test, y_test ] = split_series(series, embed, delay, step, ratio_train, flag)

% flag ==0 means predict the future information from itself:
% utilize  { y(t-delay) , ... ,y(t) } to predict {y(t+1), ..., y(t+step)}
% flag ==i means predict the future information from the i-th dimension.

% obtain input dimension
[ num, dim ] = size(series);

if step > 0
    assert(flag==fix(flag) && flag>0 && flag<=dim)
    end_x = (embed-1)*delay + 1;
    start_y = end_x +1;
    end_y = end_x + step;
    total_len = num - step - (end_x-1);

    input = zeros(total_len, embed*dim);
    output = zeros(total_len, step);

    for i = 1:total_len
             input_temp = series((0:1:embed-1)*delay+i, :);
             input(i, :) = reshape(input_temp, 1, embed*dim);
             output(i, :) = series(start_y+(i-1):end_y+(i-1), flag);
    end
else 
    % this is the case that your data consists of multiple columns and the
    % last col denotes the label information
    step = 0;
    end_x = (embed-1)*delay + 1;
    start_y = end_x +step;
    end_y = end_x + step;
    total_len = num - step - (end_x-1);

    input = zeros(total_len,  embed*(dim-1));
    output = zeros(total_len, 1);

    for i = 1:total_len
             input_temp = series((0:1:embed-1)*delay+i, 1:end-1);
             input(i, :) = reshape(input_temp, 1, embed*(dim-1));
             output(i, :) = series(start_y+(i-1):end_y+(i-1), end);
    end
end

row = round( ratio_train*total_len );

x_train = input(1:row, :);
y_train = output(1:row, :);
x_test  = input(row+1:end, :);
y_test  = output(row+1:end, :);

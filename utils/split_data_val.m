function [ x_train, y_train, x_test, y_test ] = split_data_val( x, y, ratio_train, flag_ae)

% Used for spliting the training data set

len_series = size(x, 1);
row = round( ratio_train*len_series );
assert(row>flag_ae)
if flag_ae > 0
    row = flag_ae * floor(row/flag_ae);
end

x_train = x(1:row,:);
y_train = y(1:row,:);
x_test = x(row+1:end,:);
y_test = y(row+1:end,:);

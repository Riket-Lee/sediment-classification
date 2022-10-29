function [] = QualityFactor()

% 零阶
[filename, filepath] = uigetfile('*.asc', '零阶矩', 'E:/emdgmformat_revg/Data/Shang_data/bathymetry_code/good results');
file_order_0_filename = strcat(filepath, filename);

[xllcorner, yllcorner, cellsize, data_order_0, nodata_value] = readGrid_asc(file_order_0_filename);

% 一阶
[filename, filepath] = uigetfile('*.asc', '一阶矩', 'E:/emdgmformat_revg/Data/Shang_data/bathymetry_code/good results');
file_order_1_filename = strcat(filepath, filename);

[~, ~, ~, data_order_1, ~] = readGrid_asc(file_order_1_filename);

% 二阶
[filename, filepath] = uigetfile('*.asc', '二阶矩', 'E:/emdgmformat_revg/Data/Shang_data/bathymetry_code/good results');
file_order_2_filename = strcat(filepath, filename);

[~, ~, ~, data_order_2, ~] = readGrid_asc(file_order_2_filename);

% 结果
result = abs((1.0 - data_order_1 .^ 2 ./ (data_order_0 .* data_order_2)) .^ 0.5);

result(data_order_0 == nodata_value) = nodata_value;
result(data_order_1 == nodata_value) = nodata_value;
result(data_order_2 == nodata_value) = nodata_value;

[nrows, ncols] = size(data_order_0);

% 获取窗口大小
length = strlength(filename);
window_size = filename(length - 5: length - 4);

write_grd(nrows, ncols, xllcorner, yllcorner, cellsize, nodata_value, result, "QualityFactor_" + window_size + ".asc");
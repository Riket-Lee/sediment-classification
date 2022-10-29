function [] = SpectralSkewness()
% 地形数据
[filename, filepath] = uigetfile('*.asc', '地形', 'E:/emdgmformat_revg/Data/Shang_data/bathymetry_code/good results');
depth_filename = strcat(filepath, filename);

[~, ~, ~, depth, ~] = readGrid_asc(depth_filename);

% 二阶
[filename, filepath] = uigetfile('*.asc', '二阶矩', 'E:/emdgmformat_revg/Data/Shang_data/bathymetry_code/good results');
file_order_2_filename = strcat(filepath, filename);

[xllcorner, yllcorner, cellsize, data_order_2, nodata_value] = readGrid_asc(file_order_2_filename);

% 三阶
[filename, filepath] = uigetfile('*.asc', '三阶矩', 'E:/emdgmformat_revg/Data/Shang_data/bathymetry_code/good results');
file_order_3_filename = strcat(filepath, filename);

[~, ~, ~, data_order_3, ~] = readGrid_asc(file_order_3_filename);

% 结果
result = data_order_3 ./ (data_order_2 .^ 1.5);

result(depth == nodata_value) = nodata_value;

[nrows, ncols] = size(data_order_2);

% 获取窗口大小
length = strlength(filename);
window_size = filename(length - 5: length - 4);

write_grd(nrows, ncols, xllcorner, yllcorner, cellsize, nodata_value, result, "SpectralSkewness_" + window_size + ".asc");
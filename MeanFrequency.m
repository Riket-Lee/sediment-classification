function [] = MeanFrequency()

% 读取原始地形数据
[filename, filepath] = uigetfile('*.asc', '地形', 'E:/emdgmformat_revg/Data/Shang_data/bathymetry_code/good results');
depth_filename = strcat(filepath, filename);

[~, ~, ~, depth, ~] = readGrid_asc(depth_filename);

[filename, filepath] = uigetfile('*.asc', '零阶矩', 'E:/emdgmformat_revg/Data/Shang_data/bathymetry_code/good results');
file_order_0_filename = strcat(filepath, filename);

[xllcorner, yllcorner, cellsize, data_order_0, nodata_value] = readGrid_asc(file_order_0_filename);

[filename, filepath] = uigetfile('*.asc', '一阶矩', 'E:/emdgmformat_revg/Data/Shang_data/bathymetry_code/good results');
file_order_1_filename = strcat(filepath, filename);

[~, ~, ~, data_order_1, ~] = readGrid_asc(file_order_1_filename);

result = data_order_1 ./ data_order_0;

result(depth == nodata_value) = nodata_value;

[nrows, ncols] = size(data_order_0);

% 获取窗口大小
length = strlength(filename);
window_size = filename(length - 5: length - 4);

write_grd(nrows, ncols, xllcorner, yllcorner, cellsize, nodata_value, result, "MeanFrequency_" + window_size + ".asc");
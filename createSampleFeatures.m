function [] = createSampleFeatures()
	%% 读取采样文件
    filename_sample = 'E:/emdgmformat_revg/Data/Shang_data/GT_data.txt';
    sample_data = textscan(fopen(filename_sample), '%d	%f	%f	%s');
    
    coordinates = [cell2mat(sample_data(2)) cell2mat(sample_data(3))];
    
    %% 所有特征文件
    path = 'E:/emdgmformat_revg/Data/Shang_data/bathymetry_code/good results/';
    file = dir(fullfile(path, '*.asc'));
    filenames = {file.name};

    file_length = length(filenames);
    
    % 组织所有文件的路径
    for i = 1:file_length
        filenames(i) = cellstr(strcat(path, cell2mat(filenames(i))));
    end

    %% 读取所有的文件并从所有的特征文件中提取出在采样点附近的特征
    ncols = 1402;
    nrows = 2520;
    xllcorner = 647035;
    yllcorner = 5227100;
    cellsize = 5;
    nodata_value = -9999.0;
    
    % 提取采样点附近 5x5 的特征，25个特征组成一列
    % 25行，采样数量列，特征个数层
%     sample_features = zeros(25, size(coordinates, 1), file_length);
    sample_features = zeros(size(coordinates, 1), file_length);
    
    for i = 1:file_length % 层数
        [~, ~, ~, data_grd, ~] = readGrid_asc(cell2mat(filenames(i)));
        
        for j = 1:size(coordinates, 1)  % 列数
            coord_x = coordinates(j, 1);
            coord_y = coordinates(j, 2);
            
            % 实际数据中的行列与 matlab 读取的图像行列是有区别的
            % 实际数据是从左下角开始计算的，图像是从左上角开始计算的
            % 所以列数是相同的，而行数是关于中轴线对称的
            col = floor((coord_x - xllcorner) / cellsize) + 1;
            row = floor((coord_y - yllcorner) / cellsize) + 1;
            row = size(data_grd, 1) + 1 - row;
            
%             temp = data_grd(row - 2:row + 2, col - 2:col + 2);
%             sample_features(:, j, i) = temp(:);
            
            temp = data_grd(row, col);
            sample_features(j, i) = temp;
        end
    end
    
    save sample_features;
    
end
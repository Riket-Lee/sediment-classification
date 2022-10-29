function [] = createSampleFeatures_using_all_data()
    %% 所有特征文件
    path = 'J:/changjiang_estuary/成果/2021/';
    file = dir(fullfile(path, '*.asc'));
    filenames = {file.name};

    file_length = length(filenames);
    
    % 组织所有文件的路径
    for i = 1:file_length
        filenames(i) = cellstr(strcat(path, cell2mat(filenames(i))));
    end

    
    %% 将所有的文件的数据内容组合成矩阵
    [xllcorner, yllcorner, cellsize, data, nodata_value] = readGrid_asc(cell2mat(filenames(1)));
    [m ,n] = size(data);
    features = zeros(m, n, 57);
    for i = 1:length(filenames)
        [~, ~, ~, data, ~] = readGrid_asc(cell2mat(filenames(i)));
        fprintf('%d - \"%s\" file read success!!!\n', i, cell2mat(filenames(i)));
        features(:, :, i) = data;
    end
    save 2021_all_features;
end
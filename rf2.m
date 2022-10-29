function [] = rf2()
    load sample_features_5x5;
    samples = reshape(sample_features, 48 * 25, 57);
    
    feature_dim = size(samples, 2);
    
    filename_sample = 'E:/emdgmformat_revg/Data/Shang_data/GT_data.txt';
    sample_data = textscan(fopen(filename_sample), '%d	%f	%f	%s');
    label = sample_data(4);
    
    label_num = zeros(length(label{1}), 1);
    
    for i = 1:length(label{1})
        if strcmp(cell2mat(label{1}(i)), 'Fine')
            label_num(i) = 1;
        elseif strcmp(cell2mat(label{1}(i)), 'Gravel')
            label_num(i) = 2;
        elseif strcmp(cell2mat(label{1}(i)), 'Boulder')
            label_num(i) = 3;
        else
            label_num(i) = 4;
        end
    end
    
    all_label = zeros(25 * 48, 1);
    for i = 1:48
        for j = 1:25
            all_label((i - 1) * 25 + j) = label_num(i);
        end
    end
    
    samples(:, size(samples, 2) + 1) = all_label;
%     samples(samples == -9999.0) = NaN;
%     samples(any(samples == -9999.0, 2), :) = [];
    
%     all_label = samples(:, feature_dim + 1);
%     samples = samples(:, 1:feature_dim);
    
    cv = cvpartition(size(samples, 1), 'HoldOut', 0.3);
    idx = cv.test;
    dataTrain = samples(~idx, :);
    dataTest = samples(idx, :);
    testing = dataTest(1:end, 1:end - 1);
    
%     model = fitctree(dataTrain(:, 1:end -1), dataTrain(:, end));
    model = fitensemble(dataTrain(:, 1:end - 1), dataTrain(:, end), 'Bag', 100, 'Tree', 'Type', 'classification');
    prediction = predict(model, testing);
    ms = (sum(prediction == dataTest(:, end)) / size(dataTest, 1)) * 100;
    
    figure;
    cm = confusionchart(prediction, dataTest(:, end));
    
    %% 应用到所有的数据
    load all_data;
    
    all_label2 = predict(model, all_data);
    
    img = reshape(all_label2, 2520, 1402);
    
    %% 获得背景位置
    [xllcorner, yllcorner, cellsize, depth, nodata_value] = readGrid_asc('E:/emdgmformat_revg/Data/Shang_data/bathymetry_code/good results/bathymetry.asc');
    pos = (depth == nodata_value);
    
    %% 将背景位置设置到分类图中
    img(pos) = NaN;
    
    %% 写出文件
    write_grd(2520, 1402, xllcorner, yllcorner, cellsize, nodata_value, img, 'supervised.asc');
end

%% 选取数据
function result = extracted_data(data, index, field)
    result = zeros(length(index) * field, size(data, 2));
    for i = 1:length(index)
        for j = 1:field
            result((i - 1) * field + j, :) = data((index(i) - 1) * field + j, :);
        end
    end
end

%% 提取标签
function result = extract_label(data, index, field)
    result = zeros(length(index) * field, 1);
    for i = 1:length(index)
        for j = 1:field
            result((i - 1) * field + j) = data(index(i));
        end
    end
end

function k = kappa(m)
    p0 = trace(m) / sum(m, 'all');
    pe = sum(m, 1) * sum(m, 2) / sum(m, 'all') ^ 2;
    k = (p0 - pe) / (1 - pe);
end
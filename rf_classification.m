function [] = rf_classification()
    % 载入各种特征数据，每一列表示一种特征
%     load all_data;
    % 载入采样文件，每25行表示一个采样点，一共有48个采样点
    load sample_features_5x5;
    samples_all = sample_features;
%     samples_all = reshape(sample_features, 25 * 48, 57);
%     samples = samples_all;
%     samples(any(samples == -9999.0, 2), :) = [];
    samples = zeros(48, 57);
    for i = 1:57
        for j = 1:48
            samples(j, i) = mean(samples_all(:, j, i));
        end
    end
    
%     index = [53 35 15 50 37 21 2 46 40 8 4 28 54 9 42];
%     index = [53 54];
    
%     samples = zeros(size(samples_all, 1), length(index));
%     for i = 1:length(index)
%         samples(:, i) = samples_all(:, index(i));
%     end

    feature_dim = size(samples, 2);
    
    %% 样本标签
    % 1 - Fine, 2 - Gravel, 3 - Boulder, 4 - bedrock
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
    
%     all_label = zeros(25 * 48, 1);
    all_label = zeros(48, 1);
    for i = 1:48
        for j = 1:1
%             all_label((i - 1) * 25 + j) = label_num(i);
            all_label(i) = label_num(i);
        end
    end
    
    %% 将标签附加到采样特征最后一列
    % 然后删除其中有无效值的行
    samples(:, size(samples, 2) + 1) = all_label;
    samples(any(samples == -9999.0, 2), :) = [];
    
    all_label = samples(:, feature_dim + 1);
    samples = samples(:, 1:feature_dim);
    
    %% 随机选取其中的一些采样点
    
    scale = 0.6;
    selected_count = floor(scale * size(samples, 1));
    
    selected_index = sort(randperm(size(samples, 1), selected_count));
    test_index = sort(setdiff(1:size(samples, 1), selected_index));
    
    selected_label = zeros(length(selected_index), 1);
    selected_samples = zeros(length(selected_index), feature_dim);
    test_label = zeros(length(test_index), 1);
    test_samples = zeros(length(test_index), feature_dim);
    for i = 1:selected_count
        selected_label(i) = all_label(selected_index(i));
        selected_samples(i, :) = samples(selected_index(i), :);
    end
    for i = 1:length(test_index)
        test_label(i) = all_label(i);
        test_samples(i, :) = samples(test_index(i), :);
    end
%     scale = 0.5;
%     selected_count = floor(scale * length(label{1}));
%     selected_index = sort(randperm(length(label{1}), selected_count));
%     test_index = sort(setdiff(1:length(label{1}), selected_index));
%     
%     selected_samples = extracted_data(samples, selected_index, 25);
%     test_samples = extracted_data(samples, test_index, 25);
%     
%     selected_label = extract_label(label_num, selected_index, 25);
%     test_label = extract_label(label_num, test_index, 25);
    
    %% 随机森林分类
    ntree = 100;
    model = TreeBagger(ntree, selected_samples, selected_label, 'Method', 'classification', 'OOBPrediction', 'on', 'OOBPredictorImportance', 'on');
    [predict_label, scores] = predict(model, test_samples);
    
    % 将预测文本转换为数字
    p_label = str2num(cell2mat(predict_label));
    
    %% 混淆矩阵绘图
    figure;
    cm = confusionchart(test_label, p_label);
%     disp("class accuracy:");
%     disp(max(cm.NormalizedValues)./sum(cm.NormalizedValues));
%     disp("overall accuracy:");
%     disp(sum(max(cm.NormalizedValues))/sum(sum(cm.NormalizedValues)));
%     disp("Kappa coefficient:");
%     disp(kappa(cm.NormalizedValues));

    %% 绘制OOB变化曲线
    figure;
    oobErrorBaggedEnsemble = oobError(model);
    plot(oobErrorBaggedEnsemble)
    xlabel 'Number of grown trees';
    ylabel 'Out-of-bag classification error';
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
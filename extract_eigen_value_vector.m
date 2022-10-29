function[] = extract_eigen_value_vector()

%     load sample_features_5x5.mat;
    load 2021_all_features.mat;
    sample_features = features;
    [m, n, t] = size(sample_features);

    data_samples = zeros(m * n, t);
    for i = 1:t
        temp = sample_features(:, :, i);
        data_samples(:, i) = temp(:);
    end
    
    %% 去除行中包含 nodata_value，即 -9999.0 的行，
    % 删除又无效值的记录行
    data_samples(any(data_samples == -9999.0, 2), :) = [];

    % 标准化
    [z, mu, sigma] = zscore(data_samples);

    %% matlab 自带pca分析，但是不知道哪一个是特征向量
    % coeff: PCA变换系数，coeff 的每列包含一个主成分的系数，并且这些列按成分方差的降序排列
    % score: 为 PCA 变换后的主成分（潜变量）
    % latent: 个主成分解释的方差
    % explained: 各主成分解释的方差所占的百分比
    % mu: 每列的均值
    
    % score * coeff' 重构结果是 z 减去均值 mu 后的值
%     [coeff, score, latent, tsquared, explained, mu] = pca(z);
    
    %% 特征值分解
    cov_z = cov(z);
    % V: 特征向量矩阵，每一列为一个特征向量
    % D: 特征值矩阵，且从小到大排列
    [V, D] = eig(cov_z);
    contributation = diag(D) / sum(diag(D)) * 100;
    bar(contributation);
    
    index = size(D, 1);
    sum_value = 0;
    for i = index:-1:1
        sum_value = sum_value + contributation(i);
        if sum_value > 90
            break;
        end
    end
    
    eigen_vectors_2021 = V(:, i:end);
    
    save eigen_vectors_2021;
    
   %% 加载所有的数据，每一列为一个变量，然后和筛选后的特征向量相乘转换到特征空间
    
end

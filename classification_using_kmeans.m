%% 使用 kmeans 方法聚类
function [] = classification_using_kmeans()
    load data_in_eigen_space_2020;
    
    data_in_eigen_space = mapminmax(data_in_eigen_space, 0, 1);
    
    % k 类别数
    k = 3;
    
    [label, c, sumd, d] = kmeans(data_in_eigen_space, k);

%     data_classified = reshape(label, 2520, 1402);
%     write_grd(2520, 1402, 647035, 5227100, 5, -9999.0, data_classified, "classified_no_filter_" + num2str(k) + ".asc");
    data_classified = reshape(label, 721, 1003);

%     imagesc(data_classified);

    [xllcorner, yllcorner, cellsize, depth, nodata_value] = readGrid_asc("J:/changjiang_estuary/2020_depth_crop.asc");
    
    flag = (depth ~= nodata_value);
    data_classified = data_classified .* flag;

    data_classified(data_classified == 0) = nodata_value;

    write_grd(721, 1003, xllcorner, yllcorner, cellsize, nodata_value, data_classified, "2020_classified.asc");

    %% 确定分类数
%     K = 8;
%     D = zeros(K, 2);
%     
%     for k = 2:K
%         % lable: nx1 向量，聚类结果标签
%         % c: kxp 向量，k 个聚类质心的位置
%         % sumd: kx1 向量，类间所有点与该类质心点距离之和
%         % d: nxk 向量，每个点与聚类质心的距离
%         [label, c, sumd, d] = kmeans(data_in_eigen_space, k);
%         
%         D(k, 1) = k;
%         D(k, 2) = sum(sumd .^ 2);
%         
% %         figure;
% %         imagesc(reshape(label, 2520, 1402));
%     end
%     
%     plot(D(2:end, 1), D(2:end, 2));
%     hold on;
%     plot(D(2:end, 1), D(2:end, 2), 'or');
end
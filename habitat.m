function [] = habitat()
    %% 读取深度数据和监督分类结果
    [xllcorner, yllcorner, cellsize, depth, nodata_value] = readGrid_asc('../good results/bathymetry.asc');
    
    % 分类结果中，1 表示细砂，2 表示沙砾，3 表示巨砾，4 表示基岩
    [~, ~, ~, classification, ~] = readGrid_asc('../good results/supervised.asc');
    
    %% 获得深度图中无数据区域
    nan_field = (depth == nodata_value);
    
    %% 首先设置区域内容
    [rows, cols] = size(depth);
    result = zeros(rows, cols);
    result(nan_field) = nodata_value;
    
    % 一级保护区域标记为数字 1，二级保护区域标记为数字 2，测量范围标记为数字 0
    
    for i = 1:rows
        for j = 1:cols
            d = depth(i, j);
            type = classification(i, j);
            if type ~= 1 && type ~= nodata_value
                if d <= -25 && d >= -75
                    result(i, j) = 1;
                elseif d <= -12 && d >= -280
                    result(i, j) = 2;
                end
            end
        end
    end
    
    %% 将结果输出为网格文件
    write_grd(rows, cols, xllcorner, yllcorner, cellsize, nodata_value, result, 'habitat.asc');
end
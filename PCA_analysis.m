function [] = PCA_analysis()
    load eigen_vectors;
    
    load filenames;
    
    % 格网信息
    rows = 2520;
    cols = 1402;
    xllcorner = 647035;
    yllcorner = 5227100;
    cellsize = 5;
    nodata_value = -9999.0;
    
    all_data = zeros(rows * cols, size(eigen_vectors, 1));
    
    for i = 1:length(filenames)
        [~, ~, ~, data_grd, ~] = readGrid_asc(cell2mat(filenames(i)));
        temp = data_grd(:);
        temp(temp == nodata_value) = nan;
        all_data(:, i) = temp;
    end
    
    data_in_eigen_space = all_data * eigen_vectors;
    
    save data_in_eigen_space;
end
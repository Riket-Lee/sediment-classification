%% 对分类之后的图像进行整体平滑（滤波）
function [] = filter_image()
    [xllcorner, yllcorner, cellsize, data, nodata_value] = readGrid_asc('../good results/classified_no_filter_5.asc');
    
    data(data == nodata_value) = nan;
    
    figure;
    imagesc(data);
    
%     sigma = 3;
%     gauss_filter = fspecial('gaussian', [5 5], sigma);
%     blur = imfilter(data, gauss_filter, 'replicate');
    
    blur = medfilt2(data, [9 9]);
%     blur = medfilt2(blur, [9 9]);
    
    figure;
    imagesc(blur);
    
    write_grd(2520, 1402, xllcorner, yllcorner, cellsize, nodata_value, blur, 'classified_filter_5.asc');
    
end
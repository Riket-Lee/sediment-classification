function [] = spetralSkewness()

    [xllcorner, yllcorner, cellsize, depth2, nodata_value2] = readGrid_asc('2OrderMoment_35.asc');
    [~, ~, ~, depth3, nodata_value3] = readGrid_asc('3OrderMoment_35.asc');

    [nrows, ncols] = size(depth2);
    
    result = zeros(nrows, ncols);
    
    for i = 1:nrows
        for j = 1:ncols
            ele2 = depth2(i, j);
            ele3 = depth3(i, j);
            
            if ele2 == nodata_value2 || ele3 == nodata_value3 || ele2 == 0
                result(i, j) = nodata_value2;
            else 
                result(i, j) = ele3 / ele2 ^1.5;
            end
        end
    end
    write_grd(nrows, ncols, xllcorner, yllcorner, cellsize, nodata_value2, result, 'SpetralSkewness_35.asc');

end
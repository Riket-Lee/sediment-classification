function [] = SpetralWidth()
    
    [xllcorner, yllcorner, cellsize, depth0, nodata_value0] = readGrid_asc('0OrderMoment_35.asc');
    [~, ~, ~, depth1, nodata_value1] = readGrid_asc('1OrderMoment_35.asc');
    [~, ~, ~, depth2, nodata_value2] = readGrid_asc('2OrderMoment_35.asc');

    [nrows, ncols] = size(depth0);
    
    result = zeros(nrows, ncols);
    
    for i = 1:nrows
        for j = 1:ncols
            ele0 = depth0(i, j);
            ele1 = depth1(i, j);
            ele2 = depth2(i, j);
            
            if ele0 == nodata_value0 || ele1 == nodata_value1 || ele2 == nodata_value2 || ele1 == 0
                result(i, j) = nodata_value0;
            else 
                result(i, j) = ele0 * ele2 / (ele1 * ele1) - 1.0;
            end
        end
    end
    write_grd(nrows, ncols, xllcorner, yllcorner, cellsize, nodata_value0, result, 'SpetralWidth_35.asc');
end
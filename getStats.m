function val = getStats(glcm, para, nrows, ncols, nodata_value)
    val = zeros(nrows, ncols);

    for i = 1:nrows
       for j = 1:ncols
           if ismember(nodata_value, glcm(i, j, :))
                val(i, j) = nodata_value;
           else 
                val(i, j) = graycoprops(reshape(glcm(i, j, :), 8, 8), para).(para);
           end
       end
    end
end
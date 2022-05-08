function stats = GLCM_Statis(depth, nrows, ncols, nodata_value, window_size, para)
    
    stats = zeros(nrows, ncols) * nan;
    glcm = zeros(nrows, ncols, 64);

    fw = floor(window_size / 2);
    cw = ceil(window_size / 2);

    for i = cw:nrows + fw
        for j = cw:ncols + fw
            term = depth(i - fw : i + fw, j - fw : j + fw);
            if ismember(nodata_value, term)
                temp = ones(8, 8) * nodata_value;
            else 
                temp = graycomatrix(term, 'G', []);
            end
            glcm(i - 1, j - 1, :) = temp(:);
        end
    end
    
    stats = getStats(glcm, para, nrows, ncols, nodata_value);
end



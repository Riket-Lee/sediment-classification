function TPI = TPI(depth, nrows, ncols, nodata_value, window_size)

%% 3X3 模板计算地形位置指数 TPI
TPI = zeros(nrows, ncols);

fw = floor(window_size / 2);
cw = ceil(window_size / 2);

for i = cw:nrows + fw
    for j = cw:ncols + fw
        temp = depth(i - fw : i + fw, j - fw : j + fw);
        if ismember(nodata_value, temp)
            tpi = nodata_value;
        else 
            z0 = temp(cw, cw);
            z_ave = sum(temp(:)) / 9;
            tpi = z0 - z_ave;
        end
        TPI(i - fw, j - fw) = tpi;
    end
end
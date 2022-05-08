function TRI = TRI(depth, nrows, ncols, nodata_value, window_size)

%% 3X3 模板计算地形崎岖指数 TRI
TRI = zeros(nrows, ncols);

fw = floor(window_size / 2);
cw = ceil(window_size / 2);

for i = cw:nrows + fw
    for j = cw:ncols + fw
        temp = depth(i - fw : i + fw, j - fw : j + fw);
        if ismember(nodata_value, temp)
            tri = nodata_value;
        else 
            tri = sum(abs(temp(:) - temp(cw, cw))) / 8;
        end
        TRI(i - fw, j - fw) = tri;
    end
end
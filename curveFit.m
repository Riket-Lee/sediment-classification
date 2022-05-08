function Z = curveFit(rowBegin, colBegin, cellsize, window_size, data, no_data)
    Z = zeros(window_size, window_size);
    Z(:, :) = no_data;
    
    dim = sum(data(:) ~= no_data);
    
    if dim ~= 0
        B = zeros(dim, 6);
        L = zeros(dim, 1);
        X = zeros(6, 1);

        % 得到小片区域的横纵坐标
        xs = zeros(window_size, window_size);
        ys = zeros(window_size, window_size);
        for row = 1:window_size
            for col = 1:window_size
                xs(row, col) = (colBegin + col - 2) * cellsize;
                ys(row, col) = (rowBegin + row - 2) * cellsize;
            end
        end

        index = 1;
        for i = 1:window_size 
            for j = 1:window_size
                x = xs(i, j);
                y = ys(i, j);
                z = data(i, j);
                if z ~= no_data
                    B(index, :) = [x^2 y^2 x*y x y 1];
                    L(index) = z;
                    index = index + 1;
                end
            end
        end

        X = pinv(B' * B) * B' * L;

        for i = 1:window_size 
            for j = 1:window_size
                x = xs(i, j);
                y = ys(i, j);
                BB = [x^2 y^2 x*y x y 1];
                if data(i, j) ~= no_data
                    Z(i, j) = BB * X;
                end
            end
        end
    end
end
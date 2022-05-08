function result = Dfft(cellsize, nodata_value, image, window_size)
    [nrows, ncols] = size(image);

    result = zeros(nrows - window_size + 1, ncols - window_size + 1);

    border = floor(window_size / 2);

    for col = border + 1 : ncols - border
        for row = border + 1 : nrows - border
            snippet = image(row - border : row + border, col - border : col + border);

            % 去除地形趋势项
            Z = curveFit(row - border, col - border, cellsize, window_size, snippet, nodata_value);

            % 去除地形趋势项后的残余
            delta_snippet = snippet - Z;

            if sum(delta_snippet(:)) ~= 0
                % 对微地形求 2D FFT
                Y = abs(fft2(delta_snippet));

                % 二维图像转一维图像，通过每 5°提取一条线，因为 FFT 图像是对称的，所以角度范围为 0 - 180
                fft_cross_section = fft_extraction(Y, 5);

                % 对提取出来的一维频谱参数进行功率谱密度计算
                result(row - border, col - border) = mean_Dfft_cross_section(fft_cross_section, window_size, cellsize);
            end
        end   
    end
end

function mean_Dfft = mean_Dfft_cross_section(fft, window_size, cell_size)
    [m, ~] = size(fft);
    Dfft_result = zeros(m, 1);
    
    % (u, v) 代表这个平面波的法向量 n, 这个向量的模代表这个平面波的频率 w
    w = 1:ceil(sqrt(2) * floor(window_size / 2));
    
    for i = 1:m
        col = fft(:, i);
%       频谱密度可以表示为 Sw
        Sw = col .^ 2 / (window_size * window_size * cell_size * cell_size);
        
        [~, beta] = fitCurveExponent(w, Sw);
        Dfft_result(i) = beta;     
    end
    mean_Dfft = mean(Dfft_result);
end

function [k, beta] = fitCurveExponent(w, Sw) 
    x = log(w);
    y = log(Sw);
    
    [m, ~] = size(Sw);    
    B(:, 1) = -x(:);
    B(:, 2) = 1;
    L = y;
    
    XX = inv(B' * B) * B' * L;
    
    beta = XX(1);
    k = exp(XX(2));
end
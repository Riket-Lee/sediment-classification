function result = spectralMoment(cellsize, nodata_value, image, window_size)

    [nrows, ncols] = size(image);

    result = zeros(nrows - window_size + 1, ncols - window_size + 1, 4);

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
%                 Y = fftshift(fft2(delta_snippet));

                % 二维图像转一维图像，通过每 5°提取一条线，因为 FFT 图像是对称的，所以角度范围为 0 - 180
                fft_cross_section = fft_extraction(Y, 5);

                % 对提取出来的一维频谱参数进行功率谱密度计算
                result(row - border, col - border, :) = psd_compute_1D(fft_cross_section, window_size, cellsize);
            end
        end   
    end
end
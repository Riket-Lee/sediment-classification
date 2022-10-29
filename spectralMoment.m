function result = spectralMoment(cellsize, nodata_value, image, window_size)

    [nrows, ncols] = size(image);

    result = zeros(nrows - window_size + 1, ncols - window_size + 1, 4);
    result(:) = nodata_value;

    border = floor(window_size / 2);

    for col = border + 1 : ncols - border
        for row = border + 1 : nrows - border
            snippet = image(row - border : row + border, col - border : col + border);

            % 去除地形趋势项
            Z = curveFit(row - border, col - border, cellsize, window_size, snippet, nodata_value);

            % 去除地形趋势项后的残余
            delta_snippet = snippet - Z;

            if (sum(delta_snippet(:)) ~= 0)
                % 对微地形求 2D FFT
%                 if(snippet(:) ~= -9999.0)
                    Y = abs(fftshift(fft2(delta_snippet)));

                    % 直接计算矩
                    result(row-border, col - border, :) = moment_direct(Y);
%                 else
%                     result(row-border, col - border, :) = nodata_value;
%                 end
%                 Y = fftshift(fft2(delta_snippet));

                % 二维图像转一维图像，通过每 5°提取一条线，因为 FFT 图像是对称的，所以角度范围为 0 - 180
                % 这样取的话，会比较难计算频率或者角频率
%                 fft_cross_section = fft_extraction(Y, 5);

                % 将 0 - 180 的区域分为四个子区域，保证每个子区域里面没有频率的重叠部分
                % 即每 45 度范围划分
%                  fft_cross_section = fft_extraction_four_parts(Y);
                
                % 对提取出来的一维频谱参数进行功率谱密度计算
%                 result(row - border, col - border, :) = psd_compute_1D(fft_cross_section, window_size, cellsize);

%                 result(row-border, col - border, :) = psd_compute_1D_another(fft_cross_section);
            end
        end   
    end
end
%% 每 45 度分隔范围
function [fft_cross_section, index] = fft_extraction_four_parts(snippet)
    [m, ~] = size(snippet);
    
    % (x0, y0) 处为频谱图的中心位置，因为已经进行了平移了，
    % 所以此位置的频率为 0
    x0 = ceil(m / 2);
    y0 = ceil(m / 2);
    
    fft_cross_section = zeros(1, 2, 4);
    
    index = ones(4, 1);
    
    for i = 1:m
        for j = y0:m % 只有上半部分
            angle = atan2(j - y0, i - x0);
            omega = sqrt((i - x0)^2 + (j - y0)^2);
            
            layer = floor(angle * 4 / pi) + 1;
            if layer > 4
                layer = 4;
            end
            
            fft_cross_section(index(layer), :, layer) = [omega, snippet(i, j)];
            index(layer) = index(layer) + 1;
        end
    end
end
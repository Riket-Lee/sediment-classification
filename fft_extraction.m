%% 每隔 angle_interval 提取一条数据
function fft_cross_section = fft_extraction(snippet, angle_interval)
    [m, ~] = size(snippet);
    x0 = ceil(m / 2);
    y0 = ceil(m / 2);
    
    max_length = ceil(sqrt(2) * floor(m / 2));
    fft_cross_section = zeros(max_length, ceil(180 / angle_interval) + 1);
    
    for ang = 0 : angle_interval : 180
        ang_rad = ang * pi / 180;
        
        for len = 0:max_length - 1
            x = x0 + round(len * cos(ang_rad));
            y = y0 + round(len * sin(ang_rad));
            index_1 = len + 1;
            index_2 = ang / angle_interval + 1;
            if x <= m && y <= m && x > 0 && y > 0
                fft_cross_section(index_1, index_2) = snippet(x, y);
            end
        end
    end
end
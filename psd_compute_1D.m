%% 计算功率谱密度
function psd = psd_compute_1D(fft, window_size, cell_size)
    [m, ~] = size(fft);
    psd_n = zeros(m, 4);
    
    % (u, v) 代表这个平面波的法向量 n, 这个向量的模代表这个平面波的频率 w
    w = 1:ceil(sqrt(2) * floor(window_size / 2));
        
    for i = 1:m
        col = fft(:, i);
%       频谱密度可以表示为 Sw
        Sw = col .^ 2 / (window_size * window_size * cell_size * cell_size);
        
        psd_n(i, 1) = w .^ 0 * Sw;
        psd_n(i, 2) = w .^ 1 * Sw;
        psd_n(i, 3) = w .^ 2 * Sw;
        psd_n(i, 4) = w .^ 3 * Sw;
    end
    psd = mean(psd_n);
end
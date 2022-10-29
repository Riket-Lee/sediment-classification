%% 计算功率谱密度
function psd = psd_compute_1D_another(fft)    

    psd = zeros(4, 1);
    for r = 0:3 % 第 r 阶矩
        for i = 1:4 % 第几块数据
%             psd_n(:, i) = fft(:, 1, i) .^ (i - 1) .* fft(:, 2, i);
            psd(r + 1) = psd(r + 1) + (fft(:, 1, i) .^ r)' * fft(:, 2, i);
        end
    end
    psd = psd / 4;
end
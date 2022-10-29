function result = moment_direct(snippet)
    [m, ~] = size(snippet);
    % (x0, y0) 处为频谱图的中心位置，因为已经进行了平移了，
    % 所以此位置的频率为 0
    x0 = ceil(m / 2);
    y0 = ceil(m / 2);
    
    result = zeros(4, 1);
    
    for r = 0:3
        for i = 1:m
            for j = y0:m
                omega = sqrt((i - x0)^2 + (j - y0)^2);
                Sw = snippet(i, j);
                result(r + 1) = result(r + 1) + omega ^ r * Sw;
            end
        end
    end
end
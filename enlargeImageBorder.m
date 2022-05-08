function image = enlargeImageBorder(image, border)

    %% 将左右上下四行分别填充相邻行的值
    for i = 1:floor(border / 2)
        % 最左边
        image(ceil(border / 2):end - floor(border / 2), i) = image(ceil(border / 2):end - floor(border / 2), ceil(border / 2));
        % 最右边
        image(ceil(border / 2):end - floor(border / 2), end - i + 1) = image(ceil(border / 2):end - floor(border / 2), end - floor(border / 2));
        % 最上边
        image(i, ceil(border / 2):end - floor(border / 2)) = image(ceil(border / 2), ceil(border / 2):end - floor(border / 2));
        % 最下边
        image(end - i + 1, ceil(border / 2):end - floor(border / 2)) = image(end - floor(border / 2), ceil(border / 2):end - floor(border / 2));

        % 补角
        for j = 1:floor(border / 2)
            % 左上角
            image(i, j) = image(ceil(border / 2), ceil(border / 2));
            % 右上角
            image(i, end - j + 1) = image(ceil(border / 2), end - floor(border / 2));
            % 左下角
            image(end - i + 1, j) = image(end - floor(border), ceil(border / 2));
            % 右下角
            image(end - i + 1, end - j + 1) = image(end - floor(border), end - floor(border));
        end
    end
    
end
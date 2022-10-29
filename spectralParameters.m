function result = spectralParameters()

window_size = 2;
while mod(window_size, 2) == 0
    window_size = input('\n the window size is: \n');
    if mod(window_size, 2) == 0
        fprintf('window size have to be odd number');
    end
end

[filename, filepath] = uigetfile('*.asc', '打开文件', 'E:/emdgmformat_revg/Data/Shang_data/products');
absoluteFilePath = strcat(filepath, filename);

% read raw grid data
fid = fopen(absoluteFilePath);
lineNum = 1;
while ~feof(fid)
    line = fgetl(fid);
    cell_str = strsplit(line, ' ');
    if lineNum == 1
        ncols = str2double(char(cell_str(2)));
    elseif lineNum == 2
        nrows = str2double(char(cell_str(2)));
        depth = zeros(nrows + window_size - 1, ncols + window_size - 1);
    elseif lineNum == 3
        xllcorner = str2double(char(cell_str(2)));
    elseif lineNum == 4
        yllcorner = str2double(char(cell_str(2)));
    elseif lineNum == 5
        cellsize = str2double(char(cell_str(2)));
    elseif lineNum == 6
        nodata_value = str2double(char(cell_str(2)));
    else 
        depth(lineNum - 6 + floor(window_size / 2), ceil(window_size / 2):end - floor(window_size / 2)) = str2num(char(cell_str));
    end
    lineNum = lineNum + 1;
end

depth = enlargeImageBorder(depth, window_size);

% type = input('\n 1.Zero-order to Third-order spetral moment; \n 2.Mean frequency; \n 3.Spetral width; \n 4. Spetral skewness; \n 5.Quality factor; \n 6.Spectral skewness defined for central moments; \n 7.Fractal dimension; \n The selection is: \n');
type = input('\n 1.Zero-order to Third-order spetral moment; \n 2.Fractal dimension; \n');

if type == 1
% 获取一阶、二阶、三阶、四阶谱矩，根据不同阶数的谱矩来计算其他的参数
    result = spectralMoment(cellsize, nodata_value, depth, window_size);
    write_grd4(nrows, ncols, xllcorner, yllcorner, cellsize, nodata_value, result, window_size);
elseif type == 2
    result = Dfft(cellsize, nodata_value, depth, window_size);
    write_grd(nrows, ncols, xllcorner, yllcorner, cellsize, nodata_value, result, "Dfft_21.asc");
% elseif type == 3
%     % 读取文件计算
% elseif type == 4
%     % 读取文件计算
% elseif type == 5
%     %
end
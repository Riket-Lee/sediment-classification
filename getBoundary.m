function[] = getBoundary()
 
[filename, filepath] = uigetfile('*.asc', '打开文件');
absoluteFilePath = strcat(filepath, filename);

fid = fopen(absoluteFilePath);
lineNum = 1;
while ~feof(fid)
    line = fgetl(fid);
    cell_str = strsplit(line, ' ');
    if lineNum == 1
        ncols = str2double(char(cell_str(2)));
    elseif lineNum == 2
        nrows = str2double(char(cell_str(2)));
        depth = zeros(nrows, ncols);
    elseif lineNum == 3
        xllcorner = str2double(char(cell_str(2)));
    elseif lineNum == 4
        yllcorner = str2double(char(cell_str(2)));
    elseif lineNum == 5
        cellsize = str2double(char(cell_str(2)));
    elseif lineNum == 6
        nodata_value = str2double(char(cell_str(2)));
    else 
%         depth(lineNum - 6 + floor(window_size / 2), ceil(window_size / 2):end - floor(window_size / 2)) = str2num(char(cell_str));
        depth(lineNum - 6, 1:ncols) = str2num(char(cell_str));
    end
    lineNum = lineNum + 1;
end

bounds = zeros(nrows, 2, 2);
for i = 1:nrows
    for j = 1:ncols
        if depth(i, j) ~= nodata_value && j > 5
            bounds(i, 1, 1) = xllcorner + (j - 1) * cellsize;
            bounds(i, 1, 2) = yllcorner + (nrows  - i) * cellsize;
            break;
        end
    end
end

for i = 1:nrows
    for j = ncols:-1:1
        if depth(i, j) ~= nodata_value && j > 5
            bounds(i, 2, 1) = xllcorner + (j - 1) * cellsize;
            bounds(i, 2, 2) = yllcorner + (nrows  - i) * cellsize;
            break;
        end
    end
end

bound2 = zeros(nrows * 2, 2);
bound2(1:nrows, 1) = bounds(:, 1,  1);
bound2(1:nrows, 2) = bounds(:, 1,  2);
bound2(nrows + 1:2 * nrows, 1) = bounds(:, 2, 1);
bound2(nrows + 1:2 * nrows, 2) = bounds(:, 2, 2);

plot(bound2(:, 1), bound2(:, 2));
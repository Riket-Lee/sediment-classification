function[] = getTerrainPara()

window_size = 2;
while mod(window_size, 2) == 0
    window_size = input('\n the window size is: \n');
    if mod(window_size, 2) == 0
        fprintf('window size have to be odd number');
    end
end

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

type = input('\n 1.TRI; 2.TPI; 3. GLCM \n The selection is: \n');

if type == 1
    data = TRI(depth, nrows, ncols, nodata_value, window_size);
elseif type == 2
    data = TPI(depth, nrows, ncols, nodata_value, window_size);
elseif type == 3
    id = input('\n 1.Energy; 2.Entropy; 3.Correlation; 4.Contrast; 5.Variance; 6.Homogeneity \n The selection is: \n');
    switch id 
        case 1
            para = 'Energy';
        case 2
            para = 'Entropy';
        case 3
            para = 'Correlation';
        case 4
            para = 'Contrast';
        case 5
            para = 'Variance';
        case 6
            para = 'Homogeneity';
    end
    data = GLCM_Statis(depth, nrows, ncols, nodata_value,window_size, para);
end

write_grd(nrows, ncols, xllcorner, yllcorner, cellsize, nodata_value, data, 'Energy_3x3.asc');
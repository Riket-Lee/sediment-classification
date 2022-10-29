function[] = statis_unsupervised()

    [filename, filepath] = uigetfile('*.asc', '地形', 'E:/emdgmformat_revg/Data/Shang_data/bathymetry_code/good results');
    classified_filename = strcat(filepath, filename);

    [xllcorner, yllcorner, cellsize, depth, nodata_value] = readGrid_asc(classified_filename);

    label_filename = "E:/emdgmformat_revg/Data/Shang_data/GT_data.txt";
    label_data = textscan(fopen(label_filename), '%d	%f	%f	%s');
    coordinates = [cell2mat(label_data(2)) cell2mat(label_data(3))];
    label = label_data(4);
    
    label_num = zeros(length(label{1}), 2);
    
    for i = 1:length(label{1})
        if strcmp(cell2mat(label{1}(i)), 'Fine')
            label_num(i, 1) = 1;
        elseif strcmp(cell2mat(label{1}(i)), 'Gravel')
            label_num(i, 1) = 2;
        elseif strcmp(cell2mat(label{1}(i)), 'Boulder')
            label_num(i, 1) = 3;
        else
            label_num(i, 1) = 4;
        end
    end

    [m, ~] = size(coordinates);
    for i = 1:m
        rownum = 2521 - floor((coordinates(i ,2) - yllcorner) / 5);
        colnum = floor((coordinates(i, 1) - xllcorner) / 5) + 1;
        label_num(i, 2) = depth(rownum, colnum);
    end
end
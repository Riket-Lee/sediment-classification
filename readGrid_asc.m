function [xllcorner, yllcorner, cellsize, depth, nodata_value] = readGrid_asc(filename)

    fid = fopen(filename);
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
            depth(lineNum - 6, :) = str2num(char(cell_str));
        end
        lineNum = lineNum + 1;
    end
end
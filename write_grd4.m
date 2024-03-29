function [] = write_grd4(nrows, ncols, xllcorner, yllcorner, cellsize, nodata_value, data4, window_size)
    for n = 1:4
        fid = fopen(num2str(n - 1) + "OrderMoment_" + num2str(window_size) + ".asc", 'w');
        fprintf(fid, '%-13s %d\n', 'ncols', ncols);
        fprintf(fid, '%-13s %d\n', 'nrows', nrows);
        fprintf(fid, '%-13s %d\n', 'xllcorner', xllcorner);
        fprintf(fid, '%-13s %d\n', 'yllcorner', yllcorner);
        fprintf(fid, '%-13s %d\n', 'cellsize', cellsize);
        fprintf(fid, '%-13s %.1f\n', 'nodata_value', nodata_value);
        data = data4(:, :, n);
        for i = 1:nrows
            for j = 1:ncols
                if data(i, j) == nodata_value
                    fprintf(fid, '%.1f', nodata_value);
                else
                    fprintf(fid, '%.3f', data(i, j));
                end

                if j ~= ncols
                    fprintf(fid, ' ');
                end
            end
            fprintf(fid, '\n');
        end
        fclose(fid);
    end
end
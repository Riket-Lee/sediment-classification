%% 通过 Boruta 筛选之后的特征的采样数据
function [] = filtered_features()
%     filenames = ["bathymetry.asc", "Mean.asc", "Correlation2_20x20.asc", "Variance2_20x20.asc", "MeanFrequency_35.asc", ...
%         "Dfft_35.asc", "0OrderMoment_35.asc", "SpectralWidth_35.asc", "QualityFactor_35.asc", "3OrderMoment_35.asc", ...
%         "1OrderMoment_35.asc", "Entropy2_20x20.asc", "intensity.asc", "Aspect2.asc", "Slope2.asc"];
%     
%     for i = 1:length(filenames)
%         filenames(i) = strcat('E:\emdgmformat_revg\Data\Shang_data\bathymetry_code\good results\', filenames(i));
%     end

    index = [53 35 15 50 37 21 2 46 40 8 4 28 54 9 42];
    load sample_features;
    samples = zeros(size(sample_features, 1), length(index));
    for i = 1:length(index)
        samples(:, i) = sample_features(:, index(i));
    end
    
    z = zscore(samples);
    
    cov_z = cov(z);
    
    for i = 1:length(index) - 1
        for j = i + 1: length(index)
            if i < j
                cov_z(i, j) = nan;
            end
        end
    end
    
    label = ["bathymetry.asc", "Mean.asc", "Correlation2\_20x20.asc", "Variance2\_20x20.asc", "MeanFrequency\_35.asc", ...
        "Dfft\_35.asc", "0OrderMoment\_35.asc", "SpectralWidth\_35.asc", "QualityFactor\_35.asc", "3OrderMoment\_35.asc", ...
        "1OrderMoment\_35.asc", "Entropy2\_20x20.asc", "intensity.asc", "Aspect2.asc", "Slope2.asc"];
    
    imagesc(cov_z);
    hold on;
    set(gca, 'xtick', 1:15, 'ytick', 1:15);
    set(gca, 'Xticklabel', label, 'Yticklabel', label);
    colormap turbo;
    colorbar;
end
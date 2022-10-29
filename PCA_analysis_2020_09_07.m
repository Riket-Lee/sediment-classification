function [] = PCA_analysis_2020_09_07()
    load eigen_vectors_2021;
    
    load 2021_all_features.mat;
    
    [m, n, p] =size(features);
    features = reshape(features, m * n, p);
    data_in_eigen_space = features * eigen_vectors_2021;
    
    save data_in_eigen_space_2021;
end
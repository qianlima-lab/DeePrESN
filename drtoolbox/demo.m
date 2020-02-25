clc;
clear;

load hald ;
X = ingredients;

disp('Testing intrinsic dimensionality estimators...');
techniques = {'CorrDim', 'NearNbDim', 'GMST', 'PackingNumbers', 'EigValue', 'MLE'};
dim = intrinsic_dim(X, techniques{1});

disp('Testing dimensionality reduction techniques...');
techniques = {'PCA', 'MDS', 'ProbPCA', 'FactorAnalysis', 'GPLVM', 'Sammon', 'Isomap', ...
    'LandmarkIsomap', 'LLE', 'Laplacian', 'HessianLLE', 'LTSA', 'MVU', 'CCA', 'LandmarkMVU', ...
    'FastMVU', 'DiffusionMaps', 'KernelPCA', 'GDA', 'SNE', 'SymSNE', 'tSNE', 'LPP', 'NPE', ...
    'LLTSA', 'SPE', 'Autoencoder', 'LLC', 'ManifoldChart', 'CFA'};
[mappedX, mapping] = compute_mapping(X, techniques{1}, floor(dim));

mappedX_test = out_of_sample(X, mapping);


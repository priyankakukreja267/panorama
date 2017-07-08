function [] = testMatch()

sigma0 = 1;
k = 2;
levels = [-1;0;1;2;3;4];
theta_r = 12;
theta_c = 0.03;

img1 = '../data/chickenbroth_02.jpg';
img2 = '../data/chickenbroth_03.jpg';

%img1 = '../data/incline_L.png';
%img2 = '../data/incline_R.png';

%img1 = '../data/pf_scan_scaled.jpg';
%img2 = '../data/pf_.jpg';

%%%%% IMAGE - 1 %%%%%
im1 = imread(img1);
GaussianPyramid1 = createGaussianPyramid(im1, sigma0, k, levels);
[DoGPyramid1, DoGLevels1] = createDoGPyramid(GaussianPyramid1, levels);
PrincipalCurvature1 = computePrincipalCurvature(DoGPyramid1);
locsDoG1 = getLocalExtrema(DoGPyramid1, DoGLevels1, PrincipalCurvature1, theta_c, theta_r);
im1 = im2double(im1);
if size(im1,3)==3
    im1 = rgb2gray(im1);
end
load('../results/testPattern.mat');
[locs1,desc1] = computeBrief(im1, GaussianPyramid1, locsDoG1, k, levels, compareA, compareB);


%%%%% IMAGE - 2 %%%%%
im2 = imread(img2);
GaussianPyramid2 = createGaussianPyramid(im2, sigma0, k, levels);
[DoGPyramid2, DoGLevels2] = createDoGPyramid(GaussianPyramid2, levels);
PrincipalCurvature2 = computePrincipalCurvature(DoGPyramid2);
locsDoG2 = getLocalExtrema(DoGPyramid2, DoGLevels2, PrincipalCurvature2, theta_c, theta_r);
im2 = im2double(im2);
if size(im2,3)==3
    im2 = rgb2gray(im2);
end
[locs2,desc2] = computeBrief(im2, GaussianPyramid2, locsDoG2, k, levels, compareA, compareB);

% Compute the matches and plot them
matches = briefMatch(desc1, desc2, 0.5);
plotMatches(im1, im2, matches, locs1, locs2);
end

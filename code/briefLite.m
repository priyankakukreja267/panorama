function [locs, desc] = briefLite(im)
% input
% im - gray image with values between 0 and 1
%
% output
% locs - an m x 3 vector, where the first two columns are the image coordinates of keypoints and the third column 
% 		 is the pyramid level of the keypoints
% desc - an m x n bits matrix of stacked BRIEF descriptors. 
%		 m is the number of valid descriptors in the image and will vary
% 		 n is the number of bits for the BRIEF descriptor

im = im2double(im);
if size(im,3)==3 % if size of 3rd dimension of a is 3
    im = rgb2gray(im);
end

sigma0 = 1;
k = 2;
levels = [-1;0;1;2;3;4];
theta_r = 12;
theta_c = 0.03;

GaussianPyramid = createGaussianPyramid(im, sigma0, k, levels);
[DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels);
PrincipalCurvature = computePrincipalCurvature(DoGPyramid);
locsDoG = getLocalExtrema(DoGPyramid, DoGLevels, PrincipalCurvature, theta_c, theta_r);
load('../results/testPattern.mat');
[locs,desc] = computeBrief(im, GaussianPyramid, locsDoG, k, levels, compareA, compareB);

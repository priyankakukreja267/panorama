function im3 = generatePanorama(im1, im2)
% Accept two images as input and compute keypoints and descriptors for 
% both the images, find putative feature correspondences by matching keypoint 
% descriptors, estimate a homography using RANSAC and then warp one of the 
% images with the homography so that they are aligned and then overlay them.

    imgName1 = im1;
    imgName2 = im2;
    
    %%%%% IMAGE - 1 %%%%%    
    im1 = imread(im1);
    im1 = im2double(im1);
    if size(im1,3)==3 % if size of 3rd dimension of a is 3
        im1 = rgb2gray(im1);
    end
    
    %%%%% IMAGE - 2 %%%%%
    im2 = imread(im2);
    im2 = im2double(im2);
    if size(im2,3)==3 % if size of 3rd dimension of a is 3
        im2 = rgb2gray(im2);
    end
    
    [locs1, desc1] = getLocs(im1);
    %display('locs1 obrained')
    [locs2, desc2] = getLocs(im2);
    %display('locs2 obtained')
    
    % Find 'matches' for both the images
    ratio = 0.5;
    matches = briefMatch(desc1, desc2, ratio);
    %sprintf('Matches found = %d', size(matches, 1))
    
    % Find Homography matrix 'H' using RANSAC
    tol = 10;
    nIter = 1000;
    H = ransacH(matches, locs1, locs2, nIter, tol)
    %display('Homography computed using RANSAC')
    
    colorImg1 = imread(imgName1);
    colorImg2 = imread(imgName2);
    
    % Warp the right image
    outSize = [size(colorImg1, 1), size(colorImg1, 2)];
    w = warpH(colorImg2, H, outSize);
    w(1:out_size(1), 1:out_size(2), :) = colorImg1;
    im3 = w;
    imshow(im3);
end

function [locs1, desc1] = getLocs(im1)
    sigma0 = 1;
    k = 2;
    levels = [-1;0;1;2;3;4];
    theta_r = 12;
    theta_c = 0.03;

    GaussianPyramid1 = createGaussianPyramid(im1, sigma0, k, levels);
    [DoGPyramid1, DoGLevels1] = createDoGPyramid(GaussianPyramid1, levels);
    PrincipalCurvature1 = computePrincipalCurvature(DoGPyramid1);
    locsDoG1 = getLocalExtrema(DoGPyramid1, DoGLevels1, PrincipalCurvature1, theta_c, theta_r);
    %display('localExtrema obtained');
    load('../results/testPattern.mat');
    [locs1,desc1] = computeBrief(im1, GaussianPyramid1, locsDoG1, k, levels, compareA, compareB);
end

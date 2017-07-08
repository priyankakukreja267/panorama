function [x, nMatches] = briefRotTest()

    img1 = '../data/model_chickenbroth.jpg';
    sigma0 = 1;
    k = 2;
    levels = [-1;0;1;2;3;4];
    theta_r = 12;
    theta_c = 0.03;
    load('testPattern.mat');

    im1 = imread(img1);
    im1 = im2double(im1);
    if size(im1,3)==3 % if size of 3rd dimension of a is 3
        im1 = rgb2gray(im1);
    end
    
    GaussianPyramid1 = createGaussianPyramid(im1, sigma0, k, levels);
    [DoGPyramid1, DoGLevels1] = createDoGPyramid(GaussianPyramid1, levels);
    PrincipalCurvature1 = computePrincipalCurvature(DoGPyramid1);
    locsDoG1 = getLocalExtrema(DoGPyramid1, DoGLevels1, PrincipalCurvature1, theta_c, theta_r);
    [locs1,desc1] = computeBrief(im1, GaussianPyramid1, locsDoG1, k, levels, compareA, compareB);

    x = [];
    nMatches = [];
    
    for i = 1:35
        angle = i*10;
        x = [x, angle];
        im2 = imrotate(im1, angle);
        im2 = im2double(im2);
        if size(im2,3)==3 % if size of 3rd dimension of a is 3
            im2 = rgb2gray(im2);
        end

        GaussianPyramid2 = createGaussianPyramid(im2, sigma0, k, levels);
        [DoGPyramid2, DoGLevels2] = createDoGPyramid(GaussianPyramid2, levels);
        PrincipalCurvature2 = computePrincipalCurvature(DoGPyramid2);
        locsDoG2 = getLocalExtrema(DoGPyramid2, DoGLevels2, PrincipalCurvature2, theta_c, theta_r);
        [locs2,desc2] = computeBrief(im2, GaussianPyramid2, locsDoG2, k, levels, compareA, compareB);

        matches = briefMatch(desc1, desc2);
        nMatches = [nMatches, size(matches, 1)];
    end
    
    bar(x, nMatches);
    title('Rotating the Image')
    xlabel('Angle')
    ylabel('Number of Matches')
end

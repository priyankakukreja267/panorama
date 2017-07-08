function [locsDoG, GaussianPyramid] = DoGdetector(im, sigma0, k, levels, th_contrast, th_r)
    
    GaussianPyramid = createGaussianPyramid(im, sigma0, k, levels);
    %displayPyramid(GaussianPyramid)
    [DoGPyramid, DoGLevels] = createDoGPyramid(GaussianPyramid, levels);
    PrincipalCurvature = computePrincipalCurvature(DoGPyramid);
    locsDoG = getLocalExtrema(DoGPyramid, DoGLevels, PrincipalCurvature, th_contrast, th_r);
end

%    img = '../data/chickenbroth_01.jpg';
%    im = imread(img);
%    sigma0 = 1;
%    k = 2;
%    levels = [-1;0;1;2;3;4];
%    th_r = 12;
%    th_contrast = 0.03;

% imshow(im)
% hold
% x = locsDoG(:, 1);
% y = locsDoG(:, 2);
% plot(x,y,'g.','MarkerSize',7);
% saveas(gcf,'q1_5','jpeg')

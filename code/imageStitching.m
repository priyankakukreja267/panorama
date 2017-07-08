function [panoImg] = imageStitching(img1, img2, H2to1)
%
% input
% Warps img2 into img1 reference frame using the provided warpH() function
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear equation
%
% output
% Blends img1 and warped img2 and outputs the panorama image

    %out_size =
    %576   947

    im1 = imread(img1);
    im2 = imread(img2);
    L = size(im1, 1);
    B = size(im1, 2);
    
    out_size = 2*[L B];
    im2_warped = warpH(im2, H2to1, out_size);
    im2_warped(1:out_size(1), 1:out_size(2), :) = im1;    
    panoImg = im2_warped;
    imshow(panoImg);
    imwrite(panoImg, '../results/q5_1.jpg');
    save('../results/q5_1.mat', 'H2to1');
end
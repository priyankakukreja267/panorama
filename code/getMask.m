function mask = getMask(im)
    mask = zeros(size(im,1), size(im,2));
    mask(1,:) = 1; mask(end,:) = 1; mask(:,1) = 1; mask(:,end) = 1;
    mask = bwdist(mask, 'city');
    mask = mask/max(mask(:));
end

function [] = other()
mask1 = getMask(img1);
mask2 = getMask(img2);
a = size(img1, 1);
b = size(img2, 2);
out_size = [a, b];
w1 = warpH(mask1, H, out_size);
w2 = warpH(mask2, H, out_size);
imshow(imfuse(w1, w2));
end

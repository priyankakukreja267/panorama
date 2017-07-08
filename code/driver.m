sigma0 = 1;
k = 2;
levels = [-1;0;1;2;3;4];
theta_r = 12;
theta_c = 0.03;

%%%%% IMAGE - 1 %%%%%
img1 = '../data/incline_L.png';
im1 = imread(img1);
im1 = im2double(im1);
if size(im1,3)==3 % if size of 3rd dimension of a is 3
    im1= rgb2gray(im1);
end

GaussianPyramid1 = createGaussianPyramid(im1, sigma0, k, levels);
%displayPyramid(GaussianPyramid1);
[DoGPyramid1, DoGLevels1] = createDoGPyramid(GaussianPyramid1, levels);
PrincipalCurvature1 = computePrincipalCurvature(DoGPyramid1);
locsDoG1 = getLocalExtrema(DoGPyramid1, DoGLevels1, PrincipalCurvature1, theta_c, theta_r);
size(locsDoG1)

%imshow(im1)
%hold
%x = locsDoG1(:, 1);
%y = locsDoG1(:, 2);
%plot(x,y,'g.','MarkerSize',7);
%saveas(gcf,'q1_5','jpeg')

% Run the following command only once:
%patchWidth = 9;
%n = 256
%[compareA, compareB] = makeTestPattern(patchWidth, n);
%save('testPattern.mat','compareA', 'compareB');

load('testPattern.mat');
[locs1,desc1] = computeBrief(im1, GaussianPyramid1, locsDoG1, k, levels, compareA, compareB);
save('../output/locsdesc_inclineL.mat', 'locs1', 'desc1');

%%%%% IMAGE - 2 %%%%%
img2 = '../data/incline_R.png';
im2 = imread(img2);
im2 = im2double(im2);
if size(im2,3)==3 % if size of 3rd dimension of a is 3
    im2= rgb2gray(im2);
end
%im2 = im2(:, 1:700);

GaussianPyramid2 = createGaussianPyramid(im2, sigma0, k, levels);
%displayPyramid(GaussianPyramid2);
[DoGPyramid2, DoGLevels2] = createDoGPyramid(GaussianPyramid2, levels);
PrincipalCurvature2 = computePrincipalCurvature(DoGPyramid2);
locsDoG2 = getLocalExtrema(DoGPyramid2, DoGLevels2, PrincipalCurvature2, theta_c, theta_r);
[locs2,desc2] = computeBrief(im2, GaussianPyramid2, locsDoG2, k, levels, compareA, compareB);
save('../output/locsdesc_inclineR.mat', 'locs2', 'desc2');


%imshow(im2)
%hold
%x = locsDoG2(:, 1);
%y = locsDoG2(:, 2);
%plot(x,y,'g.','MarkerSize',7);
%saveas(gcf,'q1_5','jpeg')

% Run the following command only once:
%patchWidth = 9;
%n = 256
%[compareA, compareB] = makeTestPattern(patchWidth, n);
%save('testPattern.mat','compareA', 'compareB');

%load('testPattern.mat');


ratio = 0.5;
matches = briefMatch(desc1, desc2, ratio);
%size(matches)
%permMatches = matches;
%matches = permMatches(1:85,:);
%matches = vertcat(matches, permMatches(87:400,:));
plotMatches(im1, im2, matches, locs1, locs2);



%matches = matches(1:int32(end/2),:);
plotMatches(im1, im2, matches, locs1, locs2);

m = matches;

matches = matches(1:300);
p1 = locs1(matches(:,1), 1);
p1 = [p1, locs1(matches(:,1), 2)];
p1 = p1';

p2 = locs2(matches(:,2), 1);
p2 = [p2, locs2(matches(:,2), 2)];
p2 = p2';

H2to1 = computeH(p2, p1);
%save('../output/q5_1.mat', 'H');
warp_im = warpH(im2, H, out_size);
imshow(warp_im)



%img1 = '../data/incline_L.png';
%im2 = '../data/incline_R.png';


out_size = [size(im1, 1), size(im1, 2)];

nIter = 2500;
tol = 10;
Hr = ransacH(matches, locs1, locs2, nIter, tol);
img2_warped = warpH(img2, H, out_size);
panoImg = img2_warped;
%panoImg = imageStitching(img1, img2)
imshow(panoImg)


%%% RANSAC
tol = 30
nIter = 2500
H = ransacH(matches, locs1, locs2, nIter, tol);

for ratio = 0.05:0.05:1.5
matches = briefMatch(desc1, desc2, ratio);
size(matches)
%matches = tempMatches;
%matches = tempMatches(1:2000,:)
plotMatches(im1, im2, matches, locs1, locs2);

%m = matches(1:400,:);
p1 = locs1(matches(:,1), 1);
p1 = [p1, locs1(matches(:,1), 2)];
p1 = p1';

p2 = locs2(matches(:,2), 1);
p2 = [p2, locs2(matches(:,2), 2)];
p2 = p2';

H = computeH(p1, p2);
%save('../output/q5_1.mat', 'H');
%a = max(size(im1, 1), size(im2, 1));
%b = max(size(im1, 2), size(im2, 2));
a = size(im1, 1);
b = size(im2, 2);
out_size = [a, b];
warp_im = warpH(img2, H, out_size);
%figure(ratio)
imshow(warp_im)    
end

function PrincipalCurvature = computePrincipalCurvature(DoGPyramid)
%%Edge Suppression
% inputs
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
%
% outputs
% PrincipalCurvature - size (size(im), numel(levels) - 1) matrix where each point contains the curvature ratio R for the 
% 					   corresponding point in the DoG pyramid

R = size(DoGPyramid, 1);
C = size(DoGPyramid, 2);
L = size(DoGPyramid, 3);

H = zeros(2,2);
PrincipalCurvature = zeros(R, C, L);


for lev = 1:L
    % Find the gradient of all levels of DoGPyramid
    [Dx, Dy] = gradient(DoGPyramid(:, :, lev));
    [Dxx, Dxy] = gradient(Dx);
    [Dyy, ] = gradient(Dy);
    for j = 1:C
        for i = 1:R
            H = [Dxx(i,j), Dxy(i,j); Dxy(i,j), Dyy(i,j)]; % Find the Hessian
            PrincipalCurvature(i,j,lev) = (trace(H)^2)/det(H);
        end
    end    
end

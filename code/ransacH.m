function [bestH] = ransacH(matches, locs1, locs2, nIter, tol)
% input
% locs1 and locs2 - matrices specifying point locations in each of the images
% matches - matrix specifying matches between these two sets of point locations
% nIter - number of iterations to run RANSAC
% tol - tolerance value for considering a point to be an inlier
% output
% bestH - homography model with the most inliers found during RANSAC

%{
for any 4 points of matches
    h = compute homography
    find the projected points
    find the error in projected and actual points of img2
    print error
%}

    maxInliers = 0;
    nMatches = size(matches, 1);
    for i = 1:nIter
        index = randi([1 nMatches],1,4);
        Lx = locs1(matches(index, 1), 1);
        Ly = locs1(matches(index, 1), 2);
        p1 = [Lx Ly]';

        Rx = locs2(matches(index, 2), 1);
        Ry = locs2(matches(index, 2), 2);
        p2 = [Rx Ry]';

        % compute homography matrix
        H = computeH(p2, p1);

        % Find estimated value
        L = [locs1(matches(:,1), 1) locs1(matches(:, 1), 2) ones(nMatches,1)];
        L = L';
        est = H*L;
        est(1,:) = est(1,:) ./est(3,:);
        est(2,:) = est(2,:) ./est(3,:);
        est(3,:) = est(3,:) ./est(3,:);
        est = est(1:2,:);
        est = est';
        R = [locs2(matches(:,2), 1) locs2(matches(:, 2), 2)];

        distances = pdist2(est, R);
        distances = diag(distances);
        inliers = nnz(distances(:) < tol);
        if inliers > maxInliers
            bestH = H;
            maxInliers = inliers;
        elseif inliers == maxInliers
            %display('same!')
        end
    end
    maxInliers;
end
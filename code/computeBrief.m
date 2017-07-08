function [locs,desc] = computeBrief(im, GaussianPyramid, locsDoG, k, levels, compareA, compareB)
    %%Compute Brief feature
    % input
    % im - a grayscale image with values from 0 to 1
    % locsDoG - locsDoG are the keypoint locations returned by the DoG detector
    % levels - Gaussian scale levels that were given in Section1
    % compareA and compareB - linear indices into the patchWidth x patchWidth image patch and are each nbits x 1 vectors
    %
    % output
    % locs - an m x 3 vector, where the first two columns are the image coordinates of keypoints and the third column is 
    %		 the pyramid level of the keypoints
    % desc - an m x n bits matrix of stacked BRIEF descriptors. m is the number of valid descriptors in the image and will vary    
    nInterestPoints = size(locsDoG, 1);
    nbits = length(compareA);
    R = size(GaussianPyramid, 1);
    C = size(GaussianPyramid, 2);
    locs = [];
    desc = [];
    bitVector = [];
    
    for i = 1:nInterestPoints
        bitVector = [];
        for j = 1:nbits
            p1 = compareA(j);
            p2 = compareB(j);
            result = getDescriptorBit(GaussianPyramid, locsDoG, i, p1, p2, R, C);
            bitVector = [bitVector, result];
        end
        if sum(isnan(bitVector)) == 0
            desc = [desc; bitVector];
            locs = [locs; [locsDoG(i, 1), locsDoG(i, 2), locsDoG(i, 3)]];
        end
    end
end

function isSet = getDescriptorBit(GaussianPyramid, locsDoG, cIndex, p1, p2, R, C)
%% p1, p2 are 2X1 matrix
% if they are invalid, return NaN
% else, check if p1 > p2, return 1, else return 0
    
    isValid = true;
    row = locsDoG(cIndex, 2);
    col = locsDoG(cIndex, 1);

    % Check if the point p1 is valid
    X1 = (fix((p1-1)/9) + 1) - 5;
    Y1 = mod(p1 - 1, 9) - 4;
    if row+X1 < 1
        isValid = false;
    end
    if row+X1 > R
        isValid = false;
    end
    if col+Y1 < 1
        isValid = false;
    end
    if col+Y1 > C
        isValid = false;
    end
    
    % Check if the point p2 is valid
    X2 = (fix((p2-1)/9) + 1) - 5;
    Y2 = mod(p2 - 1, 9) - 4;
    if row+X2 < 1
        isValid = false;
    end
    if row+X2 > R
        isValid = false;
    end
    if col+Y2 < 1
        isValid = false;
    end
    if col+Y2 > C
        isValid = false;
    end
    
    if not(isValid)
        isSet = NaN;
    else
        pt1X = row+X1;
        pt1Y = col+Y1;
        
        pt2X = row+X2;
        pt2Y = col+Y2;
        %sprintf('cIndex = %d, locsDog(cIndex) = %d', cIndex, locsDoG(cIndex, 3)) %cIndex
        intensityP1 = GaussianPyramid(pt1X, pt1Y, locsDoG(cIndex, 3) + 2); %????
        intensityP2 = GaussianPyramid(pt2X, pt2Y, locsDoG(cIndex, 3) + 2);
        isSet = (intensityP1 > intensityP2);
    end
end
function locs = getLocalExtrema(DoGPyramid, DoGLevels, PrincipalCurvature,th_contrast, th_r)
%%Detecting Extrema
% inputs
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
% DoG Levels
% PrincipalCurvature - size (size(im), numel(levels) - 1) matrix contains the curvature ratio R
% th_contrast - remove any point that is a local extremum but does not have a DoG response magnitude above this threshold
% th_r - remove any edge-like points that have too large a principal curvature ratio
% output
% locs - N x 3 matrix where the DoG pyramid achieves a local extrema in both scale and space, and also satisfies the two thresholds.

    locs = []; %zeros(1,3);

%  A point is selected if:
%  - it is an extrema in DoG
%  - abs(DoG) > th_contrast
%  - PrincipalCurvature < th_r: old

    R = size(DoGPyramid, 1);
    C = size(DoGPyramid, 2);
    L = length(DoGLevels);
    
    nbrhood = [];

    for l = 1:L
        for j = 1:C
            for i = 1:R
                nbrhood = [];
                nbrhood = getNbrhood(i, j, l, DoGPyramid);
                
                if isExtrema(DoGPyramid(i, j, l), nbrhood) & abs(DoGPyramid(i, j, l)) > th_contrast & PrincipalCurvature(i, j, l) < th_r
                    %sprintf('(%d, %d, %d) is selected', i, j, l)
                    locs = [locs; j, i, DoGLevels(l)];
                end
            end
        end
    end
    %locs
end

%% returns true if the given point 'pt' is an extrema
% 'nbrhood' is the set of neighbouring points: 8 at the same level, 1 in
% level above, 1 in below (10 in total)
function result = isExtrema(pt, nbrhood)
    if pt > max(nbrhood) | pt < min(nbrhood)
        result = true;
    else
        result = false;
    end
end

%% returns the nbrhood around a point (i, j, l)
% Adds all the 26 points around a given point (i, j, l)
function nbrhood = getNbrhood(i, j, l, DoGPyramid)
    R = size(DoGPyramid, 1);
    C = size(DoGPyramid, 2);
    L = size(DoGPyramid, 3);
    nbrhood = [];
    
    % check if point in scale below is a valid index: (:, :, l-1)
    if l-1 >= 1
        nbrhood = [nbrhood; DoGPyramid(i, j, l-1)];

        % Row (i-1, :, l-1)
        if i-1 >= 1
            nbrhood = [nbrhood; DoGPyramid(i-1, j, l-1)];
            if j-1 >= 1
                nbrhood = [nbrhood; DoGPyramid(i-1, j-1, l-1)]; % DoGPyramid(i - 1, j + 1, l)];
            end
            if j+1 <= C
                nbrhood =  [nbrhood; DoGPyramid(i-1, j+1, l-1)];
            end
        end

        % Row (i+1, :, l-1)
        if i+1 <= R
            nbrhood = [nbrhood; DoGPyramid(i+1, j, l-1)]; %DoGPyramid(i + 1, j, l); DoGPyramid(i + 1, j + 1, l)];                
            if j-1 >= 1
                nbrhood = [nbrhood; DoGPyramid(i+1, j-1, l-1)]; % DoGPyramid(i - 1, j + 1, l)];
            end    
            if j+1 <= C
                nbrhood =  [nbrhood; DoGPyramid(i+1, j+1, l-1)];
            end
        end

        % Column (i, j-1, l-1)
        if j-1 >= 1
            nbrhood = [nbrhood; DoGPyramid(i, j-1, l-1)];
        end

        % Column (i, j+1, l-1)
        if j+1 <= C
            nbrhood = [nbrhood; DoGPyramid(i, j+1, l-1)];                    
        end                
    end

    % check if point in scale above is a valid index: (:, :, l-1)
    if l+1 <= L %length(DoGLevels) - 1
        nbrhood = [nbrhood; DoGPyramid(i, j, l+1)];
        % Row (i-1, :, l+1)
        if i-1 >= 1
            nbrhood = [nbrhood; DoGPyramid(i-1, j, l+1)];
            if j-1 >= 1
                nbrhood = [nbrhood; DoGPyramid(i-1, j-1, l+1)]; % DoGPyramid(i - 1, j + 1, l)];
            end
            if j+1 <= C
                nbrhood =  [nbrhood; DoGPyramid(i-1, j+1, l+1)];
            end
        end

        % Row (i+1, :, l+1)
        if i+1 <= R
            nbrhood = [nbrhood; DoGPyramid(i+1, j, l+1)]; %DoGPyramid(i + 1, j, l); DoGPyramid(i + 1, j + 1, l)];                
            if j-1 >= 1
                nbrhood = [nbrhood; DoGPyramid(i+1, j-1, l+1)]; % DoGPyramid(i - 1, j + 1, l)];
            end    
            if j+1 <= C
                nbrhood =  [nbrhood; DoGPyramid(i+1, j+1, l+1)];
            end
        end

        % Column (i, j-1, l+1)
        if j-1 >= 1
            nbrhood = [nbrhood; DoGPyramid(i, j-1, l+1)];
        end

        % Column (i, j+1, l+1)
        if j+1 <= C
            nbrhood = [nbrhood; DoGPyramid(i, j+1, l+1)];                    
        end
    end

    % check all points at same scale in the row before
    if i-1 >= 1
        nbrhood = [nbrhood; DoGPyramid(i-1, j, l)];
        if j-1 >= 1
            nbrhood = [nbrhood; DoGPyramid(i-1, j-1, l)]; % DoGPyramid(i - 1, j + 1, l)];
        end
        if j+1 <= C
            nbrhood =  [nbrhood; DoGPyramid(i-1, j+1, l)];
        end
    end

    % check all points at same scale in the row after
    if i+1 <= R
        nbrhood = [nbrhood; DoGPyramid(i+1, j, l)]; %DoGPyramid(i + 1, j, l); DoGPyramid(i + 1, j + 1, l)];                
        if j-1 >= 1
            nbrhood = [nbrhood; DoGPyramid(i+1, j-1, l)]; % DoGPyramid(i - 1, j + 1, l)];
        end    
        if j+1 <= C
            nbrhood =  [nbrhood; DoGPyramid(i+1, j+1, l)];
        end
    end

    % check points at the left and right of given point
    if j-1 >= 1
        nbrhood = [nbrhood; DoGPyramid(i, j-1, l)];
    end

    if j+1 <= C
        nbrhood = [nbrhood; DoGPyramid(i, j+1, l)];                    
    end
end
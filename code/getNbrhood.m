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
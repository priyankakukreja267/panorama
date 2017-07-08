function H2to1 = computeH(p2,p1)
% inputs:
% p1 and p2 should be 2 x N matrices of corresponding (x, y)' coordinates between two images
%
% outputs:
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear equation

    N = size(p1, 2);
    A = [];
    
    x1 = p1(1,:);
    x1 = x1';
    y1 = p1(2,:);
    y1 = y1';
    
    x2 = p2(1,:);
    x2 = x2';
    y2 = p2(2,:);
    y2 = y2';

    % Original
    %hi = [x1 y1 ones(N,1) zeros(N,3) -x1.*x2 -y1.*x2 -x2];
    %lo = [zeros(N,3) x1 y1 ones(N,1) -x1.*y2 -y1.*y2 -y2];

    %New
    hi = [x2 y2 ones(N,1) zeros(N,3) -x2.*x1 -y2.*x1 -x1];
    lo = [zeros(N,3) x2 y2 ones(N,1) -x2.*y1 -y2.*y1 -y1];

    A = [hi;lo];

    size(A);
    %sqA = A'*A;
    [U S V] = svd(A');%'*A);
    h = U(:,end);
    size(h);
    H = reshape(h, 3, 3)';
    %H = H';
    H2to1 = H./H(3,3);

%    H2to1 = A;
end
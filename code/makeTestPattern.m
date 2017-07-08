function [compareA, compareB] = makeTestPattern(patchWidth, nbits)  
% input
% patchWidth - the width of the image patch (usually 9)
% nbits - the number of tests n in the BRIEF descriptor
% output
% compareA and compareB - linear indices into the patchWidth x patchWidth image patch and are each nbits x 1 vectors. 
%
% Run this routine for the given parameters patchWidth = 9 and n = 256 and save the results in testPattern.mat.

% generates random numbers from 1 to N. 
% => N = 9 and then do '-5' => [-4, 4]
% 

% Using Method - 2 to generate the test Pattern
mu = 5;
sigma = patchWidth*patchWidth/25;

x1 = [];
while length(x1) ~= nbits
    a = round(sigma*randn(1,1) + mu);
    if a >= 1 & a <= 9
        x1 = [x1; a];
    end
end

y1 = [];
while length(y1) ~= nbits
    a = round(sigma*randn(1,1) + mu);
    if a >= 1 & a <= 9
        y1 = [y1; a];
    end
end

x2 = [];
while length(x2) ~= nbits
    a = round(sigma*randn(1,1) + mu);
    if a >= 1 & a <= 9
        x2 = [x2; a];
    end
end

y2 = [];
while length(y2) ~= nbits
    a = round(sigma*randn(1,1) + mu);
    if a >= 1 & a <= 9
        y2 = [y2; a];
    end
end

compareA = ((x1-1).*9) + y1;
compareB = ((x2-1).*9) + y2;


%2 gaussians from 1 to 9, mu 5, sigma ?, Make a linear index from this, and then make the matching right
%1,1 => 1
%9,9 => 81
%a,b => (a-1)*9 + b
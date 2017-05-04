% num = match(image1, image2)
%
% This function reads two images, finds their SIFT features, and
%   displays lines connecting the matched keypoints.  A match is accepted
%   only if its distance is less than distRatio times the distance to the
%   second closest match.
% It returns the number of matches displayed.
%
% Example: match('scene.pgm','book.pgm');

function [] = show_match_clear(im1, im2, loc1,loc2)

addpath('C:\Users\yoshi\Documents\MATLAB\SIFT\OriginalCode');
% Create a new image showing the two images side by side.
im3 = appendimages(im1,im2);

% Show a figure with lines joining the accepted matches.
figure('Position', [100 100 size(im3,2) size(im3,1)]);
colormap('gray');
imagesc(im3);
hold on;
cols1 = size(im1,2);
for i = 1: size(loc1,1)
    line([loc1(i,1) loc2(i,1)+cols1], ...
         [loc1(i,2) loc2(i,2)], 'Color', 'c');
end
hold off;
% ri@HFLAB changed in May 4
% 1. change sift to sift_ri
% 2. omit showing figure
% 3. output matched points cloud

% [points1 points2] = match_ri(image1, image2)
%
% This function reads two images, finds their SIFT features, and
%   displays lines connecting the matched keypoints.  A match is accepted
%   only if its distance is less than distRatio times the distance to the
%   second closest match.
% It returns the number of matched coordinate.
% Example of Out put >> 
% [ [p1_y1 p1_x1],[p1_y2 p1_x2] ]
%              ...
% [ [pn_y1 pn_x1],[pn_y2 pn_x2] ]

function [p1 p2] = match(image1, image2)

% Find SIFT keypoints for each image
[im1, des1, loc1] = sift_ri(image1);
[im2, des2, loc2] = sift_ri(image2);

% For efficiency in Matlab, it is cheaper to compute dot products between
%  unit vectors rather than Euclidean distances.  Note that the ratio of 
%  angles (acos of dot products of unit vectors) is a close approximation
%  to the ratio of Euclidean distances for small angles.
%
% distRatio: Only keep matches in which the ratio of vector angles from the
%   nearest to second nearest neighbor is less than distRatio.
distRatio = 0.6;   

%% For each descriptor in the first image, select its match to second image.
des2t = des2';                          % Precompute matrix transpose
for i = 1 : size(des1,1)
   dotprods = des1(i,:) * des2t;        % Computes vector of dot products
   [vals,indx] = sort(acos(dotprods));  % Take inverse cosine and sort results
   % Check if nearest neighbor has angle less than distRatio times 2nd.
   if (vals(1) < distRatio * vals(2))
      match(i) = indx(1);
   else
      match(i) = 0;
   end
end
num = sum(match > 0); 		%count match


%% Put matched points in the Points matrix
p1 = zeros(num,2); % points clouds
p2 = zeros(num,2); % points clouds
cnt = 1;

for i = 1: size(des1,1)
  if (match(i) > 0)
    p1(cnt,:)=loc1(i,1:2);
    p2(cnt,:)=loc2(match(i),1:2);
    cnt = cnt + 1;
  end
end





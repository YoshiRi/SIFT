%% test for SIFT
clear all
close all
%%
addpath('C:\Users\yoshi\Documents\MATLAB\SIFT');
 
img1 = imread('image1.bmp');
img2 = imread('image2.bmp');

%% test program
show_match(img1,img2);

%% take matching and showing
[p1 p2] = match_ri(img1,img2);
c1 = size(img1)/2;
c2 = size(img2)/2;
p1 = p1 - repmat([c1(2) c1(1)],size(p1,1),1);
p2 = p2 - repmat([c2(2) c2(1)],size(p2,1),1);
[Param Affine p1m p2m] = Helmert2D(p1,p2);

% show match
p1m = p1m + repmat([c1(2) c1(1)],size(p1m,1),1);
p2m = p2m + repmat([c2(2) c2(1)],size(p2m,1),1);
show_match_clear(img1,img2,p1m,p2m);


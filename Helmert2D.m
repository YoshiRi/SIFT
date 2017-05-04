% 2017/5/4 Yoshi Ri @ UT
% Extract 2D Helmert parameter, translation rotation scaling
% 
% Input 
% 
% 
% 
% Extract using equation
% [ x y ]^T = [ a b c; d e f ] [x_t y_t 1]^T 

function [Pp  Para]= Helmert2D(Xref,X)

Sz = size(Xref);
if Sz ~= size(X)
    error('Different Size!\n');
end

%% get affineParam [abcdef]'
NP = Sz(2); % number of points

zeromat = zeros(NP,3);
onemat = ones(NP,1);

Aup = horzcat(Xref,onemat,zeromat);
Adown = horzcat(zeromat,Xref,onemat);
A = vertcat(Aup,Adown);

b = vertcat(X(1,:)',X(2,:)');

% parameter [ a b c d e f ]'
Para = pinv(A)*b; 

%% output Estimated parameter
scale = sqrt((Para(1)^2+Para(2)^2+Para(4)^2+Para(5)^2)/2);
theta = atan2(Para(2),Para(1));

Ar = zeros(2);
Ar(1,1) = Para(1);
Ar(1,2) = Para(2);
Ar(2,1) = Para(4);
Ar(2,2) = Para(5);

At = inv(Ar) * [Para(3);Para(6)];

Pp = zeros(4,1);
% Pp(1) = Para(3);
% Pp(2) = Para(6);
Pp(1) = At(1);
Pp(2) = At(2);
Pp(4) = theta;
Pp(3) = 1/scale;
end
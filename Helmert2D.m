% 2017/5/4 Yoshi Ri @ UT
% Extract 2D Helmert parameter, translation rotation scaling
% 
% Input :(x*,y*) (x,y)
% Output: [translation 1/scaling rotation], [a b c d], matched Xref,
% matched X, FinalErr or Success
%  If there is no matching or miss, return -1
% 
% Extract using equation
% [ x y ]^T = [ a b c; -b a d ] [x_t y_t 1]^T 

function [Pp , Para, Xref ,X, FinalErr]= Helmert2D(Xref,X)

if size(Xref) ~= size(X)
    error('Different Size!\n');
elseif   size(Xref,1) < 2
%     error('Feature points must be more than 2');
    Pp = 0;Para = 0;FinalErr = -1;
    return;
end

%% get affineParam [abcdef]'
NP = size(Xref,1); % number of points

zeromat = zeros(NP,1);
onemat = ones(NP,1);

% begin ransac
flag =1;
while flag
    if size(Xref,1) < 2
        Pp = 0;Para = 0;FinalErr = -1;
        return;
    end

    Aup = horzcat(Xref,onemat,zeromat);
    Adown = horzcat(Xref(:,2),-Xref(:,1),zeromat,onemat);
    A = vertcat(Aup,Adown);

    b = vertcat(X(:,1),X(:,2));

% parameter [ a b c d ]'
    Para = pinv(A)*b; 

%% exclude  mismatch
    Err =A*Para -b;
    er = Err(1:size(Err,1)/2).^2 +Err(size(Err,1)/2+1:size(Err,1)).^2;
    EX = find(er>median(er)*2);
    sz = size(EX,1);
    if sz < 1
        break;
    end
    % exclude data
    Xref(EX,:)=[];
    X(EX,:)=[];
    onemat(EX)=[];zeromat(EX)=[];
end

FinalErr = sum(er)/size(er,1);

%% output Estimated parameter
scale = sqrt(Para(1)^2+Para(2)^2);
theta = atan2(Para(2),Para(1));

Ar = zeros(2);
Ar(1,1) = Para(1);
Ar(1,2) = Para(2);
Ar(2,1) = -Para(2);
Ar(2,2) = Para(1);

At = Ar\ [Para(3);Para(4)];

Pp = zeros(4,1);
% Pp(1) = Para(3);
% Pp(2) = Para(6);
Pp(1) = At(1);
Pp(2) = At(2);
Pp(4) = theta;
Pp(3) = 1/scale;
end
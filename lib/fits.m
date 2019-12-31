% returns the r^2 value and linear fit for all the rows of x compared to y.
% 
% @INPUTS:
%   x: M x N matrix with of the independent variable
%   y: 1 x N (if it is N x 1 it will be automatically transposed) vector
%     representing the dependent variable
% 
% @OUTPUTS:
%   P: M x 2 vector representing the slope and y intercept of the linear
%     fit between each row of x and y
%   R: M x 1 vector of R^2 values corresponding to the fit between each row
%     of x and y
%   xHat: (for plotting results) M x 100 matrix of the x-values
%     corresponding to yHat (see below)
%   yHat: (for plotting results) M x 100 matrix with estimates of y using
%     p. Each row corresponds to estimates of y related to the same row in
%     x.
% 
% Taylor Webb
% Summer 2019
% taylor.webb@utah.edu

function [P,R,xHat,yHat,conf] = fits(x,y)
%% Error Checking
if length(y) ~= size(x,2)
    error('The number of columns in x must equal the length of y!')
end

if size(y,1)>size(y,2)
    y = y';
end

%% Perform fits
P = zeros(size(x,1),2);
R = zeros(size(x,1),1);
xHat = zeros(size(x,1),100);
yHat = zeros(size(x,1),100);
conf = xHat;
for ii = 1:size(x,1)
    curX = x(ii,:);
    [P(ii,:),R(ii),~,xHat(ii,:),yHat(ii,:),conf(ii,:)] = myPolyFit(curX,y,'poly',1);
end
% Find coefficient of determination
% 
% @INPUTS
%   y: y data
%   yHat: Estimated y data
% 
% @OUTPUTS
%   R: R^2 value
% 
% Taylor Webb
% Stanford University
% September 2016

function R = rSquared(y,yHat)

R = 1-sum((yHat-y).^2)/sum((y-mean(y)).^2);
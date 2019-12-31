% Fit data with a polynomial and return the R^2 value
% 
% @INPUTS
%   x: x data
%   y: y data
%   order: order polynomial to use
%   h: optional. h is a figure handle, if it exists a plot is generated
%      comparing the fit to the actual data.
%   type: optional. Poly or Exp for a polynomial fit or an exponential one
% 
% @OUTPUTS
%   p: Polynomial coefficients (same order as polyfit)
%   R: R^2 value
%   yHat: estimates of y at x based on the fit
%   x2: evenly distributed x for plotting model
%   y2: yHat values corresponding to x2
%   conf: 95% confidence interval at each y2 point
% 
% Taylor Webb
% Stanford University
% September 2016

function [p,R,yHat,x2,y2,conf] = myPolyFit(x,y,type,order,yIntercept)

if nargin < 3
    type = 'Poly';
    order = 1;
elseif nargin < 4
    order = 1;
end

x2 = linspace(0,2*max(x),100);

if ~exist('yIntercept','var')
    yIntercept = [];
end

if strcmpi(type, 'poly')
    if ~isempty(yIntercept)
        [p,s] = polyfitB(x,y,order,yIntercept);
    else
        [p,s] = polyfit(x,y,order);
    end
    [~,conf] = polyconf(p,x2,s,'predopt','curve');

    yHat = zeros(size(x));
    for ii = 1:(order+1)
        yHat = yHat+p(ii)*x.^(order+1-ii);
    end

    R = rSquared(y,yHat);

    y2 = 0;
    for ii = 1:(order+1)
        y2 = y2+p(ii)*x2.^(order+1-ii);
    end
elseif strcmpi(type, 'exp')
%     y = y-1540; % Fit so that it decays towards speed of sound of soft tissue.
    p = fit(x,y,'exp1');
    
    y2 = p.a.*exp(p.b*x2);
    yHat = p.a*exp(p.b*x);
    R = rSquared(y,yHat);
else
    error([type, ' not a recognized type!'])
end
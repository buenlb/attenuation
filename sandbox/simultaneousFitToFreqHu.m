function [fitresult, gof] = simultaneousFitToFreqHu(HU, FREQ, z, fitFunction, nVars,lowerLimits,upperLimits,initialValue)
%CREATEFIT(X,Y,Z)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : x
%      Y Input : y
%      Z Output: z
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 22-Apr-2020 12:03:56


%% Fit: 'untitled fit 1'.
[xData, yData, zData] = prepareSurfaceData( HU, FREQ, z );

% Set up fittype and options.
ft = fittype( fitFunction, 'independent', {'HU', 'FREQ'}, 'dependent', 'z' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = ones(1,nVars);
if nargin > 5
    opts.Lower = lowerLimits;
    opts.Upper = upperLimits;
end
if nargin > 7
    opts.StartPoint = initialValue;
end

% Fit model to data.
[fitresult, gof] = fit( [xData, yData], zData, ft, opts );

% Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, [xData, yData], zData );
% legend( h, 'untitled fit 1', 'z vs. x, y', 'Location', 'NorthEast', 'Interpreter', 'none' );
% % Label axes
% xlabel( 'x', 'Interpreter', 'none' );
% ylabel( 'y', 'Interpreter', 'none' );
% zlabel( 'z', 'Interpreter', 'none' );
% grid on
% view( 0.6, 90.0 );


function [fitresult, gof] = createFit(x, y)
%CREATEFIT(X,Y)
%  Create a fit.
%
%  Data for 'LinearFit' fit:
%      X Input : x
%      Y Output: y
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  另请参阅 FIT, CFIT, SFIT.

%  由 MATLAB 于 10-Mar-2023 16:30:36 自动生成


%% Fit: 'LinearFit'.
[xData, yData] = prepareCurveData( x, y );

% Set up fittype and options.
ft = fittype( 'poly1' );
opts = fitoptions( 'Method', 'LinearLeastSquares' );
opts.Robust = 'LAR';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'LinearFit' );
h = plot( fitresult, xData, yData );
legend( h, 'y vs. x', 'LinearFit', 'Location', 'NorthEast', 'Interpreter', 'none' );
% Label axes
xlabel( 'x', 'Interpreter', 'none' );
ylabel( 'y', 'Interpreter', 'none' );
grid on



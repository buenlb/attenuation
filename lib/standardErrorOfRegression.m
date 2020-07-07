function s = standardErrorOfRegression(y,yHat,nVars)
v = length(y)-nVars;
s = sqrt(sum((y-yHat).^2)/v);
function [wvLocs,multiple] = findWaveLengthMultiples(f,d,c)

lambda = c./f;
fRange = [min(lambda),max(lambda)];

nWvLengths = d/fRange(1)-d/fRange(2);

wvLocs = zeros(1,ceil(nWvLengths));
multiple = wvLocs;
for ii = 1:ceil(nWvLengths)
    multiple(ii) = floor(d/fRange(1))-(ii-1);
    tmpWaveLength = d/multiple(ii);
    wvLocs(ii) = c/tmpWaveLength;
end
multiple = multiple(wvLocs>min(f) & wvLocs<max(f));
wvLocs = wvLocs(wvLocs>min(f) & wvLocs<max(f));
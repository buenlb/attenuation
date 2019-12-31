function labelPoints(ax, x, y, labels)

axes(ax);
xlims = xlim;
ylims = ylim;
distanceThreshold = sqrt(0.0000001*xlims(2)^2 + 0.0000001*ylims(2)^2);

% label the sonications but prevent overlapping labels
labelOffsetX = 0.013*xlims(2);

% use the lower triangle to determine whether to label each point
% for each row, if the only "1" is on the identity column, then label the point
distances = pdist2([x,y], [x,y]);
closeProximityInds = tril(distances < distanceThreshold);
displayTextInds = sum(closeProximityInds, 2) == 1;

%
for j = 1:length(x)
    if displayTextInds(j)
        text(x(j)+labelOffsetX, y(j), num2str(labels{j}));
    end
end

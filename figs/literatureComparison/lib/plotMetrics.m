function plotMetrics(subjects, hasMeThermom, metrics1, metrics2, targetSonicationInds, equalAxesFlag, xlims, ylims, xLabelStr, yLabelStr, numFigRows, numFigCols, samePlotFlag)
    cmap = lines(5);
    uniqueColors = unique(cmap, 'rows');
    numColors = size(uniqueColors,1);
    
    markers = {'o', '^', 's'};
    linestyles = {'-', '--', ':'};

    mrTypeCmap = lines(6);
    mrTypeCmap(2:5,:) = [];
    
    figure; hold on;
    for i = 1:length(subjects)
        if samePlotFlag
            tmp = mod(i-1,numColors);
            subjectColor = cmap(tmp+1,:);

            tmp2 = floor((i-1)/numColors);
            markerFormatSpec = {'linestyle', 'none', 'marker', markers{tmp2+1}, 'color', subjectColor};
            lineFormatSpec = {'linestyle', linestyles{tmp2+1}};
            if hasMeThermom(i)
                markerFormatSpec = [markerFormatSpec, {'markerfacecolor', subjectColor}];
            end
        else 
            subplot(numFigRows,numFigCols,i); hold on;

            subjectColor = mrTypeCmap(1,:);
            if hasMeThermom(i)
                subjectColor = mrTypeCmap(2,:);
            end
            markerFormatSpec = {'color', subjectColor};
        end

        plot(metrics1{i}(targetSonicationInds{i}), metrics2{i}(targetSonicationInds{i}), 'o', 'linewidth', 1.25, markerFormatSpec{:});
        grid on;
        if equalAxesFlag
            axis equal;
        end
        xlim(xlims);
        ylim(ylims);
        xlabel(xLabelStr);
        ylabel(yLabelStr);
        if ~samePlotFlag
            title(subjects{i});
        end
    end
end
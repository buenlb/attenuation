% Plots attenuation as a function of frequency

if ~exist('atten500','var')
    runAttenuation
end
%%
d500 = 4.4e-3;
d1000 = 2.2e-3;

%% Plot fragments with valid measurements at all frequencies
h = figure;
hold on
ax = gca;
plot(f500,atten500(d>d500,:),'Color',ax.ColorOrder(1,:),'linewidth',2)
plot(f1000,atten1000(d>d500,:),'Color',ax.ColorOrder(2,:),'linewidth',2)
plot(f2250,atten2250(d>d500,:),'Color',ax.ColorOrder(3,:),'linewidth',2)
xlabel('Frequency')
ylabel('Attenuation (np/cm)')

h = figure;
hold on
idx = find(d>d500);
rows = ceil(sqrt(length(idx)));
cols = floor(sqrt(length(idx)));
if rows*cols < length(idx)
    cols = cols+1;
end
for ii = 1:length(idx)
    subplot(rows,cols,ii)
    hold on
    ax = gca;
    plot(f500,atten500(idx(ii),:),'Color',ax.ColorOrder(1,:),'linewidth',2)
    plot(f1000,atten1000(idx(ii),:),'Color',ax.ColorOrder(2,:),'linewidth',2)
    plot(f2250,atten2250(idx(ii),:),'Color',ax.ColorOrder(3,:),'linewidth',2)
end
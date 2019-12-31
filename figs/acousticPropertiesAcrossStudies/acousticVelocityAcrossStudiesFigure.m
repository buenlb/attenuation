leung = bonePropertiesLeung2018(false);
robertson = bonePropertiesRobertson2017(false);
vyas = bonePropertiesVyas2016(false);
kyriakou = bonePropertiesKyriakou2015(false);
pulkkinen = bonePropertiesPulkkinen2014(false);
pinton = bonePropertiesPinton2011(false);
aubry = bonePropertiesAubry2003(false);
connor = bonePropertiesConnor2002(false);

set(groot, 'defaultAxesColorOrder', lines(5), 'defaultAxesLineStyleOrder', '-|--|:');

f1 = figure; hold on;
plot(leung.hu(6:end), leung.c(6:end), 'k', 'linewidth', 1.5, 'displayname', 'This study');
plot(robertson.hu(6:end), robertson.c(6:end), 'linewidth', 1.5, 'displayname', 'Robertson{\it et al.} 2017');
plot(vyas.hu(6:end), vyas.c(6:end), 'linewidth', 1.5, 'displayname', 'Vyas{\it et al.} 2016');
plot(kyriakou.hu(6:end), kyriakou.c(6:end), 'linewidth', 1.5, 'displayname', 'Kyriakou{\it et al.} 2015');
plot(pulkkinen.hu, pulkkinen.c, 'linewidth', 1.5, 'displayname', 'Pichardo{\it et al.} 2011');
plot(pinton.hu(2231:end), pinton.c(2231:end), 'linewidth', 1.5, 'displayname', 'Pinton{\it et al.} 2011');
plot(aubry.hu(2231:end), aubry.c(2231:end), 'linewidth', 1.5, 'displayname', 'Aubry{\it et al.} 2003');
plot(connor.hu(6:end), connor.c(6:end), 'linewidth', 1.5, 'displayname', 'Connor{\it et al.} 2002');
hold off;
xlim([0, 2000]);
ylim([1000, 4000]);
grid on;
xlabel('HU'); ylabel('Acoustic velocity (m/s)');

f2 = copyobj(f1, 0);
legend('show', 'location', 'eastoutside');

set(groot, 'defaultAxesColorOrder', 'remove', 'defaultAxesLineStyleOrder', 'remove');

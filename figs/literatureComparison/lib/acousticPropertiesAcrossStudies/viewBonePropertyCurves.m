%
leung = bonePropertiesLeung2018(false);
robertson = bonePropertiesRobertson2017(false);
vyas = bonePropertiesVyas2016(false);
kyriakou = bonePropertiesKyriakou2015(false);
pulkkinen = bonePropertiesPulkkinen2014(false);
pinton = bonePropertiesPinton2011(false);
aubry = bonePropertiesAubry2003(false);
connor = bonePropertiesConnor2002(false);
%
marsac = bonePropertiesMarsac2017(false);
almquist = bonePropertiesAlmquist2014(false);
marquet = bonePropertiesMarquet2009(false);
clement = bonePropertiesClement2002(false);

% % density vs HU
% figure;
% plot(marsac.hu, marsac.rho, 'displayname', 'Marsac 2017'); hold on
% plot(vyas.hu, vyas.rho, 'displayname', 'Vyas 2016');
% h = plot(1,1,'visible','off');
% set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
% plot(marquet.hu, marquet.rho, 'displayname', 'Marquet 2009');
% plot(aubry.hu, aubry.rho, 'displayname', 'Aubry 2003');
% h = plot(1,1,'visible','off');
% set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
% plot(connor.hu, connor.rho, 'displayname', 'Connor 2002');
% hold off;
% xlabel('HU'); ylabel('density (kg/m^3)');
% xlim([-1000, 2500]);
% ylim([0, 4000]);
% grid on;
% legend('show', 'location', 'northwest');
% title('density vs HU');

% % acoustic velocity vs density
% figure; hold on
% plot(marsac.rho, marsac.c, 'displayname', 'Marsac 2017'); 
% plot(vyas.rho, vyas.c, 'displayname', 'Vyas 2016');
% h = plot(1,1,'visible','off');
% set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
% plot(marquet.rho, marquet.c, 'displayname', 'Marquet 2009');
% plot(aubry.rho, aubry.c, 'displayname', 'Aubry 2003');
% plot(clement.rho, clement.c, 'displayname', 'Clement 2002');
% plot(connor.rho, connor.c, 'displayname', 'Connor 2002');
% hve = plot(vyas.rhoExtrap, vyas.cExtrap, '--', 'color', [1,1,1]*0.5);
% hme = plot(marquet.rhoExtrap, marquet.cExtrap, '--', 'color', [1,1,1]*0.5);
% hae = plot(aubry.rhoExtrap, aubry.cExtrap, '--', 'color', [1,1,1]*0.5);
% hce = plot(clement.rhoExtrap, clement.cExtrap, '--', 'color', [1,1,1]*0.5);
% set(get(get(hve,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
% set(get(get(hme,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
% set(get(get(hae,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
% set(get(get(hce,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
% uistack([hve,hme,hae,hce], 'bottom');
% hold off;
% xlabel('density (kg/m^3)'); ylabel('speed of sound (m/s)');
% xlim([1000, 2800]);
% ylim([0, 4000]);
% grid on;
% legend('show', 'location', 'northwest');
% title('SOS vs density');

set(groot, 'defaultAxesColorOrder', lines(5), 'defaultAxesLineStyleOrder', '-|--|:');

% acoustic velocity vs HU
f1 = figure; hold on
plot(leung.hu(6:end), leung.c(6:end), 'k', 'linewidth', 1.5, 'displayname', 'This study');
plot(robertson.hu(6:end), robertson.c(6:end), 'linewidth', 1.5, 'displayname', 'Robertson{\it et al.} 2017');
plot(vyas.hu(6:end), vyas.c(6:end), 'linewidth', 1.5, 'displayname', 'Vyas{\it et al.} 2016');
plot(kyriakou.hu(6:end), kyriakou.c(6:end), 'linewidth', 1.5, 'displayname', 'Kyriakou{\it et al.} 2015');
plot(pulkkinen.hu, pulkkinen.c, 'linewidth', 1.5, 'displayname', 'Pichardo{\it et al.} 2011');
plot(pinton.hu, pinton.c, 'linewidth', 1.5, 'displayname', 'Pinton{\it et al.} 2011');
plot(aubry.hu, aubry.c, 'linewidth', 1.5, 'displayname', 'Aubry{\it et al.} 2003');
plot(connor.hu(6:end), connor.c(6:end), 'linewidth', 1.5, 'displayname', 'Connor{\it et al.} 2002');

plot(marsac.hu, marsac.c, 'linewidth', 1.5, 'displayname', 'Marsac{\it et al.} 2017'); 
plot(almquist.hu, almquist.c, 'linewidth', 1.5, 'displayname', 'Almquist{\it et al.} 2014');
plot(marquet.hu, marquet.c, 'linewidth', 1.5, 'displayname', 'Marquet{\it et al.} 2009');
% clement doesn't have HU
% plot(clement.hu, clement.c, 'displayname', 'Clement 2002');
hold off;
xlabel('HU'); ylabel('Acoustic velocity (m/s)');
xlim([0, 2000]);
ylim([0, 4000]);
grid on;


f2 = copyobj(f1, 0);
legend('show', 'location', 'eastoutside');


set(groot, 'defaultAxesColorOrder', 'remove', 'defaultAxesLineStyleOrder', 'remove');

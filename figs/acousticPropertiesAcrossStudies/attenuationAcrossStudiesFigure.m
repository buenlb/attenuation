% marsac = bonePropertiesMarsac2017(false);
% almquist = bonePropertiesAlmquist2014(false);
% marquet = bonePropertiesMarquet2009(false);
% aubry = bonePropertiesAubry2003(false);
% clement = bonePropertiesClement2002(false);
% connor = bonePropertiesConnor2002(false);

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
plot(leung.hu(6:end), leung.atten(6:end), 'k', 'linewidth', 1.5, 'displayname', 'This study');
plot(robertson.hu(6:end), robertson.atten(6:end), 'linewidth', 1.5, 'displayname', 'Robertson{\it et al.} 2017');
plot(vyas.hu(6:end), vyas.atten(6:end), 'linewidth', 1.5, 'displayname', 'Vyas{\it et al.} 2016');
plot(kyriakou.hu(6:end), kyriakou.atten(6:end), 'linewidth', 1.5, 'displayname', 'Kyriakou{\it et al.} 2015');
plot(pulkkinen.hu, pulkkinen.atten, 'linewidth', 1.5, 'displayname', 'Pichardo{\it et al.} 2011');
plot(pinton.hu, pinton.atten, 'linewidth', 1.5, 'displayname', 'Pinton{\it et al.} 2011');
plot(aubry.hu, aubry.atten, 'linewidth', 1.5, 'displayname', 'Aubry{\it et al.} 2003');
plot(connor.hu(6:end), connor.atten(6:end), 'linewidth', 1.5, 'displayname', 'Connor{\it et al.} 2002');
hold off;
xlim([0, 2000]);
ylim([0, 4]);
grid on;
xlabel('HU'); ylabel('Attenuation (Np/cm)');
% pos = get(gcf, 'position');
% h = legend('show', 'location', 'eastoutside');
% set(h, 'units', 'pixels');
% hpos = get(h, 'position');
% pos(3) = pos(3)+hpos(3)+25;
% set(gcf, 'position', pos);

f2 = copyobj(f1, 0);
legend('show', 'location', 'eastoutside');


% figure; hold on;
% % plot(leung.rho, leung.atten, 'linewidth', 1.5, 'displayname', 'Leung 2018');
% plot(vyas.rho, vyas.atten, 'linewidth', 1.5, 'displayname', 'Vyas 2016');
% plot(kyriakou.rho, kyriakou.atten, 'linewidth', 1.5, 'displayname', 'Kyriakou 2015');
% plot(pulkkinen.rho, pulkkinen.atten, 'linewidth', 1.5, 'displayname', 'Pulkkinen 2014');
% plot(pinton.rho, pinton.atten, 'linewidth', 1.5, 'displayname', 'Pinton 2011');
% % plot(aubry.hu, aubry.atten, 'linewidth', 1.5, 'displayname', 'Aubry 2003');
% plot(connor.rho, connor.atten, 'linewidth', 1.5, 'displayname', 'Connor 2002');
% % plot(strelitzki.rho, strelitzki.atten, 'linewidth', 1.5, 'displayname', 'Strelitzki 1997');
% % plot(tavakoli.rho, tavakoli.atten, 'linewidth', 1.5, 'displayname', 'Tavakoli 1992');
% hold off;
% xlim([1000, 2400]);
% ylim([0, 4]);
% grid on;
% legend('show', 'location', 'northeast');
% xlabel('Density (kg/m^3)'); ylabel('Attenuation (Np/cm)');

set(groot, 'defaultAxesColorOrder', 'remove', 'defaultAxesLineStyleOrder', 'remove');

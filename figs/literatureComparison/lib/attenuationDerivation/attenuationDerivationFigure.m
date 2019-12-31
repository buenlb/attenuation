tavakoli = tavakoli1992(false);
clarke = clarke1994(false);
strelitzki = strelitzki1997(false);

% BUA (dB/MHz/cm)
figure; hold on;
plot(tavakoli.porosity, tavakoli.BUA, 'x-', 'displayname', 'Tavakoli 1992');
plot(clarke.porosity, clarke.BUA, 'x-', 'displayname', 'Clarke 1994');
plot(strelitzki.porosity, strelitzki.BUA, 'x-', 'displayname', 'Strelitzki 1997');
xlim([0 100]);
ylim([0 50]);
grid on;
xlabel('Porosity (%)');
ylabel('BUA (dB/MHz/cm)');
legend('show');

% attenuation at 680 kHz (dB/cm)
targetFreq = 0.68;      % MHz
figure; hold on;
plot(tavakoli.porosity, tavakoli.buaSlope*targetFreq+tavakoli.buaIntercept, 'x-', 'displayname', 'Tavakoli 1992');
plot(clarke.porosity, clarke.buaSlope*targetFreq+clarke.buaIntercept, 'x-', 'displayname', 'Clarke 1994');
plot(strelitzki.porosity, strelitzki.BUA*targetFreq, 'x-', 'displayname', 'Strelitzki 1997');
xlim([0 100]);
ylim([0 50]);
grid on;
xlabel('Porosity (%)');
ylabel('Attenuation (dB/cm)');
legend('show');
title('Attenuation at 680 kHz');

% attenuation vs porosity at 680 kHz (Np/cm), empirical
targetFreq = 0.68;      % MHz
figure; hold on;
plot(tavakoli.porosity, (tavakoli.buaSlope*targetFreq+tavakoli.buaIntercept)/8.686, 'x-', 'displayname', 'Tavakoli 1992', 'linewidth', 1.5);
% plot(clarke.porosity, (clarke.buaSlope*targetFreq+clarke.buaIntercept)/8.686, 'x-', 'displayname', 'Clarke 1994');
plot(strelitzki.porosity, (strelitzki.BUA*targetFreq)/8.686, 'x-', 'displayname', 'Strelitzki 1997', 'linewidth', 1.5);
xlim([0 100]);
ylim([0 4]);
grid on;
xlabel('Porosity (%)');
ylabel('Attenuation (Np/cm)');
legend('show');

% attenuation vs HU at 680 kHz (Np/cm), empirical & scaled
targetFreq = 0.68;      % MHz
figure; hold on;
plot((100-tavakoli.porosity)/100*2000, (tavakoli.buaSlope*targetFreq+tavakoli.buaIntercept)/8.686, 'x-', 'displayname', 'Tavakoli 1992', 'linewidth', 1.5);
% plot((100-clarke.porosity)/100*2000, (clarke.buaSlope*targetFreq+clarke.buaIntercept)/8.686/2.9*2.136, 'x-', 'displayname', 'Clarke 1994, scaled');
plot((100-strelitzki.porosity)/100*2000, (strelitzki.BUA*targetFreq)/8.686/2.9*2.136, 'x-', 'displayname', 'Strelitzki 1997, scaled', 'linewidth', 1.5);
xlim([0 2000]);
ylim([0 4]);
grid on;
xlabel('HU');
ylabel('Attenuation (Np/cm)');
legend('show');

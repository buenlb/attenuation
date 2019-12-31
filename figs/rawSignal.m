% Makes the figure of the raw data signals

%% Cortical Fragment
idx = 15;

t500 = FragData(idx).Attenuation.kHz500.RawData.t;
t1000 = FragData(idx).Attenuation.kHz1000.RawData.t;
t2250 = FragData(idx).Attenuation.kHz2250.RawData.t;

dt500 = t500(2)-t500(1);
f500 = fftX(dt500,length(t500))/1e6;
m500_nb = abs(fft(FragData(idx).Attenuation.kHz500.RawData.pnb{1}));
m500_b = abs(fft(FragData(idx).Attenuation.kHz500.RawData.pb{1}));
maxNb500 = max(m500_nb);

dt1000 = t1000(2)-t1000(1);
f1000 = fftX(dt1000,length(t1000))/1e6;
m1000_nb = abs(fft(FragData(idx).Attenuation.kHz1000.RawData.pnb{1}));
m1000_b = abs(fft(FragData(idx).Attenuation.kHz1000.RawData.pb{1}));
maxNb1000 = max(m1000_nb);

dt2250 = t2250(2)-t2250(1);
f2250 = fftX(dt2250,length(t2250))/1e6;
m2250_nb = abs(fft(FragData(idx).Attenuation.kHz2250.RawData.pnb{1}));
m2250_b = abs(fft(FragData(idx).Attenuation.kHz2250.RawData.pb{1}));
maxNb2250 = max(m2250_nb);

h = figure;
ax = gca;
plt(1) = plot(f500,20*log10(m500_nb/maxNb500),'-','linewidth',2);
hold on
ax.ColorOrderIndex = 1;
plot(f500,20*log10(m500_b/maxNb500),'--','linewidth',2);

plt(2) = plot(f1000,20*log10(m1000_nb/maxNb1000),'-','linewidth',2);
ax.ColorOrderIndex = 2;
plot(f1000,20*log10(m1000_b/maxNb1000),'--','linewidth',2);

plt(3) = plot(f2250,20*log10(m2250_nb/maxNb2250),'-','linewidth',2);
ax.ColorOrderIndex = 3;
plot(f2250,20*log10(m2250_b/maxNb2250),'--','linewidth',2);

axis([0,3,-50,0])
xlabel('Frequency (MHz)')
ylabel('dB')
legend(plt,'0.5 MHz','1 MHz','2.25 MHz','location','southeast')
grid on;
makeFigureBig(h);
%% Medullary Fragment
idx = 6;

t500 = FragData(idx).Attenuation.kHz500.RawData.t;
t1000 = FragData(idx).Attenuation.kHz1000.RawData.t;
t2250 = FragData(idx).Attenuation.kHz2250.RawData.t;

dt500 = t500(2)-t500(1);
f500 = fftX(dt500,length(t500))/1e6;
m500_nb = abs(fft(FragData(idx).Attenuation.kHz500.RawData.pnb{1}));
m500_b = abs(fft(FragData(idx).Attenuation.kHz500.RawData.pb{1}));
maxNb500 = max(m500_nb);

dt1000 = t1000(2)-t1000(1);
f1000 = fftX(dt1000,length(t1000))/1e6;
m1000_nb = abs(fft(FragData(idx).Attenuation.kHz1000.RawData.pnb{1}));
m1000_b = abs(fft(FragData(idx).Attenuation.kHz1000.RawData.pb{1}));
maxNb1000 = max(m1000_nb);

dt2250 = t2250(2)-t2250(1);
f2250 = fftX(dt2250,length(t2250))/1e6;
m2250_nb = abs(fft(FragData(idx).Attenuation.kHz2250.RawData.pnb{1}));
m2250_b = abs(fft(FragData(idx).Attenuation.kHz2250.RawData.pb{1}));
maxNb2250 = max(m2250_nb);

h = figure;
ax = gca;
plt(1) = plot(f500,20*log10(m500_nb/maxNb500),'-','linewidth',2);
hold on
ax.ColorOrderIndex = 1;
plot(f500,20*log10(m500_b/maxNb500),'--','linewidth',2);

plt(2) = plot(f1000,20*log10(m1000_nb/maxNb1000),'-','linewidth',2);
ax.ColorOrderIndex = 2;
plot(f1000,20*log10(m1000_b/maxNb1000),'--','linewidth',2);

plt(3) = plot(f2250,20*log10(m2250_nb/maxNb2250),'-','linewidth',2);
ax.ColorOrderIndex = 3;
plot(f2250,20*log10(m2250_b/maxNb2250),'--','linewidth',2);

axis([0,3,-50,0])
xlabel('Frequency (MHz)')
ylabel('dB')
legend(plt,'0.5 MHz','1 MHz','2.25 MHz','location','southeast')
grid on;
makeFigureBig(h);
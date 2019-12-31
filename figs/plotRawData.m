function plotRawData(FragData,fragIdx,plotLgd,imgPath)

fSize = 22;

% 500 kHz
h = figure;
sp1 = subplot(411);
ax = gca;
t = FragData(fragIdx).Attenuation.kHz500.RawData.t*1e6;
pb = FragData(fragIdx).Attenuation.kHz500.RawData.pb{1}*1e3;
pnb = FragData(fragIdx).Attenuation.kHz500.RawData.pnb{1}*1e3;

pb = pb-mean(pb);
pnb = pnb-mean(pnb);

dt = t(2)-t(1);
f500 = fftX(dt,length(t));
PB500 = abs(fft(pb));
PNB500 = abs(fft(pnb));

plot(t,pnb,'-',t,pb,'--','linewidth',2,'Color',ax.ColorOrder(1,:))

axis([34,46,min(pnb),max(pnb)]);
xticks('');
yticks([200])
makeFigureBig(h,fSize,fSize)
% set(h,'position',[488.0000  581.8000  381.0000  180.2000]);

% 1 MHz
sp2 = subplot(412);
t = FragData(fragIdx).Attenuation.kHz1000.RawData.t*1e6;
pb = FragData(fragIdx).Attenuation.kHz1000.RawData.pb{1}*1e3;
pnb = FragData(fragIdx).Attenuation.kHz1000.RawData.pnb{1}*1e3;

pb = pb-mean(pb);
pnb = pnb-mean(pnb);

dt = t(2)-t(1);
f1000 = fftX(dt,length(t));
PB1000 = abs(fft(pb));
PNB1000 = abs(fft(pnb));

plot(t,pnb,'-',t,pb,'--','linewidth',2,'Color',ax.ColorOrder(2,:))
ylabel('voltage (mV)')

axis([78,90,min(pnb),max(pnb)]);
xticks('');
yticks([100])
makeFigureBig(h,fSize,fSize)
% set(h,'position',[488.0000  581.8000  381.0000  180.2000]);

% 2.25 MHz
sp3 = subplot(413);
t = FragData(fragIdx).Attenuation.kHz2250.RawData.t*1e6;
pb = FragData(fragIdx).Attenuation.kHz2250.RawData.pb{1}*1e3;
pnb = FragData(fragIdx).Attenuation.kHz2250.RawData.pnb{1}*1e3;

pb = pb-mean(pb);
pnb = pnb-mean(pnb);

dt = t(2)-t(1);
f2250 = fftX(dt,length(t));
PB2250 = abs(fft(pb));
PNB2250 = abs(fft(pnb));

plot(t-58,pnb,'-',t-58,pb,'--','linewidth',2,'Color',ax.ColorOrder(3,:))

xlabel('time (\mus)')
axis([0,12,min(pnb),max(pnb)]);
yticks([400])
makeFigureBig(h,fSize,fSize)

% set(h,'position',[871.4000  545.8000  380.8000  216.0000]);

sp4 = subplot(414);
hold on;
ax = gca;
plot(f500,10*log10(PNB500/max(PNB500)),'-',f500,10*log10(PB500/max(PNB500)),'--','linewidth',2,'Color',ax.ColorOrder(1,:))
plot(f1000,10*log10(PNB1000/max(PNB1000)),'-',f1000,10*log10(PB1000/max(PNB1000)),'--','linewidth',2,'Color',ax.ColorOrder(2,:))
plot(f2250,10*log10(PNB2250/max(PNB2250)),'-',f2250,10*log10(PB2250/max(PNB2250)),'--','linewidth',2,'Color',ax.ColorOrder(3,:))
axis([0,4,-30,0])

plt = plot(-1,-1,'-','Color',ax.ColorOrder(1,:),'linewidth',2);
plt(2) = plot(-1,-1,'-','Color',ax.ColorOrder(2,:),'linewidth',2);
plt(3) = plot(-1,-1,'-','Color',ax.ColorOrder(3,:),'linewidth',2);
plt(4) = plot(-1,-1,'-','Color',[0,0,0],'linewidth',2);
plt(5) = plot(-1,-1,'--','Color',[0,0,0],'linewidth',2);

xlabel('Frequency (MHz)')
ylabel('dB')
if plotLgd
    lgd = legend(plt,{'0.5 MHz','1 MHz','2.25 MHz','No Frag', 'Frag'});
    set(lgd,'position',[    0.6885    0.1719    0.2939    0.3480]);
end
makeFigureBig(h,fSize,fSize)
set(sp4,'position',[ 0.1619    0.7    0.7431    0.28])
set(sp1,'position',[ 0.1619    0.4    0.7431    0.1])
set(sp2,'position',[ 0.1619    0.3    0.7431    0.1])
set(sp3,'position',[ 0.1619    0.2    0.7431    0.1])
set(h,'position',[522  200  560.0000  500]);
if exist('imgPath','var')
    print([imgPath, 'figs/raw_',num2str(fragIdx)], '-depsc')
end

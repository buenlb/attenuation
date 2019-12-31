clear; close all; clc;
thickness = 2.77;
freq = 0.5;
w = 2*pi*freq;

hu = linspace(500,1500,100);

c = 1.2*hu+1080;
rho = hu+1000;

attenuation = [0,0.1,1,10];

h = figure(1);
clf;
hold on;
for ii = 1:length(attenuation)
    clear gamma
    for jj = 1:length(c)
        gamma(jj) = estimateGamma3Layer(c(jj),rho(jj),thickness,freq,attenuation(ii));
        gammaSemiInfinite(jj) = estimateGamma(c(jj),rho(jj));
    end
    figure(h)
    plot(c,abs(gamma));
    legString{ii} = ['\alpha = ',num2str(attenuation(ii))];
end
plot(c,gammaSemiInfinite,'--');
legString{end+1} = 'Semi-Infinite';
legend(legString);

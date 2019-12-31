thickness = 2.77;
freq = 0.5;
w = 2*pi*freq;

hu = linspace(500,1500,100);

c = 1.2*hu+1080;
rho = hu+1000;

for ii = 1:length(c)
    [gamma(ii),T(ii)] = estimateGamma3Layer(c(ii),rho(ii),thickness,freq);
end

figure
plot(c,abs(gamma))

%% Compare to semi-infinite Case
gamma_si = (c.*rho-1500*1e3)./(c.*rho+1500*1e3);
T_si = (1-gamma_si).*(1+gamma_si);

figure
plot(c,abs(T),c,T_si)
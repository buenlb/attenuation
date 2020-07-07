clear p x y z
%% Using 2nd order polynomial fits, this code plots where the min occurs in order to give a sense of where saturation occurs
[~,~,~,fragsIdx500Layers,fragsIdx1000Layers,fragsIdx2250Layers] = screenFragments(FragData);

n500 = length(fragsIdx500Layers);
n1000 = length(fragsIdx1000Layers);
n2250 = length(fragsIdx2250Layers);

nf500 = length(f500);
nf1000 = length(f1000);
nf2250 = length(f2250);

%% Fits @ 2250
x = hu(fragsIdx2250Layers);
for ii = 1:nf2250
    y = atten2250(fragsIdx2250Layers,ii);
    
    p(ii,:) = myPolyFit(x,y,'poly',2);
    
    vlly2250(ii) = -p(ii,2)/(2*p(ii,1));
end
vlly2250(vlly2250<0 | vlly2250>3e3) = nan;

%% Fits @ 1000
clear p x y z
x = hu(fragsIdx1000Layers);
for ii = 1:nf1000
    y = atten1000(fragsIdx1000Layers,ii);
    
    p(ii,:) = myPolyFit(x,y,'poly',2);
    
    vlly1000(ii) = -p(ii,2)/(2*p(ii,1));
end
vlly1000(vlly1000<0 | vlly1000>3e3) = nan;

%% Fits @ 500
clear p x y z
x = hu(fragsIdx500Layers);
for ii = 1:nf500
    y = atten500(fragsIdx500Layers,ii);
    
    p(ii,:) = myPolyFit(x,y,'poly',2);
    
    vlly500(ii) = -p(ii,2)/(2*p(ii,1));
end
vlly500(vlly500<0 | vlly500>3e3) = nan;

%% Plot Result
h = figure;
plot(f500,vlly500,f1000,vlly1000,f2250,vlly2250,'linewidth',2)
xlabel('Frequency (MHz)')
ylabel('Location of Min (HU)')
legend('0.5 MHz Tx', '1 MHz Tx', '2.25 MHz Tx','location','southeast')
axis([0,3,1e3,3e3])
grid on
makeFigureBig(h)

clear p x y z
%% Using 3rd order polynomial fits, this code plots where the min occurs in order to give a sense of where saturation occurs
%% Fits @ 2250
x = hu(fragsIdx2250Layers);
for ii = 1:nf2250
    y = atten2250(fragsIdx2250Layers,ii);
    
    p(ii,:) = myPolyFit(x,y,'poly',3);
    
    vlly2250(ii) = -p(ii,2)/(2*p(ii,1));
end
vlly2250(vlly2250<0 | vlly2250>3e3) = nan;

%% Fits @ 1000
clear p x y z
x = hu(fragsIdx1000Layers);
for ii = 1:nf1000
    y = atten1000(fragsIdx1000Layers,ii);
    
    p(ii,:) = myPolyFit(x,y,'poly',2);
    
    vlly1000(ii) = -p(ii,2)/(2*p(ii,1));
end
vlly1000(vlly1000<0 | vlly1000>3e3) = nan;

%% Fits @ 500
clear p x y z
x = hu(fragsIdx500Layers);
for ii = 1:nf500
    y = atten500(fragsIdx500Layers,ii);
    
    p(ii,:) = myPolyFit(x,y,'poly',2);
    
    vlly500(ii) = -p(ii,2)/(2*p(ii,1));
end
vlly500(vlly500<0 | vlly500>3e3) = nan;

%% Plot Result
h = figure;
plot(f500,vlly500,f1000,vlly1000,f2250,vlly2250,'linewidth',2)
xlabel('Frequency (MHz)')
ylabel('Location of Min (HU)')
legend('0.5 MHz Tx', '1 MHz Tx', '2.25 MHz Tx','location','southeast')
axis([0,3,1e3,3e3])
grid on
makeFigureBig(h)
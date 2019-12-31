function strelitzki = strelitzki1997(createFigFlag)
% Strelitzki 1997
% BUA (db/MHz/cm)

% % 0.6mm pore size
% 46.49001, 37.49160
% 55.27907, 36.66499
% 59.99318, 37.47213
% 69.19058, 30.42104
% 79.20741, 13.92094

% % 1.3mm pore size
% 46.78689, 48.76772
% 51.98194, 53.12775
% 60.89500, 48.57823
% 72.28130, 32.12609
% 82.40055, 23.18098


% 0.6mm pore size
porosity = [46.49001, 55.27907, 59.99318, 69.19058, 79.20741];
BUA = [37.49160, 36.66499, 37.47213, 30.42104, 13.92094];       % dB/MHz/cm

%%
strelitzki = v2struct(porosity, BUA);

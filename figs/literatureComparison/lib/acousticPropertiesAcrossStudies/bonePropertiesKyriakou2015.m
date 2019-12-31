function kyriakou = bonePropertiesKyriakou2015(createFigFlag)
% Kyriakou 2015
% center frequency at 0.23 MHz

kyriakou.hu = (0:10:2500)';

kyriakou.c = 3183 * ones(size(kyriakou.hu));
kyriakou.rho = 1908 * ones(size(kyriakou.hu));      % IT'IS density for cortical bone

% attenuation at 0.68 MHz
freq = 0.68e6;
kyriakou.atten = (164/100) * (freq/1e6) * ones(size(kyriakou.hu));   % Np/cm

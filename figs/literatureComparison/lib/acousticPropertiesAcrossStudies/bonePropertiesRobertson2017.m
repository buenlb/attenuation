function robertson = bonePropertiesRobertson2017(createFigFlag)
% Robertson 2017

c = 2850;
rho = 1732;

freq = 0.68e6;
y = 1.43;
atten = (8.83/8.686) * (freq/1e6).^y;   % Np/cm

robertson.hu = (0:10:2500)';
robertson.atten = ones(size(robertson.hu)) * atten;
robertson.c = ones(size(robertson.hu)) * c;
robertson.rho = ones(size(robertson.hu)) * rho;

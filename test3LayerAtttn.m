% Test 3 layer attenuation estimates
clear; close all; clc;
runAttenuation;

%%
idx = find(d>4.4e-3);
for ii = 1:length(f500)
    f = f500(ii);
    c = mean(FragData(idx(1)).Velocity.measuredVelocity);
    rho = FragData(idx(1)).density;
    d = FragData(idx(1)).thickness*1e3;
    [~,T(ii)] = estimateGamma3Layer(c,rho,d,f);
    [~,Ta(ii)] = estimateGamma3Layer(c,rho,d,f,atten500(idx(1),ii));
end

figure
plot(f500,il500_all(idx(1),:),f500,abs(T),f500,atten500(idx(1),:))
hold on
plot(f500,abs(Ta),'*')
legend('Measured Insertion Loss', 'Predicted Insertion Loss (No Attn)','Measured Attenuation')
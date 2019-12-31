%% Find average values at all frequencies for the three bone types.
[~,~,~,fragsIdx500Layers,fragsIdx1000Layers,fragsIdx2250Layers,~,~,it,ot,md] = screenFragments(FragData);

it500 = intersect(fragsIdx500Layers,it);
ot500 = intersect(fragsIdx500Layers,ot);
md500 = intersect(fragsIdx500Layers,md);

it500 = atten500(it500,centerIdx500);
ot500 = atten500(ot500,centerIdx500);
md500 = atten500(md500,centerIdx500);

it1000 = intersect(fragsIdx1000Layers,it);
ot1000 = intersect(fragsIdx1000Layers,ot);
md1000 = intersect(fragsIdx1000Layers,md);

it1000 = atten1000(it1000,centerIdx1000);
ot1000 = atten1000(ot1000,centerIdx1000);
md1000 = atten1000(md1000,centerIdx1000);

it2250 = intersect(fragsIdx2250Layers,it);
ot2250 = intersect(fragsIdx2250Layers,ot);
md2250 = intersect(fragsIdx2250Layers,md);

it2250 = atten2250(it2250,centerIdx2250);
ot2250 = atten2250(ot2250,centerIdx2250);
md2250 = atten2250(md2250,centerIdx2250);

disp('Average Attenuation Results')
disp('  500 kHz')
disp(['    IT: ', num2str(mean(it500),2), ' +/- ', num2str(std(it500),2)])
disp(['    MD: ', num2str(mean(md500),2), ' +/- ', num2str(std(md500),2)])
disp(['    OT: ', num2str(mean(ot500),2), ' +/- ', num2str(std(ot500),2)])
disp('  1000 kHz')
disp(['    IT: ', num2str(mean(it1000),2), ' +/- ', num2str(std(it1000),2)])
disp(['    MD: ', num2str(mean(md1000),2), ' +/- ', num2str(std(md1000),2)])
disp(['    OT: ', num2str(mean(ot1000),2), ' +/- ', num2str(std(ot1000),2)])
disp('  2250 kHz')
disp(['    IT: ', num2str(mean(it2250),2), ' +/- ', num2str(std(it2250),2)])
disp(['    MD: ', num2str(mean(md2250),2), ' +/- ', num2str(std(md2250),2)])
disp(['    OT: ', num2str(mean(ot2250),2), ' +/- ', num2str(std(ot2250),2)])
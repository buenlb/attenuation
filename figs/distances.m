%% Measures distances between transducer and fragment and transducer and hydrophone.
% 500
thresh = 10e-3;
pnb = FragData(1).Attenuation.kHz500.RawData.pnb{1};
t = FragData(1).Attenuation.kHz500.RawData.t;
pnb = pnb-mean(pnb);

idx = find(abs(pnb)>thresh);
aTime = t(idx(1));
distance500 = aTime*1492;

refThresh = 3e-3;
ref = load('E:\Experiments\Attenuation\20181018\Fragments05MHzPlanar_10mm_1\1_9M\atten_1Measurements_000');
pnbr = ref.r_pnb1;
rt = ref.r_t1;
pnbr = pnbr-mean(pnbr);

idx = find(abs(pnbr)>refThresh);
aTime = t(idx(1));
distance500Ref = aTime*1492/2;

% 1000
thresh = 10e-3;
pnb = FragData(1).Attenuation.kHz1000.RawData.pnb{1};
t = FragData(1).Attenuation.kHz1000.RawData.t;
pnb = pnb-mean(pnb);

idx = find(abs(pnb)>thresh);
aTime = t(idx(1));
distance1000 = aTime*1492;

refThresh = 3e-3;
ref = load('E:\Experiments\Attenuation\20181016\Fragments1MHzPlanar_1\1_1I\atten_1Measurements_000');
pnbr = ref.r_pnb1;
rt = ref.r_t1;
pnbr = pnbr-mean(pnbr);

idx = find(abs(pnbr)>refThresh);
aTime = t(idx(1));
distance1000Ref = aTime*1492/2;

% 2250
thresh = 10e-3;
pnb = FragData(1).Attenuation.kHz2250.RawData.pnb{1};
t = FragData(1).Attenuation.kHz2250.RawData.t;
pnb = pnb-mean(pnb);

idx = find(abs(pnb)>thresh);
aTime = t(idx(1));
distance2250 = aTime*1492;

refThresh = 3e-3;
ref = load('E:\Experiments\Attenuation\20181017\Fragments225MHzPlanar_1\1_1I\atten_1Measurements_000');
pnbr = ref.r_pnb1;
rt = ref.r_t1;
pnbr = pnbr-mean(pnbr);

idx = find(abs(pnbr)>refThresh);
aTime = t(idx(1));
distance2250Ref = aTime*1492/2;

disp('Distances:')
disp(['  Tx To Hydrophone: 500 kHz: ', num2str(distance500*1e3,2), '  1000 kHz: ', num2str(distance1000*1e3,2),'  2250 kHz: ', num2str(distance2250*1e3,2)]);
disp(['  To Aluminum: 500 kHz: ', num2str(distance500Ref*1e3,2), '  1000 kHz: ', num2str(distance1000Ref*1e3,2),'  2250 kHz: ', num2str(distance2250Ref*1e3,2)]);
disp(['  Aluminum to Hydrophone: 500 kHz: ', num2str(distance500*1e3-distance500Ref*1e3,2), '  1000 kHz: ', num2str(distance1000*1e3-distance1000Ref*1e3,2),'  2250 kHz: ', num2str(distance2250*1e3-distance2250Ref*1e3,2)]);
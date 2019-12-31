function clarke = clarke1994(createFigFlag)
% Clarke 1994
% BUA (db/MHz/cm)
% buaSlope (db/MHz/cm)
% buaIntercept (db/cm)

% 0.875 MHz
% 9.825000000000003, 11.493440082644554
% 21.89999999999999, 19.186518595041242
% 32.13749999999999, 25.225619834710756
% 40.27500000000001, 29.52794421487603
% 47.187499999999986, 34.945247933884296
% 61.099999999999994, 25.94519628099174
% 67.04999999999998, 20.494163223140497
% 76.58749999999996, 13.84690082644629

% 0.75 MHz
% 9.737500000000004, 9.138016528925622
% 21.89999999999999, 16.624535123966947
% 32.137499999999996, 20.59752066115703
% 40.27499999999998, 26.34612603305785
% 47.27499999999999, 26.680836776859508
% 61.09999999999998, 20.11875000000001
% 67.13749999999997, 17.436363636363648
% 76.67499999999997, 11.739514462809915

% 0.625 MHz
% 9.825000000000003, 7.774431818181817
% 21.8125, 14.021177685950423
% 32.1375, 17.250413223140495
% 40.275, 19.9411673553719
% 47.187500000000014, 22.217975206611577
% 61.09999999999998, 15.408006198347113
% 67.1375, 14.00661157024794
% 76.58749999999999, 9.549380165289257

% 0.5 MHz
% 9.825000000000003, 6.162861570247941
% 21.900000000000013, 11.169989669421486
% 32.225000000000044, 14.233935950413226
% 40.187500000000014, 15.147727272727273
% 47.18749999999996, 17.507231404958677
% 61.10000000000001, 11.56503099173553
% 67.04999999999995, 11.444576446281001
% 76.67499999999998, 6.987448347107446


% frequency (MHz)
frequencies = [0.5, 0.625, 0.75, 0.875];

% porosity (%)
porosities(:,1) = [9.825000000000003, 21.900000000000013, 32.225000000000044, 40.187500000000014, 47.18749999999996, 61.10000000000001, 67.04999999999995, 76.67499999999998];
porosities(:,2) = [9.825000000000003, 21.8125, 32.1375, 40.275, 47.187500000000014, 61.09999999999998, 67.1375, 76.58749999999999];
porosities(:,3) = [9.737500000000004, 21.89999999999999, 32.137499999999996, 40.27499999999998, 47.27499999999999, 61.09999999999998, 67.13749999999997, 76.67499999999997];
porosities(:,4) = [9.825000000000003, 21.89999999999999, 32.13749999999999, 40.27500000000001, 47.187499999999986, 61.099999999999994, 67.04999999999998, 76.58749999999996];
porosity = mean(porosities,2);      

% attenuation (dB/cm)
attenuation = zeros(8,4);
attenuation(:,1) = [6.162861570247941, 11.169989669421486, 14.233935950413226, 15.147727272727273, 17.507231404958677, 11.56503099173553, 11.444576446281001, 6.987448347107446];
attenuation(:,2) = [7.774431818181817, 14.021177685950423, 17.250413223140495, 19.9411673553719, 22.217975206611577, 15.408006198347113, 14.00661157024794, 9.549380165289257];
attenuation(:,3) = [9.138016528925622, 16.624535123966947, 20.59752066115703, 26.34612603305785, 26.680836776859508, 20.11875000000001, 17.436363636363648, 11.739514462809915];
attenuation(:,4) = [11.493440082644554, 19.186518595041242, 25.225619834710756, 29.52794421487603, 34.945247933884296, 25.94519628099174, 20.494163223140497, 13.84690082644629];


[buaSlope, buaIntercept] = deal(zeros(8,1));
for i = 1:8
    p = polyfit(frequencies, attenuation(i,:), 1);
    buaSlope(i) = p(1);
    buaIntercept(i) = p(2);
end

% BUA (dB/MHz/cm)
BUA = buaSlope + buaIntercept;

if createFigFlag
    figure; plot(porosity, attenuation, 'x-');
    hold on;
    plot(porosity, BUA, 'o-');
    xlim([0 100]);
    ylim([0 50]);
    grid on;
    legend('0.5 MHz', '0.625 MHz', '0.75 MHz', '0.875 MHz', 'BUA');
    xlabel('Porosity (%)');
    ylabel('Attenuation (dB/cm)');
    title('Clarke 1994');
end


% BUA = buaSlope + buaIntercept;
% p = polyfit(porosity, BUA, 2);

% figure; hold on;
% plot(porosity, buaSlope+buaIntercept, 'o-');
% plot(0:100, polyval(p, 0:100));
% xlim([0 100]);
% ylim([0 50]);

%%
clarke = v2struct(frequencies, porosity, attenuation, buaSlope, buaIntercept, BUA);

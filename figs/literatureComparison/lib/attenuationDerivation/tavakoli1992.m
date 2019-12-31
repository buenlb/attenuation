function tavakoli = tavakoli1992(createFigFlag)
% Tavakoli 1992
% BUA (db/MHz/cm)
% buaSlope (db/MHz/cm)
% buaIntercept (db/cm)

%% Data for 1.2 cm thick sample
% frequency
frequencies = [0.4, 0.6, 0.8];

% porosity (%)
porosity = [40.6, 38, 35.2, 32.1, 28.7, 25, 20.1, 16.1, 11 5];

% attenuation (dB)
attenuation = zeros(10,3);
attenuation(:,1) = [12.5, 11.2, 10.5, 8.9, 6.6, 4.2, 3.6, 3.3, 3, 2.5];         % at 0.4 MHz
attenuation(:,2) = [18.9, 16.7, 15.2, 12.4, 9.8, 7.3, 6.5, 5.9, 5.2, 4.9];      % at 0.6 MHz
attenuation(:,3) = [26.8, 24.3, 22.1, 20.1, 15.2, 12.4, 11.2, 10.5, 9.8, 8];    % at 0.8 MHz

% attenuation (dB/cm)
attenuation = attenuation/1.2;


%% calculate BUA (broadband ultrasound attenuation)
[buaSlope, buaIntercept] = deal(zeros(8,1));
for i = 1:10
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
    legend('0.4 MHz', '0.6 MHz', '0.8 MHz', 'BUA');
    xlabel('Porosity (%)');
    ylabel('Attenuation (dB/cm)');
    title('Tavakoli 1992');
end


%% collect all variables into the tavakoli struct
tavakoli = v2struct(frequencies, porosity, attenuation, buaSlope, buaIntercept, BUA);

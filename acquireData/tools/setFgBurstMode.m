% setFgBurstMode(fg, frequency, amplitude, period, nCycles) sets the 
% function generator to burst mode with the specified parameters.

function setFgBurstMode(fg, frequency, amplitude, period, nCycles)
%% Sinusoid properties
% Make sure amplitude is reasonable
if amplitude > 900e-3
    error('Amplitude is too high for amplifier!')
end

% Set frequency and amplitude
command = [':APPLy:SINusoid ', num2str(frequency), ', ' num2str(amplitude)];
fprintf(fg,command);

%% Burst Properties
% Set up the mode
fprintf(fg,':BURS:MODE TRIG');

% Number of cycles
command = [':BURS:NCYC ', num2str(nCycles)];
fprintf(fg,command);

command = [':BURS:INT:PER ', num2str(period)];
fprintf(fg,command);

% Make sure phase is zero, set to internal triggering, enable burst mode,
% and turn on the output trigger
fprintf(fg,':OUTP:TRIG:SLOP POS');
fprintf(fg,':OUTP:TRIG ON');
fprintf(fg,':BURS:PHAS 0');
fprintf(fg,':TRIG:SOUR IMM');
fprintf(fg,':BURS:STAT ON');
% Takes in two waveforms (one measured with and one measured without a bone
% fragment present) and measures the insertion loss using as the ration of
% fourier transform coeficients. The result vector is limited to positive 
% frequencies and to those frequencies for which the Fourier coefficient 
% is greater than or equal to 20 dB down from the maximum coefficient.
% 
% @INPUTS
%   pb: acoustic waveform measured with the bone present
%   pnb: acoustic wavefore measured without the bone present (no bone)
%   dt: Sampling period for accurate estimation of frequency components
% 
% @OUTPUTS
%   il: vector of measured insertion loss
%   f: frequencies at which insertion loss is measured in MHz
% 
% Taylor Webb
% Stanford University
% Summer 2019

function [il,f] = insertionLoss(pb,pnb,dt)

f = fftX(dt,length(pb))-1/(2*dt);

PB = abs(fftshift(fft(pb)));
PNB = abs(fftshift(fft(pnb)));

il = PB./PNB;

idx20dB = find(20*log10(PNB/max(PNB))>-10);
idx20dB = idx20dB(idx20dB>floor(length(PNB)/2));

il = il(idx20dB);
f = f(idx20dB)/1e6;

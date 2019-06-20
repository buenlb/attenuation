% fftX returns the frequency axis for a fft with sampling period dt and
% nfft samples.
% 
% @INPUTS
%   dt: sampling period
%   nfft: length of signal
% 
% @OUTPUTS
%   f: frequency axis in Hz.

function f = fftX(dt,nfft)

fs = 1/dt;

f = 0:fs/nfft:(fs-fs/nfft);
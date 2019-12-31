% Digitizes a waveform from tektronix TDS 2002B
% 
% @INPUTS
%   scope: visa object that is opened and pointing to the scope
%   channel: channel to acquire data from
% 
% @OUTPUTS
%   wv: waveform
%   t: time at which samples were acquired
% 
% Taylor Webb
% Summer 2019

function [wv,t] = digitizeWaveform(scope,channel)

groupObj = get(scope, 'Waveform');
if channel == 1
    [wv,t] = invoke(groupObj, 'readwaveform', 'channel1');  
elseif channel == 2
    [wv,t] = invoke(groupObj, 'readwaveform', 'channel2');  
else
    error('Unrecognized Channel, the scope only has 2!')
end
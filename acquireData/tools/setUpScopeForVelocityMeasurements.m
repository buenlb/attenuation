% setUpScopeForVelocityMeasurements(scope, delay, averages, yRange, tRange)
% sets up the 3000 X scope to trigger on a rising edge trigger with an
% O-scope delay of delay, averaging averages times. The y-axis divisions
% are set to yRange and the time divisions are set to tRange.
% 
% @INPUTS
%   scope: Visa Object that is open
%   delay: O-scope delay in seconds
%   averages: Number of waveform averages to acquire
%   yRange: desired number of volts/division along y-axis
%   tRange: desired number of seconds/division along time axis
% 
% Taylor Webb
% Stanford University
% tdwebb@stanford.edu

function setUpScopeForVelocityMeasurements(scope, delay, averages, yRange, tRange)

set(scope.Trigger(1), 'TriggerType', 'edge');
set(scope.Trigger(1), 'Mode', 'normal');
set(scope.Trigger(1), 'Coupling', 'ac');
set(scope.Measurement(1), 'Source', 'channel1');
set(scope.Acquisition(1), 'Mode', 'average');
set(scope.Acquisition(1), 'NumberOfAverages', averages);
set(scope.Acquisition(1), 'Delay', delay);
set(scope.Acquisition(1), 'Timebase', tRange);
set(scope.Channel(1), 'Scale', yRange);
set(scope.Trigger(1), 'Source', 'external');
%% Instrument Connection

% Create a VISA-USB object.
interfaceObj = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0699::0x0364::C057567::0::INSTR', 'Tag', '');

% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(interfaceObj)
    interfaceObj = visa('TEK', 'USB0::0x0699::0x0364::C057567::0::INSTR');
else
    fclose(interfaceObj);
    interfaceObj = interfaceObj(1);
end

% Create a device object. 
deviceObj = icdevice('tektronix_tds2002.mdd', interfaceObj);

% Connect device object to hardware.
connect(deviceObj);

%% Instrument Configuration and Control

% Configure property value(s).
set(deviceObj.Trigger(1), 'TriggerType', 'edge');
set(deviceObj.Trigger(1), 'Mode', 'normal');
set(deviceObj.Trigger(1), 'Coupling', 'ac');
set(deviceObj.Measurement(1), 'Source', 'channel1');
set(deviceObj.Acquisition(1), 'NumberOfAverages', 16.0);
set(deviceObj.Acquisition(1), 'Delay', 0);
set(deviceObj.Acquisition(1), 'Timebase', 1.0E-6);
set(deviceObj.Channel(1), 'Scale', 100e-3);
set(deviceObj.Trigger(1), 'Source', 'external');


groupObj = get(deviceObj, 'Waveform');
[wv,t] = invoke(groupObj, 'readwaveform', 'channel1');

figure
plot(t,wv)
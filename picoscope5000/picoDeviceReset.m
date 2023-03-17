function picoDeviceReset(obj)
% PICODEVICERESET Reset device to standard parameters.
%
% picoDeviceReset(obj)
%
% Copyright: © 2023 Pico Technology. Modified by <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

arguments
    obj icdevice
end

% Reset Channels
invoke(obj, 'setChannelDefaults');

% Digital ports
digitalGroupObj = picoGetChildObject(obj,'Digital');

% Set digital port defaults if device has digital channels
if (obj.DriverData.digitalPortCount > 0)
        invoke(digitalGroupObj, 'setDigitalPortDefaults');
end

% Obtain block group object
blockGroupObj = picoGetChildObject(obj,'Block');

% Turn off ETS
invoke(blockGroupObj, 'ps5000aSetEts', obj.DriverData.enums.enPS5000AEtsMode.PS5000A_ETS_OFF, 0, 0);

% Turn off trigger
triggerGroupObj = picoGetChildObject(obj,'Trigger');

obj.DriverData.autoTriggerMs = 0;
obj.DriverData.autoTriggerUs = 0;
obj.DriverData.delay = 0;

invoke(triggerGroupObj, 'setTriggerOff');

% Set the default number of pre-trigger and post-trigger samples
obj.DriverData.numPreTriggerSamples = 0;
obj.DriverData.numPostTriggerSamples = 10000;

% Timebase
obj.DriverData.timebase = 65;
obj.DriverData.streamingInterval = 1e-6; % 1us -> 1MS/s
obj.DriverData.autoStop = PicoConstants.TRUE;

if (obj.DriverData.sigGenType == PicoConstants.SIG_GEN_FUNCT_GEN || ...
        obj.DriverData.sigGenType == PicoConstants.SIG_GEN_AWG)

    obj.DriverData.startFrequency = 1000;
    obj.DriverData.stopFrequency = 1000;
    obj.DriverData.offsetVoltage = 0;
    obj.DriverData.peakToPeakVoltage = 2000;

end

obj.DriverData.displayOutput = 1; 
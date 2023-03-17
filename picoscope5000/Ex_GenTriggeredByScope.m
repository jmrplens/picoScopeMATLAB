% This example shows how to perform a measurement by transmitting and
% receiving at the same time from the PicoScope.
% The signal is emitted at the instant the oscilloscope starts capturing. 
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

clc, close all;

% Initialization
PS5000aConfig;

% Connect to device
printInfo = 0;
obj = picoDeviceConnect(printInfo);

% Set function generator
waveType        = 0; % Sine
frequency       = 0.5e6; % Hz
VppMv           = 2000; % +- 2V
VoffsetMv       = 0;
shots           = 20; % 10 cycles. Set to 0 for continuous mode.
triggerType     = 0; % Doesnt matter because triggerSource is Scope
triggerSource   = 1; % When the capture starts, the signal is triggered
picoSetGenDefault(obj, waveType, frequency, VppMv, VoffsetMv, shots, triggerType, triggerSource);

% Set Channel
ch_properties.channels  = 0; % Channel A
ch_properties.coupling  = "DC";
ch_properties.range     = 2000; % Scope range +- 2V
ch_properties.offset    = 0;
picoSetChannel(obj,ch_properties)

% Resolution (bits)
resolution = 15;
picoSetResolution(obj,resolution);

% Set samplerate. If the sample rate value is not possible, the closest option is sought.
sampleRateDesired = 125e6; % Hz
[~,~,sampleRateFinal] = picoGetTimeBaseIndex(obj,sampleRateDesired);

% Set block scope
msrtime = 0.05e-3; % Measure time
pretime = 0; % Time stored before scope triggered 
picoCaptureBlockSettings(obj,msrtime,pretime,sampleRateFinal);

% Get Data
[data,time] = picoCaptureBlock(obj,ch_properties.channels,sampleRateFinal);

% Disconnect device
picoDeviceDisconnect(obj)

% Plot
figure1 = figure('Name','PicoScope 5000 Series Example - Block Mode Gen and Capture', ...
    'NumberTitle','off');

plot(time*1e3, data, 'b');
title('Channel A');
xlabel('Time (ms)');
ylabel('Voltage (mV)');
grid('on');

% This example shows how to send a trigger signal to an external generator
% and capture through the input channels.
% The signal is emitted at the instant the oscilloscope starts capturing. 
%
% Remember: If only the USB is connected, data will only be obtained from
% channels A and B, the power supply must be connected to be able to use
% channels C and D.
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

% Initialization
PS5000aConfig;

% Connect to device
printInfo = 0;
obj = picoDeviceConnect(printInfo);

% Set function generator
waveType        = 11; % TTL 2V
frequency       = 0.5e6; % Hz (ignored)
VppMv           = 2000; % +- 2V (ignored)
VoffsetMv       = 0; % (ignored)
shots           = 20; % 10 cycles. Set to 0 for continuous mode. (ignored)
triggerType     = 0; % Doesnt matter because triggerSource is Scope
triggerSource   = 1; % When the capture starts, the signal is triggered
picoSetGenDefault(obj, waveType, frequency, VppMv, VoffsetMv, shots, triggerType, triggerSource);

% Set Channel
ch_properties.channels  = [0,1,2]; % Channel A, B and C
ch_properties.coupling  = ["DC","DC","DC"];
ch_properties.range     = [2000,2000,2000]; % Scope range +- 2V
ch_properties.offset    = [0,0,0];
picoSetChannel(obj,ch_properties)

% Resolution (bits)
resolution = 12;
picoSetResolution(obj,resolution);

% Set samplerate. If the sample rate value is not possible, the closest option is sought.
sampleRateDesired = 125e6; % Hz
[~,~,sampleRateFinal] = picoGetTimeBaseIndex(obj,sampleRateDesired);

% Set block scope
msrtime = 1.5e-3; % Measure time
pretime = 0; % Time stored before scope triggered 
picoCaptureBlockSettings(obj,msrtime,pretime,sampleRateFinal);

% Get Data
[data,time] = picoCaptureBlock(obj,ch_properties.channels,sampleRateFinal);

% Disconnect device
picoDeviceDisconnect(obj)

% Plot
figure1 = figure('Name','PicoScope 5000 Series Example - Block Mode Gen and Capture', ...
    'NumberTitle','off');

nexttile
plot(time*1e3, data(:,1), 'b');
title('Channel A');
xlabel('Time (ms)');
ylabel('Voltage (mV)');
grid('on');

nexttile
plot(time*1e3, data(:,2), 'b');
title('Channel B');
xlabel('Time (ms)');
ylabel('Voltage (mV)');
grid('on');

nexttile
plot(time*1e3, data(:,3), 'b');
title('Channel C');
xlabel('Time (ms)');
ylabel('Voltage (mV)');
grid('on');
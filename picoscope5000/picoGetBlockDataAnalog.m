function [data,time] = picoGetBlockDataAnalog(obj,channels,sampleInterval,downSamplingRatio)
% PICOGETBLOCKDATAANALOG Retrieves the data captured in the block.
%
% [data,time] = picoGetBlockDataAnalog(obj,channels,sampleInterval,downSamplingRatio)
%
% Input:
%                 obj - PicoScope Object (icdevice).
%            channels - Channel(s) to read (0, 1, 2 or 3).
%      sampleInterval - Sample interval in seconds (1/samplerate).
%   downSamplingRatio - Downsample ratio.
%
% Output:
%   data - Captured signal in Volts. One column array for each channel.
%          If more than one channel, it has the same order as the channel 
%          array entered.
%   time - Time array in seconds.
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%
% See also PICOCAPTUREBLOCK, PICOCAPTUREBLOCKAVERAGES,
% PICOCAPTUREBLOCKSETTINGS, PICORUNBLOCK.

arguments
    obj                 icdevice
    channels            (1,:) {mustBeMember(channels,0:3)} = 0
    sampleInterval      (1,1) {mustBePositive} = 8e-9
    downSamplingRatio   (1,1) {mustBeInteger,mustBePositive} = 1
end

blockObj = picoGetChildObject(obj,'Block');

% Get block data
ratioMode = picoGetDownSamplingRatioMode(downSamplingRatio,'decimate');
[numSamples, ~, chA, chB,chC,chD] = ...
    invoke(blockObj, 'getBlockData', 0, 0, downSamplingRatio, ratioMode);

% Get enabled channels
nEnabledChannel = numel(channels);
% Find current power source
currentPowerSource = invoke(obj, 'ps5000aCurrentPowerSource');

% Get data array in same order of 'ch_properties.channels'
data = zeros(numSamples,nEnabledChannel);
for i = 1:nEnabledChannel
    switch true
        case channels(i) == 0
            data(:,i) = chA;
        case channels(i) == 1
            data(:,i) = chB;
        case channels(i) == 2 && currentPowerSource == PicoStatus.PICO_POWER_SUPPLY_CONNECTED
            data(:,i) = chC;
        case channels(i) == 3 && currentPowerSource == PicoStatus.PICO_POWER_SUPPLY_CONNECTED
            data(:,i) = chD;
    end
end

% Time array (in seconds)
time = double(sampleInterval) * downSamplingRatio * double(0:numSamples - 1);


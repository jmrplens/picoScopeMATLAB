function [data,time] = picoCaptureBlock(obj,channels,sampleRate,downSamplingRatio)
% PICOCAPTUREBLOCK Starts the capture and returns the captured data.
%
% [data,time] = picoCaptureBlock(obj,channels,sampleRate,downSamplingRatio)
%
% Input:
%                 obj - PicoScope Object (icdevice).
%            channels - Channel(s) to read (0, 1, 2 or 3).
%          sampleRate - Samplerate in Hertz.
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
% See also PICOCAPTUREBLOCKAVERAGES, PICOCAPTUREBLOCKSETTINGS,
% PICOGETBLOCKDATAANALOG, PICORUNBLOCK.

arguments
    obj                 icdevice
    channels            (1,:) {mustBeMember(channels,0:3)} = 0
    sampleRate          (1,1) {mustBeInteger,mustBePositive} = 50e6
    downSamplingRatio   (1,1) {mustBeInteger,mustBePositive} = 1
end

% MEASURE
picoRunBlock(obj);

% DATA
sampleInterval  = 1/sampleRate;
[data,time]     = picoGetBlockDataAnalog(obj,channels,sampleInterval,downSamplingRatio);

% STOP
picoDeviceStop(obj);


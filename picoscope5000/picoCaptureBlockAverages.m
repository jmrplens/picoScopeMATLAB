function [dataAvg,time] = picoCaptureBlockAverages(obj,iter,PRP,channels,sampleRate,downSamplingRatio)
% PICOCAPTUREBLOCKAVERAGES Perform several consecutive measurements
% separated by a time interval and obtain the average. By constraints, the
% object 'block' consumes approximately 50 milliseconds, so the shortest
% possible interval cannot be less than 50 milliseconds.
%
% [dataAvg,time] = picoCaptureBlockAverages(obj,iter,PRP,channels,sampleRate,downSamplingRatio)
%
%   Input:
%                 obj - PicoScope Object (icdevice).
%                iter - Number of repetitions.
%                 PRP - Time of separation between each measurement in seconds.
%            channels - Channel(s) to read (0, 1, 2 or 3).
%          sampleRate - Samplerate in Hertz.
%   downSamplingRatio - Downsample ratio.
%
% Output:
%   dataAvg - Average of captured signal in Volts. One column array for each
%             channel. If more than one channel, it has the same order as
%             the channel array entered.
%      time - Time array in seconds.
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%
% See also PICOCAPTUREBLOCK, PICOCAPTUREBLOCKSETTINGS,
% PICOGETBLOCKDATAANALOG, PICORUNBLOCK.

arguments
    obj                 icdevice
    iter                (1,1) {mustBePositive,mustBeInteger} = 10
    PRP                 (1,1) {mustBeNonnegative} = 100e-3
    channels            (1,:) {mustBeMember(channels,0:3)} = 0
    sampleRate          (1,1) {mustBeInteger,mustBePositive} = 50e6
    downSamplingRatio   (1,1) {mustBeInteger,mustBePositive} = 1
end

% First measure
[data,time] = picoCaptureBlock(obj,channels,sampleRate,downSamplingRatio);

dataAvg = data/iter;

for i = 2:iter

    % MEASURE
    picoRunBlock(obj);

    % Register time
    ini = tic;

    % DATA
    sampleInterval  = 1/sampleRate;
    [data,~]        = picoGetBlockDataAnalog(obj,channels,sampleInterval,downSamplingRatio);

    % STOP
    picoDeviceStop(obj);
   
    % Average
    dataAvg = dataAvg+(1/iter)*data;

    % Time consumed
    timeproc = toc(ini);

    % Pause if timeproc < PRP
    if PRP > timeproc; pause(PRP-timeproc); end

end
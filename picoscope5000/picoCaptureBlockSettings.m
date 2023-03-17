function sampleRate = picoCaptureBlockSettings(obj,msrtime,pretime,sampleRate)
% PICOCAPTUREBLOCKSETTINGS Configures the parameters of the capture block.
%
% sampleRate = picoCaptureBlockSettings(obj,msrtime,pretime,sampleRate)
%
% Input:
%          obj - PicoScope Object (icdevice).
%      msrtime - Capture time in seconds.
%      pretime - Capture time before trigger in seconds.
%   sampleRate - Desired samplerate in Hertz.
%
% Output:
%   sampleRate - Real samplerate in Hertz.
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%
% See also PICOCAPTUREBLOCK, PICOCAPTUREBLOCKAVERAGES,
% PICOGETBLOCKDATAANALOG, PICORUNBLOCK.

arguments
    obj             icdevice
    msrtime         (1,1) {mustBePositive} = 10e-3
    pretime         (1,1) {mustBeNonnegative} = 0
    sampleRate      (1,1) {mustBeInteger,mustBePositive} = 50e6
end

% SampleRate
[tIndex,timeIntervalNanoseconds,sampleRate] = picoGetTimeBaseIndex(obj,sampleRate);
set(obj, 'timebase', tIndex);

% Sample interval in seconds and real sample rate
sampleInterval = double(timeIntervalNanoseconds)*1e-9;

% Data buffers
minbuffer = ceil(msrtime / sampleInterval)+1;
prebuffer = ceil(pretime /sampleInterval);
set(obj, 'numPreTriggerSamples', prebuffer);
set(obj, 'numPostTriggerSamples', minbuffer);
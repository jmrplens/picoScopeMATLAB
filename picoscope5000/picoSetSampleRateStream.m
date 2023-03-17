function sampleInterval = picoSetSampleRateStream(obj,sampleRate)
% PICOSETSAMPLERATESTREAM Defines the sampling frequency of the stream object.
%
% sampleInterval = picoSetSampleRateStream(obj,sampleRate)
%
% Input:
%          obj - PicoScope Object (icdevice).
%   sampleRate - Desired sample rate in Hertz.
%
% Output:
%   sampleInterval - Sample interval in seconds.
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

arguments
    obj         icdevice
    sampleRate  (1,1) {mustBeInteger,mustBePositive} = 50e6
end

% Stream object
streamObj = picoGetChildObject(obj,'Streaming');

% Ex: Sample interval 1e-6 = 1MSample/s
sampleInterval = 1/sampleRate;
set(streamObj, 'streamingInterval', sampleInterval);
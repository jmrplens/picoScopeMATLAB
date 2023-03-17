function BufferLength = picoCalcBufferLength(msrtime,pretime,sampleInterval,downSamplingRatio)
% PICOCALCBUFFERLENGTH It calculates the number of samples that the
% captured signal will have according to the measurement duration and the
% sampling frequency.
%
% BufferLength = picoCalcBufferLength(msrtime,pretime,sampleInterval,downSampleRatio)
%
% Input:
%           msrtime - Capture time in seconds.
%           pretime - Capture time before trigger in seconds.
%    sampleInterval - Sample interval in seconds (1/samplerate).
%   downSamplingRatio - Downsample ratio.
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

arguments
    msrtime         (1,1) {mustBePositive} = 10e-3
    pretime         (1,1) {mustBeNonnegative} = 0
    sampleInterval  (1,1) {mustBePositive} = 8e-9
    downSamplingRatio (1,1) {mustBeInteger,mustBePositive} = 1
end

minbuffer = ceil(msrtime / sampleInterval);
prebuffer = ceil(pretime / sampleInterval);
maxSamples = minbuffer + prebuffer;

BufferLength = round(maxSamples / downSamplingRatio * 1.5);
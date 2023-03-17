function sampleInterval = picoRunStream(obj,overviewBufferSize,downSamplingRatio,ratioMode)
% PICORUNSTREAM Starts the stream capture.
%
% sampleInterval = picoRunStream(obj,overviewBufferSize,downSamplingRatio,ratioMode)
%
% Input:
%                 obj - PicoScope Object (icdevice).
%  overviewBufferSize - Buffer size.
%   downSamplingRatio - Downsampling ratio.
%           ratioMode - View <a href="matlab:open('picoGetDownSamplingRatioMode')">picoGetDownSamplingRatioMode</a>.
%
% Example:
% View <a href="matlab:open('Ex_LiveStreamCapture')">Ex_LiveStreamCapture</a>.
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%
% See also PICOGETDOWNSAMPLINGRATIOMODE, PICOCALCBUFFERLENGTH, PICOCONVERTTIMEUNITS.

arguments
    obj                 icdevice
    overviewBufferSize  (1,1) {mustBeInteger,mustBePositive}       
    downSamplingRatio   (1,1) {mustBeInteger,mustBePositive} = 1
    ratioMode           (1,1) {mustBeMember(ratioMode,0:4)} = 0
end

% Get stream object
streamObj = picoGetChildObject(obj,'Streaming');

% Start streaming data collection.
[~, sampleInterval, timeUnitsStr] = ...
    invoke(streamObj, 'ps5000aRunStreaming', downSamplingRatio, ...
    ratioMode, overviewBufferSize);

% Convert sampleInterval to seconds
sampleInterval = picoConvertTimeUnits(sampleInterval, timeUnitsStr);

function [tIndex,tIntervalNs,sampleRate] = picoGetTimeBaseIndex(obj,sampleRate)
% PICOGETTIMEBASEINDEX Obtains the most optimal time base index for a
% sampling frequency and actual device configuration. It returns, among
% other data, the final sampling frequency that can be obtained, which may
% be equal to or less than the one sent.
% This function uses the functions picoGetMinimumTimeBaseIndex and 
% picoCalcTimeBaseIndex and compare the results to choose the best option.
%
% [tIndex,tIntervalNs,sampleRate] = picoGetTimeBaseIndex(obj,sampleRate)
%
% Input: 
%          obj - PicoScope Object (icdevice).
%   sampleRate - Desired sample rate in Hertz.
%
% Output:
%        tIndex - Time base index.
%   tIntervalNs - Time sample interval in nanoseconds.
%     samplRate - Final sample rate in hertz.
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%
% See also PICOGETMINIMUMTIMEBASEINDEX, PICOCALCTIMEBASEINDEX.

arguments
    obj         icdevice
    sampleRate  (1,1) {mustBeInteger,mustBePositive} = 50e6
end

[timebaseIndexmin,timeIntervalNanosecondsmin,~] = picoGetMinimumTimeBaseIndex(obj);
[timebaseIndexUsr,timeIntervalNanosecondsUsr,~] = picoCalcTimeBaseIndex(obj,sampleRate);

if timebaseIndexmin > timebaseIndexUsr
    tIndex = timebaseIndexmin;
    tIntervalNs = timeIntervalNanosecondsmin;
else
    tIndex = timebaseIndexUsr;
    tIntervalNs = timeIntervalNanosecondsUsr;
end

sampleRate = ceil(1/(tIntervalNs*1e-9));
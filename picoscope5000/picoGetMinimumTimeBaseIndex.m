function [timebaseIndex,timeIntervalNs,maxSamples] = picoGetMinimumTimeBaseIndex(obj)
% PICOGETMINIMUMTIMEBASEINDEX Returns the minimum available time base
% index.
%
% [timebaseIndex,timeIntervalNanoseconds,maxSamples] = picoGetMinimumTimeBaseIndex(obj)
%
% Input:
%   obj - PicoScope Object (icdevice).
%
% Output:
%    timebaseIndex - Time base index.
%   timeIntervalNs - Time sample interval in nanoseconds.
%       maxSamples - Maximum device sample storage.
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

arguments
    obj     icdevice
end

getTimebase2 = PicoStatus.PICO_INVALID_TIMEBASE;
timebaseIndex = 0;
while (getTimebase2 == PicoStatus.PICO_INVALID_TIMEBASE)
    warning off
    [getTimebase2, timeIntervalNs, maxSamples] = ...
        invoke(obj, 'ps5000aGetTimebase2', timebaseIndex, 0);
    warning on
    if (getTimebase2 == PicoStatus.PICO_OK)   
        break;
    else
        timebaseIndex = timebaseIndex + 1;
    end      
end
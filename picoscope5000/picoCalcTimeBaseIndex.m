function [tIndex,tIntervalNs,sampleRate] = picoCalcTimeBaseIndex(obj,sampleRate)
% PICOCALCTIMEBASEINDEX Calculates the minimum time base index according to
% the current device configuration and desired samplerate.
%
% [tIndex,timeIntervalNanoseconds] = picoCalcTimeBaseIndex(obj,samplerate)
%
% Input:
%          obj - PicoScope Object (icdevice).
%   samplerate - Desired samplerate (Hz).
%
% Output:
%        tIndex - Time base index.
%   tIntervalNs - Sample interval in nanoseconds.
%    sampleRate - Samplerate effective (Hz).
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

arguments
    obj         icdevice
    sampleRate  (1,1) {mustBeInteger,mustBePositive} = 50e6
end

% Get device information
DriverData = obj.DriverData;

resolution = DriverData.resolution;
channelSettings = DriverData.channelSettings;
nEnabledChannel = sum(channelSettings(:,1));
sampleInterval = 1/sampleRate;

switch true
    case resolution == 8
            switch true
                case sampleInterval <= 1e-9
                    if nEnabledChannel == 1; tIndex = 0; else; tIndex = 1; end
                    tIntervalNs = 2^tIndex/1e9 * 1e9;
                case sampleInterval > 1e-9 && sampleInterval <= 2e-9
                    tIndex = max(floor(log2(sampleInterval * 1e9)),1);
                    tIntervalNs = 2^tIndex/1e9 * 1e9;
                case sampleInterval > 2e-9 && sampleInterval <= 4e-9
                    tIndex = max(floor(log2(sampleInterval * 1e9)),2);
                    tIntervalNs = 2^tIndex/1e9 * 1e9;
                case sampleInterval > 4e-9
                    tIndex = floor(sampleInterval * 125e6 + 2);
                    tIntervalNs = (tIndex-2)/125e6 * 1e9;
            end 
    case resolution == 12
            switch true
                case sampleInterval <= 2e-9
                    if nEnabledChannel == 1; tIndex = 1; else; tIndex = 2; end
                    tIntervalNs = 2^(tIndex-1)/0.5e9 * 1e9;
                case sampleInterval > 2e-9 && sampleInterval <= 4e-9
                    tIndex = max(floor(log2(sampleInterval * 0.5e9))+1,2);
                    tIntervalNs = 2^(tIndex-1)/0.5e9 * 1e9;
                case sampleInterval > 4e-9 && sampleInterval <= 8e-9
                    tIndex = max(floor(log2(sampleInterval * 0.5e9))+1,3);
                    tIntervalNs = 2^(tIndex-1)/0.5e9 * 1e9;
                case sampleInterval > 4e-9
                    tIndex = floor(sampleInterval * 62.5e6 + 3);
                    tIntervalNs = (tIndex-3)/62.5e6 * 1e9;
            end 
    case resolution == 14
        if sampleInterval <= 8e-9
            tIndex = 3;
            tIntervalNs = 1/125e6 * 1e9;
        else
            tIndex = floor(sampleInterval * 125e6 + 2);
            tIntervalNs = (tIndex-2)/125e6 * 1e9;
        end
    case resolution == 15
        if sampleInterval <= 8e-9 && nEnabledChannel <= 2
            tIndex = 3;
            tIntervalNs = 1/125e6 * 1e9;
        else
            tIndex = floor(sampleInterval * 125e6 + 2);
            tIntervalNs = (tIndex-2)/125e6 * 1e9;
        end
    case resolution == 16
        if sampleInterval <= 16e-9 && nEnabledChannel <= 1
            tIndex = 4;
            tIntervalNs = 1/62.5e6 * 1e9;
        else
            tIndex = floor(sampleInterval * 62.5e6 + 3);
            tIntervalNs = (tIndex-3)/62.5e6 * 1e9;
        end
end

sampleRate = ceil(1/(tIntervalNs*1e-9));
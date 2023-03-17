function [resolution,maxADCCount] = picoSetResolution(obj,resolution)
% PICOSETRESOLUTION Set digital converter resolution in bits.
%
% [resolution,maxADCCount] = picoSetResolution(obj,resolution)
%
% Inputs:
%          obj - PicoScope Object (icdevice).
%   resolution - Bit resolution (8,12,14,15,16)
%
% Outputs:
%    resolution - Defined resolution
%   maxADCcount - Analog Digital Converter (ADC) count value. Used for
%                 scaling values
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

arguments
    obj         icdevice
    resolution  (1,1) {mustBeMember(resolution,[8,12,14,15,16])} = 12
end

% Set resolution
[~, resolution] = invoke(obj, 'ps5000aSetDeviceResolution', resolution);

% Analog Digital Converter (ADC) count value. Used for scaling values
% This value may change depending on the resolution selected.
maxADCCount = get(obj, 'maxADCValue');
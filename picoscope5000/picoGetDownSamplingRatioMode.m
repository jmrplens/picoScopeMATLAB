function ratioMode = picoGetDownSamplingRatioMode(ratio,type)
% PICOGETDOWNSAMPLINGRATIOMODE Function to obtain the configuration index 
% according to the chosen downsampling mode.
%
% ratioMode = picoGetDownSamplingRatioMode(ratio,type)
%
% Inputs:
%   ratio - Downsampling ratio (Integer, from 1 to desired value).
%    type - Downsampling mode (decimate, average, aggregate).
%
% Output:
%   ratioMode - Constant ratioMode.
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

arguments
    ratio (1,1) {mustBePositive,mustBeInteger} = 1
    type {mustBeMember(type,{'decimate','average','aggregate',''})} = 'decimate'
end

if ratio > 1
    switch lower(type)
        case 'aggregate'
            ratioMode = 1;
        case 'decimate'
            ratioMode = 2;
        case 'average'
            ratioMode = 4;
        otherwise
            ratioMode = 2;
    end
else
    ratioMode = 0;
end
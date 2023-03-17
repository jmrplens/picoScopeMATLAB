function sampleInterval = picoConvertTimeUnits(sampleInterval, timeUnitsStr)
% PICOCONVERTTIMEUNITS Convert sample interval in any unit to seconds.
% This function is needed to correct the output of <a href="matlab:open('picoRunStream')">picoRunStream</a>.
%
% sampleInterval = picoConvertTimeUnits(sampleInterval, timeUnitsStr)
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

sampleInterval = double(sampleInterval);
switch true
    case strcmp(timeUnitsStr,'fs')
        sampleInterval = sampleInterval * 1e-15;
    case strcmp(timeUnitsStr,'ps')
        sampleInterval = sampleInterval * 1e-12;
    case strcmp(timeUnitsStr,'ns')
        sampleInterval = sampleInterval * 1e-9;
    case strcmp(timeUnitsStr,'us')
        sampleInterval = sampleInterval * 1e-6;
    case strcmp(timeUnitsStr,'ms')
        sampleInterval = sampleInterval * 1e-3;
    case strcmp(timeUnitsStr,'s')
        sampleInterval = sampleInterval * 1;
end
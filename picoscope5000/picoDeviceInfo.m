function unitInfo = picoDeviceInfo(obj)
% PICODEVICEINFO Returns information about device. 
% Use disp(unitInfo) to view in command window.
%
% unitInfo = picoDeviceInfo(obj)
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

[~, unitInfo] = invoke(obj, 'getUnitInfo');
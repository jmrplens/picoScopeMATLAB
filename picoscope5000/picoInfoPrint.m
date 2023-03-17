function status = picoInfoPrint(obj,enable)
% PICOINFOPRINT Enable or disable messages in MATLAB command window.
%
% status = picoInfoPrint(obj,enable)
%
% Input:
%      obj - PicoScope Object (icdevice).
%   enable - Integer to enable (1) or disable (0). If not set, returns
%            actual state.
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

arguments
    obj     icdevice
    enable (1,1) {mustBeMember(enable,[-1,0,1])} = -1
end

if enable == 0 || enable == 1
    status = enable;
    obj.DriverData.displayOutput = status;
else
    status = obj.DriverData.displayOutput;
end
 
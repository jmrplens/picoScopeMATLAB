function obj = picoDeviceConnect(info,driver,serialnumber,reset)
% PICODEVICECONNECT Connect the device to MATLAB and return the instrument
% object 'icdevice'.
%
% obj = picoDeviceConnect(driver,serialnumber,reset)
%
% Inputs:
%         driver - Filename of driver (Default: 'picotech_ps5000a_generic.mdd').
%   serialnumber - Serial number of device (Default: '').
%          reset - Reset device settings (1 true, 0 false).
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

arguments
    info        (1,1)    {mustBeMember(info,[0,1])} = 0
    driver              {mustBeText} = 'picotech_ps5000a_generic.mdd'
    serialnumber        {mustBeText} = ''
    reset       (1,1)   {mustBeMember(reset,[0,1])} = 0
end



% Initial settings
PS5000aConfig;

% Device object and connect
if info == 1
    obj = icdevice(driver,serialnumber);
    connect(obj);
else
    evalc('obj = icdevice(driver,serialnumber);');
    evalc('connect(obj);');
end

if reset == 1
    picoDeviceReset(obj)
end

% Print info in command window?
picoInfoPrint(obj,info);
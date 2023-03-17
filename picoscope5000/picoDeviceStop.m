function picoDeviceStop(obj)
% PICODEVICESTOP Stop all running jobs.
%
% picoDeviceStop(obj)
% 
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

arguments
    obj icdevice
end

% Stop device
invoke(obj, 'ps5000aStop');
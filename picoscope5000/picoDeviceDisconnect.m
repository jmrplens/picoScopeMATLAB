function picoDeviceDisconnect(obj)
% PICODEVICEDISCONNECT Disconnects and deletes the instrument in MATLAB 
% to released and can be used by another program.
%
% picoDeviceDisconnect(obj)
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

arguments
    obj  icdevice
end

% Disconnect device object from hardware.
if picoInfoPrint(obj)
    disconnect(obj);
    delete(obj);
else
    evalc('disconnect(obj);');
    evalc('delete(obj);');
end
function picoStopGen(obj)
% PICOSTOPGEN Set the output to 0V.
%
% picoStopGen(obj)
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

arguments
    obj icdevice
end

sigGenObj = picoGetChildObject(obj,'Signalgenerator');

invoke(sigGenObj, 'setSigGenOff');
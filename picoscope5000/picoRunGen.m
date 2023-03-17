function picoRunGen(obj)
% PICORUNGEN Start the signal generation if software trigger is set.
%
% picoRunGen(obj)
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%
% See also PICOSETGENDEFAULT, PICOSETGENARBITRARY.

arguments
    obj icdevice
end

% Check triggertype in gen, if GATE_HIGH, trigger with 1, GATE_LOW trigger with 0 

sigGenObj = picoGetChildObject(obj,'Signalgenerator');

invoke(sigGenObj, 'ps5000aSigGenSoftwareControl', 1);
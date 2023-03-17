function childObj = picoGetChildObject(obj,type)
% PICOGETCHILDOBJECT Returns a component of the main object (PicoScope)
%
% childObj = picoGetChildObject(obj,type)
%
% Inputs:
%    obj - PicoScope Object (icdevice).
%   type - Component (streaming, signalgenerator, block, trigger, digital,
%          rapidblock)
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

arguments
    obj     icdevice
    type    {mustBeMember(type,{'Streaming','Signalgenerator','Block','Trigger','Digital','Rapidblock'})}
end

childGrpObj = get(obj, type);
childObj    = childGrpObj(1);


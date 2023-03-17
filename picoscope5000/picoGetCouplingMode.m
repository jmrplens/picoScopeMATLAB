function couplingMode = picoGetCouplingMode(type)
% PICOGETCOUPLINGMODE Returns the index for the chosen coupling value.
%
% couplingMode = picoGetCouplingMode(type)
%
% Input:
%   type - Coupling type ("DC" or "AC")
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

arguments
    type {mustBeMember(type,{'DC','AC'})} = "DC"
end


switch lower(type)
    case 'dc'
        couplingMode = 1;
    case 'ac'
        couplingMode = 0;
end
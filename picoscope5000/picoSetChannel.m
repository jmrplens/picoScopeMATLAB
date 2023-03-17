function picoSetChannel(obj,ch_properties)
% PICOSETCHANNEL Set scope channel parameters.
%
% status = picoSetChannel(obj,ch_properties,status)
%
% Inputs:
%             obj - PicoScope Object (icdevice). 
%   ch_properties - Structure with parameters (see below).
%
%         Structure             Description         Units    
%  ------------------------ -------------------- ----------- 
%   ch_properties.channels    Which channel(s)        -      
%   ch_properties.coupling   AC or DC coupling        -      
%    ch_properties.range     Peak to Peak Range   milivolts  
%    ch_properties.offset      Voltage offset     milivolts
%
% Example
% for channels A (0) and B (1):
%   ch_properties.channels = [0,1];
%   ch_properties.coupling = ["DC","DC"];
%   ch_properties.range    = [2000,1000];
%   ch_properties.offset   = [0,0];
% 
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%
% See also PICOSETTRIGGER, PICOSETGENDEFAULT.

arguments
    obj             icdevice
    ch_properties   (1,1) {isstruct} = struct()
end

% Load configuration information
PS5000aConfig;

% Find current power source
currentPowerSource = invoke(obj, 'ps5000aCurrentPowerSource');

% Channel setup
for i = 0:3

    % Channels C and D only enable if power supply connected
    if any(ch_properties.channels==i) ...
            && (i<2 || (i>=2 && currentPowerSource == PicoStatus.PICO_POWER_SUPPLY_CONNECTED))

        idx = find(ch_properties.channels==i);
        invoke(obj, 'ps5000aSetChannel', ...
            ch_properties.channels(idx), ...
            PicoConstants.TRUE, ... % Channel Enabled
            picoGetCouplingMode(ch_properties.coupling(idx)), ...
            picoGetRangeMode(ch_properties.range(idx)), ...
            ch_properties.offset(idx));

    elseif currentPowerSource == PicoStatus.PICO_POWER_SUPPLY_CONNECTED || i<2
        invoke(obj, 'ps5000aSetChannel', i, 0, 1, 8, 0.0); % Channel disabled
    end
end
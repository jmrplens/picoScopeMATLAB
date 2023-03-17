function picoSetTrigger(obj,tg_properties)
% PICOSETTRIGGER Set trigger channel(s) and parameters.
%
% picoSetTrigger(obj,tg_properties)
%
% Input:
%             obj - PicoScope Object (icdevice).
%   tg_properties - Structure with parameters (see below).
%
%
%   Structure                                Description              Units
%  ---------------------------------------- ------------------------ -------------
%   tg_properties.channels                   Which channel(s)         -
%   tg_properties.condition                  True or False            -             (optional, default = 0)
%   tg_properties.direction                  Rising, Falling, etc     -             (optional, default = 0)
%   tg_properties.mode                       Level or window          -             (optional, default = 0)
%   tg_properties.mainthreshold              Main threshold           milivolts     (optional, overwrite other thresholds)
%   tg_properties.thresholdUpper             Upper threshold          milivolts     (optional, default 500)
%   tg_properties.thresholdUpperHysteresis   Upper hysteresis         milivolts     (optional, default 0.1*thresholdUpper)
%   tg_properties.thresholdLower             Lower threshold          milivolts     (optional, default 500)
%   tg_properties.thresholdLowerHysteresis   Lower hysteresis         milivolts     (optional, default 0.1*thresholdLower)
%   tg_properties.autoTriggerUs              Automatic trigger time   microseconds  (optional, default 100e3)
%
% At least it is necessary to define the channel(s) and the condition(s).
%
%    Condition                Direction                   Mode
%  -------------- ------------------------------------ -----------
%   DONT CARE: 0   ABOVE:             0 (LEVEL MODE)    LEVEL:  0
%   TRUE:      1   BELOW:             1 (LEVEL MODE)    WINDOW: 1
%   FALSE:     2   RISING:            2 (LEVEL MODE)
%                  FALLING:           3 (LEVEL MODE)
%                  RISING OR FALLING: 4 (LEVEL MODE)
%                  ABOVE LOWER:       5 (LEVEL MODE)
%                  BELOW LOWER:       6 (LEVEL MODE)
%                  RISING LOWER:      7 (LEVEL MODE)
%                  FALLING LOWER:     8 (LEVEL MODE)
%                  INSIDE:            0 (WINDOW MODE)
%                  OUTSIDE:           1 (WINDOW MODE)
%                  ENTER:             2 (WINDOW MODE)
%                  EXIT:              3 (WINDOW MODE)
%                  ENTER OR EXIT:     4 (WINDOW MODE)
%                  POSITIVE RUNT:     9 (WINDOW MODE)
%                  NEGATIVE RUNT:    10 (WINDOW MODE)
%                  NONE:              2
%
% Example
% for channels A (0) and B (1):
%   tg_properties.channels  = [0,1];
%   tg_properties.condition = [1,1];
%   tg_properties.direction = [2,3];
%   tg_properties.mode      = [0,0];
%   tg_properties.thresholdUpper            = [500,500];
%   tg_properties.thresholdUpperHysteresis  = [50,50];
%   tg_properties.thresholdLower            = [500,500];
%   tg_properties.thresholdLowerHysteresis  = [50,50];
%   tg_properties.autoTriggerUs             = 1000;
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%
% See also PICOSETCHANNEL, PICOSETGENDEFAULT.

arguments
    obj             icdevice
    tg_properties   (1,1) {isstruct} = struct()
end

% If set
if ~isempty(fieldnames(tg_properties))
    %% Trigger object
    triggerGroupObj = picoGetChildObject(obj,'Trigger');

    %% Trigger Settings
    nCh = numel(tg_properties.channels);
    conditionsInfo.CLEAR = 1;
    conditionsInfo.ADD   = 2;
    TriggerDirections(nCh) = struct();
    TriggerProperties(nCh) = struct();
    for i=1:nCh

        % Channel
        TriggerSettings.source = tg_properties.channels(i);

        % Condition
        if isfield(tg_properties,'condition')
            TriggerSettings.condition   = tg_properties.condition(i);
        else
            TriggerSettings.condition = 0;
        end

        if i == 1
            % First with clear all trigger
            info = conditionsInfo.CLEAR + conditionsInfo.ADD;
        else
            % After add each other triggers
            info = conditionsInfo.ADD;
        end
        invoke(triggerGroupObj, 'ps5000aSetTriggerChannelConditionsV2', TriggerSettings, info);

        % DIRECTIONS
        TriggerDirections(i).source = tg_properties.channels(i);
        if isfield(tg_properties,'direction')
            TriggerDirections(i).direction = tg_properties.direction(i);
        else
            TriggerDirections(i).direction = 0;
        end
        if isfield(tg_properties,'mode')
            TriggerDirections(i).mode = tg_properties.mode(i);
        else
            TriggerDirections(i).mode = 0;
        end

        if isfield(tg_properties,'mainthreshold')
            mainthreshold = tg_properties.mainthreshold(i);
        else
            mainthreshold = 500;
        end

        % PROPERTIES
        TriggerProperties(i).channel = tg_properties.channels(i);
        if isfield(tg_properties,'thresholdUpper') && not(isfield(tg_properties,'mainthreshold'))
            TriggerProperties(i).thresholdUpper = tg_properties.thresholdUpper(i);
        else
            TriggerProperties(i).thresholdUpper = mainthreshold;
        end
        if isfield(tg_properties,'thresholdUpperHysteresis')  && not(isfield(tg_properties,'mainthreshold'))
            TriggerProperties(i).thresholdUpperHysteresis = tg_properties.thresholdUpperHysteresis(i);
        else
            TriggerProperties(i).thresholdUpperHysteresis = 0.1*mainthreshold;
        end
        if isfield(tg_properties,'thresholdLower')  && not(isfield(tg_properties,'mainthreshold'))
            TriggerProperties(i).thresholdLower = tg_properties.thresholdLower(i);
        else
            TriggerProperties(i).thresholdLower = mainthreshold;
        end
        if isfield(tg_properties,'thresholdLowerHysteresis')  && not(isfield(tg_properties,'mainthreshold'))
            TriggerProperties(i).thresholdLowerHysteresis = tg_properties.thresholdLowerHysteresis(i);
        else
            TriggerProperties(i).thresholdLowerHysteresis = 0.1*mainthreshold;
        end


    end

    % SET DIRECTIONS
    invoke(triggerGroupObj, 'ps5000aSetTriggerChannelDirectionsV2', TriggerDirections);

    % SET PROPERTIES
    invoke(triggerGroupObj, 'ps5000aSetTriggerChannelPropertiesV2', TriggerProperties);

    % SET AUTO TRIGGER
    if isfield(tg_properties,'autoTriggerUs')
        invoke(triggerGroupObj, 'ps5000aSetAutoTriggerMicroSeconds', tg_properties.autoTriggerUs);
    else
        invoke(triggerGroupObj, 'ps5000aSetAutoTriggerMicroSeconds', 100e3);
    end

end
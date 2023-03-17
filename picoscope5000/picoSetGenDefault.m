function picoSetGenDefault(obj, waveType, frequency, VppMv, VoffsetMv, shots, triggerType, triggerSource,extInThresholdMv)
% PICOSETGENDEFAULT Set a predefined signal from the generator.
%
% picoSetGenDefault(obj, waveType, frequency, VppMv, VoffsetMv, shots, triggerType, triggerSource, extInThresholdMv)
%
% If only the object is defined as input parameter, a 1 MHz, 1Vpp sine wave signal is generated.
%
% Inputs:
%              obj - PicoScope Object (icdevice).
%         waveType - Signal type (sine, square, triangle, ramp up, ramp
%                    down, sinc, gaussian, half sine, DC, white noise).
%        frequency - Signal frequency (if not applicable, as with white
%                    noise, the value is ignored).
%            VppMv - Peak-to-peak signal voltage in milivolts.
%        VoffsetMv - Signal voltage offset in milivolts.
%            shots - Number of cycles. 0 = continuous
%      triggerType - Trigger type (rising, falling, gate high, gate low).
%    triggerSource - Trigger source (none,scope,aux in, ext in, software).
% extInThresholdMv - If external trigger, set threshold in milivolts.
%
%   waveType available   triggerType available   triggerSource available
%  -------------------- ----------------------- -------------------------
%     SINE:        0         RISING:    0              NONE:     0
%     SQUARE:      1         FALLING:   1              SCOPE:    1
%     TRIANGLE:    2         GATE HIGH: 2              AUX IN:   2
%     RAMP UP:     3         GATE LOW:  3              EXT IN:   3
%     RAMP DOWN:   4                                   SOFTWARE: 4
%     SINC:        5
%     GAUSSIAN:    6
%     HALF SINE:   7
%     DC:          8
%     WHITE NOISE: 9
%     PRBS*:       10
%     TTL 2V:      11
%
% *Pseudorandom binary sequence with a bit rate specified by the start and stop frequencies.
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

arguments
    obj icdevice
    waveType        (1,1) {mustBeMember(waveType,0:11)} = 0
    frequency       (1,1) {mustBeInteger,mustBePositive} = 1e6
    VppMv           (1,1) {mustBePositive} = 1000
    VoffsetMv       (1,1) {mustBeReal} = 0
    shots           (1,1) {mustBeInteger,mustBeNonnegative} = 0
    triggerType     (1,1) {mustBeMember(triggerType,0:3)} = 0
    triggerSource   (1,1) {mustBeMember(triggerSource,0:4)} = 0
    extInThresholdMv(1,1) {mustBeInteger,mustBeNonnegative} = 0
end

switch true
    case waveType == 11 % TTL wavetype
        waveType    = 1;    % Square
        frequency   = 500;  % Hz. Up time = 1ms
        VppMv       = 2000; % Pico Max output voltage
        VoffsetMv   = 1000; % form 0 to 2 V
        shots       = 1;    % One Up-Down
        operation   = 0;

    case waveType == 9 % White noise
        waveType    = 0;
        operation   = 1;

    case waveType == 10 % PRBS
        waveType = 0;
        operation = 2;
        
    otherwise
        operation   = 0;
end

% Other parameters
increment = 0; % Hz
dwellTime = 0; % seconds
sweepType = 0;
sweeps = 0;

% Define electric parameters
sigGenObj = picoGetChildObject(obj,'Signalgenerator');
set(sigGenObj, 'startFrequency', frequency);
set(sigGenObj, 'stopFrequency', frequency);
set(sigGenObj, 'offsetVoltage', VoffsetMv);
set(sigGenObj, 'peakToPeakVoltage', VppMv);

% Set generator
invoke(sigGenObj,'setSigGenBuiltIn', ...
    waveType, increment, dwellTime, sweepType, operation, shots,...
    sweeps, triggerType, triggerSource, extInThresholdMv);
function picoSetGenArbitrary(obj, waveform, samplerate, VppMv, VoffsetMv, shots, triggerType, triggerSource,extInThresholdMv)
% PICOSETGENARBITRARY Set a arbitrary signal from the generator.
%
% picoSetGenDefault(obj, waveType, samplerate, VppMv, VoffsetMv, shots, triggerType, triggerSource, extInThresholdMv)
%
% The maximum signal lenght is 32768 (awgBuffersize):
%       sigGenObj = picoGetChildObject(obj,'Signalgenerator');
%       awgBufferSize = get(sigGenObj, 'awgBufferSize');
%
% Inputs:
%              obj - PicoScope Object (icdevice).
%         waveform - Signal array.
%       samplerate - Samplerate of signal array.
%            VppMv - Peak-to-peak signal voltage in milivolts.
%        VoffsetMv - Signal voltage offset in milivolts.
%            shots - Number of cycles. 0 = continuous
%      triggerType - Trigger type (rising, falling, gate high, gate low).
%    triggerSource - Trigger source (none,scope,aux in, ext in, software).
% extInThresholdMv - If external trigger, set threshold in milivolts.
%
%  triggerType available   triggerSource available
% ----------------------- -------------------------
%    RISING:    0              NONE:     0
%    FALLING:   1              SCOPE:    1
%    GATE HIGH: 2              AUX IN:   2
%    GATE LOW:  3              EXT IN:   3
%                              SOFTWARE: 4
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

arguments
    obj icdevice
    waveform        (1,:) {mustBeReal} = sin(linspace(0,2*pi,32768))
    samplerate      (1,1) {mustBeInteger,mustBePositive} = 1e6
    VppMv           (1,1) {mustBePositive} = 1000
    VoffsetMv       (1,1) {mustBeReal} = 0
    shots           (1,1) {mustBeInteger,mustBeNonnegative} = 0
    triggerType     (1,1) {mustBeMember(triggerType,0:3)} = 0
    triggerSource   (1,1) {mustBeMember(triggerSource,0:4)} = 0
    extInThresholdMv(1,1) {mustBeInteger,mustBeNonnegative} = 0
end

% Get generator object
sigGenObj = picoGetChildObject(obj,'Signalgenerator');
% Get maximum length
awgBufferSize = get(sigGenObj, 'awgBufferSize');

% Cut signal to maximum
if length(waveform) > awgBufferSize
    waveform(awgBufferSize+1:end) = [];
end

% Normalize signal
waveform = waveform./max(abs(waveform(:)));

% Define electric parameters
set(sigGenObj, 'startFrequency', samplerate);
set(sigGenObj, 'stopFrequency', samplerate);
set(sigGenObj, 'offsetVoltage', VoffsetMv);
set(sigGenObj, 'peakToPeakVoltage', VppMv);

% Other parameters
increment = 0; % Hz
dwellTime = 0; % seconds
sweepType = 0;
operation = 0;
indexMode = 0;
sweeps = 0;

% Set generator
invoke(sigGenObj, 'setSigGenArbitrary', ...
    increment, dwellTime, waveform, sweepType, operation, indexMode,...
    shots, sweeps, triggerType, triggerSource, extInThresholdMv);
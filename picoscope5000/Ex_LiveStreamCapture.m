% This example shows how to perform a real-time capture. It is an optimized
% version of the example provided by Pico Technology (<a href="matlab:open('PS5000A_ID_Streaming_Example.m')">here</a>).
% The example has the generator configured to do the tests (connecting the
% generator to an input directly), but you can remove the generator and
% measure in real time any source.
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

clc, close all;

% Initialization
PS5000aConfig;

% Connect to device. More info help('picoDeviceConnect')
printInfo = 0; % Disable print in command window
obj       = picoDeviceConnect(printInfo);

% Set function generator (remove me if not needed signal generator)
waveType        = 0; % Sine
frequency       = 100; % Hz
VppMv           = 2000; % +- 2V
VoffsetMv       = 0;
shots           = 0; % Set to 0 for continuous mode.
triggerType     = 0; % Doesnt matter because triggerSource is Scope
triggerSource   = 1; % When the capture starts, the signal is triggered
picoSetGenDefault(obj, waveType, frequency, VppMv, VoffsetMv, shots, triggerType, triggerSource);

% Set channel. More info: help('picoSetChannel')
ch_properties.channels  = [0,1];
ch_properties.coupling  = ["DC","DC"];
ch_properties.range     = [2000,2000];
ch_properties.offset    = [0,0];
nCh                     = numel(ch_properties.channels);
picoSetChannel(obj,ch_properties)

% Resolution [bits]. More info: help('picoSetResolution')
resolution      = 12;
[~,maxADCCount] = picoSetResolution(obj,resolution); 

% Set samplerate. More info: help('picoSetSampleRateStream')
samplerate      = 192e3; % Hz
sampleInterval  = picoSetSampleRateStream(obj,samplerate);

% Set trigger. More info: help('picoSetTrigger')
tg_properties.channels      = 0;
tg_properties.mainthreshold = 500;
tg_properties.direction     = 2;
tg_properties.autoTriggerUs = 1000;
picoSetTrigger(obj,tg_properties)

% Data buffers
msrtime           = 5; % Max capture time in seconds
pretime           = 0; % Pretrigger capture time in seconds
downSamplingRatio = 1;
autoStop          = 1; % Stop or not capture after msrtime (continuous mode)

% Calculate Trigger buffers. More info: help('picoGetDownSamplingRatioMode')
ratioMode = picoGetDownSamplingRatioMode(downSamplingRatio);
minbuffer = ceil(msrtime / sampleInterval);
prebuffer = ceil(pretime / sampleInterval);

% Set Trigger buffers
set(obj, 'numPreTriggerSamples', prebuffer);
set(obj, 'numPostTriggerSamples', minbuffer);

% Total samples
maxSamples = minbuffer + prebuffer;

% Size of the buffer to collect data from buffer.
overviewBufferSize = maxSamples*4;

% Take into account the downsampling ratio mode. Allocate sufficient space
% (1.5 times the sum of the number of pre-trigger and post-trigger samples).
finalBufferLength = round(maxSamples / downSamplingRatio * 1.5);

% Create buffers
streamObj = picoGetChildObject(obj,'Streaming');
DriverBuffer(nCh)   = libpointer; % Initializing
AppBuffer(nCh)      = libpointer;
BufferFinal(nCh)    = libpointer;
for i=1:nCh
    DriverBuffer(i) = libpointer('int16Ptr', zeros(overviewBufferSize, 1, 'int16'));
    AppBuffer(i)    = libpointer('int16Ptr', zeros(overviewBufferSize, 1, 'int16'));
    BufferFinal(i)  = libpointer('int16Ptr', zeros(finalBufferLength, 1, 'int16'));

    invoke(obj, 'ps5000aSetDataBuffer', ...
        ch_properties.channels(i), DriverBuffer(i), overviewBufferSize, 0, ratioMode);

    invoke(streamObj, 'setAppAndDriverBuffers', ch_properties.channels(i), ...
        AppBuffer(i), DriverBuffer(i), overviewBufferSize);
end
set(streamObj, 'autoStop', autoStop);

% Prompt User to indicate if they wish to plot live streaming data.
plotLiveData = questionDialog('Plot live streaming data?', 'Streaming Data Plot');

% Start streaming data collection. More info: help('picoRunStream')
sampleInterval  = picoRunStream(obj,overviewBufferSize,downSamplingRatio,ratioMode);

% Variables to be used when collecting the data:
hasAutoStopOccurred = 0;  % Indicates if the device has stopped automatically.
powerChange         = 0;  % If the device power status has changed.
newSamples          = 0; % Number of new samples returned from the driver.
previousTotal       = 0; % The previous total number of samples.
totalSamples        = 0; % Total samples captured by the device.
startIndex          = 0; % Start index of data in the buffer returned.
hasTriggered        = 0; % To indicate if trigger has occurred.
triggeredAtIndex    = 0; % The index in the overall buffer where the trigger occurred.
getStreamingLatestValuesStatus = 0; % OK

% Plot Properties - these are for displaying data as it is collected.
if (plotLiveData == 1)
    % Plot on a single figure. 
    figure1 = figure('Name','PicoScope 5000 Series (A API) Example - Streaming Mode Capture');
    axes1   = axes('Parent', figure1);
    ln      = plot(axes1, 0, zeros(1,nCh));
    xlim(axes1, [0 (sampleInterval * maxSamples)]);
    yRange = max(ch_properties.range);
    ylim(axes1,[-1, 1]*yRange);
    grid(axes1, 'on');
    title(axes1, 'Live Streaming Data Capture');
    xlabel(axes1, 'Time (s)');
    ylabel(axes1, 'Voltage (mV)');
end

% Display a 'Stop' button.
[stopFig.h, stopFig.h] = stopButton();             
             
flag = 1; % Use flag variable to indicate if stop button has been clicked (0).
setappdata(gcf, 'run', flag);

%%
% Collect samples as long as the |hasAutoStopOccurred| flag has not been
% set or the call to |getStreamingLatestValues()| does not return an error
% code (check for STOP button push inside loop).
while(hasAutoStopOccurred == 0 && getStreamingLatestValuesStatus == 0)
    ready = 0;
    while (ready == 0)
        getStreamingLatestValuesStatus = invoke(streamObj, 'getStreamingLatestValues');
        ready = invoke(streamObj, 'isReady');

        % Give option to abort from here
        flag = getappdata(gcf, 'run');
        drawnow limitrate
        if flag == 0
            break;
        end

    end

    % Check for data
    [newSamples, startIndex] = invoke(streamObj, 'availableData');

    if (newSamples > 0)
        % Check if the scope has triggered.
        [triggered, triggeredAt] = invoke(streamObj, 'isTriggerReady');
        if (triggered == 1)
            % Adjust trigger position as MATLAB does not use zero-based
            % indexing.
            bufferTriggerPosition = triggeredAt + 1;
            hasTriggered = triggered;
            % Set the total number of samples at which the device
            % triggered.
            triggeredAtIndex = totalSamples + bufferTriggerPosition;
        end

        previousTotal   = totalSamples;
        totalSamples    = totalSamples + newSamples;
        
        % Position indices of data in the buffer(s).
        firstValuePosn = startIndex + 1;
        lastValuePosn = startIndex + newSamples;
        
       for i = 1:nCh
            % Convert data values to millivolts from the application buffer(s).
            buffermV = adc2mv(...
                AppBuffer(i).Value(firstValuePosn:lastValuePosn),...
                PicoConstants.SCOPE_INPUT_RANGES(picoGetRangeMode(ch_properties.range(i)) + 1),...
                maxADCCount);
            % Copy data into the final buffer(s).
            BufferFinal(i).Value(previousTotal + 1:totalSamples) = buffermV;

            % Refresh plot if live plot enabled
            if (plotLiveData == 1)
                time = (double(sampleInterval) * double(downSamplingRatio)) * (0:(totalSamples - 1));
                streamData = BufferFinal(i).Value;
                set(ln(i),'XData',time,'YData',streamData(1:totalSamples))
                drawnow limitrate nocallbacks
            end
       end
          
    end

    % Check if stop has occurred.
    flag = getappdata(gcf, 'run');
    drawnow limitrate
    hasAutoStopOccurred = invoke(streamObj, 'autoStopped');
    if any([hasAutoStopOccurred,flag==0])
       break;
    end
end

% Close the STOP button window.
if (exist('stopFig', 'var'))
    close('Stop Button');
    clear stopFig;     
end
if (plotLiveData == 1)
    drawnow;
    movegui(figure1, 'west'); 
end

% Stop the device
picoDeviceStop(obj)

% Process data
% Reduce size of arrays if required.
if (totalSamples < length(BufferFinal(1).Value))
    for i = 1:nCh
        BufferFinal(i).Value(totalSamples + 1:end) = [];
    end
end

% Retrieve data for the channels.
data = zeros(numel(BufferFinal(1).Value),nCh);
for i = 1:nCh
data(:,i) = BufferFinal(i).Value;
end
time = (double(sampleInterval) * double(downSamplingRatio)) * (0:length(data) - 1);

% Disconnect device
picoDeviceDisconnect(obj)

% Plot total data collected on another figure.
finalFigure = figure('Name','PicoScope 5000 Series (A API) Example - Streaming Mode Capture');

for i=1:nCh
    nexttile
    plot(time, data(:,i));
    ylim([-1,1]*ch_properties.range(i));
    xlabel('Time (s)');
    ylabel('Voltage (mV)');
    title(sprintf('Data acquisition on channel %d',i-1));
    grid on
end
movegui(finalFigure, 'east');


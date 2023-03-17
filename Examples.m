% PicoScope 5000 library examples
% Version 1.0 01-Mar-2023                  
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a> 
%

clear,clc,close all;

% Add the library path
addpath(genpath('picoscope5000'))

%% View help
doc('picoscope5000')
disp('Press any key to continue.')
pause
clc;

%% Example: Measurement by transmitting and receiving at the same time.
Ex_GenTriggeredByScope;
disp('Press any key to continue.')
pause
clear,clc,close all;

%% Example: Send a trigger signal to an external generator and capture through the input channels.
Ex_TriggerOutputAndScope;
disp('Press any key to continue.')
pause
clear,clc,close all;

%% Example: Live Stream Capture
Ex_LiveStreamCapture;
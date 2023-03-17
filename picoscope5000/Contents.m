% PicoScope 5000                              
% Version 1.0 01-Mar-2023                  
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>  
%
% ===============================
%  <a href="matlab:doc('picoscope5000')">Open this help in new window.</a>
% ===============================
%
% Device
%   PS5000aConfig                - Configures paths according to platforms and loads 
%                                  information from prototype files for PicoScope 
%                                  5000 Series (A API) Oscilloscopes.
%   picoDeviceConnect            - Connect the device to MATLAB and return the instrument
%                                  instrument object 'icdevice'.
%   picoDeviceStop               - Stop all running jobs.
%   picoDeviceReset              - Reset device to standard parameters.
%   picoDeviceDisconnect         - Disconnects and deletes the instrument in MATLAB 
%                                  for released and can be used by another program.
%   picoDeviceInfo               - Returns information about device. 
%
% Settings
%   picoSetChannel               - Set scope channel parameters.
%   picoSetResolution            - Set digital converter resolution in bits.
%   picoSetSampleRateStream      - Defines the sampling frequency of the stream object.
%   picoSetTrigger               - Set trigger channel(s) and parameters.
%
% Get settings values, info or objects
%   picoGetChildObject           - Returns a component of the main object (PicoScope)
%   picoGetCouplingMode          - Returns the index for the chosen coupling value.
%   picoGetDownSamplingRatioMode - Get Ratio mode index according to the chosen downsampling 
%                                  mode.
%   picoGetRangeMode             - Obtains the range mode of the oscilloscope 
%                                  from a voltage value in millivolts.
%   picoGetMinimumTimeBaseIndex  - Returns the minimum available time base index.
%   picoGetTimeBaseIndex         - Obtains the most optimal time base index 
%                                  for a sampling frequency and actual device 
%                                  configuration.
%
% Block capture functions
%   picoCaptureBlock             - Starts the capture and returns the captured data.
%   picoCaptureBlockAverages     - Perform several consecutive measurements
%                                  separated by a time interval and obtain the 
%                                  average.
%   picoCaptureBlockSettings     - Configures the parameters of the capture block.
%   picoGetBlockDataAnalog       - Retrieves the data captured in the block.
%   picoRunBlock                 - Starts the capture block.
%
% Stream capture functions (view Ex_LiveStreamCapture)
%   picoRunStream                - Starts the stream capture.
%
% Generator functions
%   picoSetGenDefault            - Set a predefined signal from the generator.
%   picoSetGenArbitrary          - Set a arbitrary signal from the generator.
%   picoStopGen                  - Set the output to 0V.
%   picoRunGen                   - Start the signal generation if software trigger 
%                                  is set.
%
% Misc
%   picoCalcBufferLength         - It calculates the number of samples that the
%                                  captured signal will have according to the 
%                                  measurement duration and the sampling frequency.
%   picoCalcTimeBaseIndex        - Calculates the minimum time base index according 
%                                  to the current device configuration.
%   picoInfoPrint                - Enable or disable messages in MATLAB command 
%                                  window.
%   picoConvertTimeUnits         - Convert sample interval in any unit to seconds.
%
% Examples
%   Ex_GenTriggeredByScope       - Measurement by transmitting and receiving at 
%                                  the same time.
%   Ex_TriggerOutputAndScope     - Send a trigger signal to an external generator
%                                  and capture through the input channels.
%   Ex_LiveStreamCapture         - Live stream capture.
%
%
% -------------------------------------------
%   PicoScope Support Toolbox [Version 1.1]  
% -------------------------------------------
%   <a href="matlab:help('PicoScope Support Toolbox')">Contents</a>                  
%   <a href="matlab:doc('PicoScope Support Toolbox')">Documentation</a>               
% -------------------------------------------
%
% -------------------------------------------
% PicoScope 5000 Series A API 
% Generic Instrument Driver [Version 2.1.1.6]  
% -------------------------------------------
%   <a href="matlab:help('PicoScope 5000 API/examples')">Examples</a>                                  
%   <a href="matlab:help('PicoScope 5000 API')">Contents</a>                                  
% -------------------------------------------
%


function picoRunBlock(obj)
% PICORUNBLOCK Starts the capture block.
%
% picoRunBlock(obj)
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%
% See all PICOCAPTUREBLOCK, PICOCAPTUREBLOCKAVERAGES,
% PICOCAPTUREBLOCKSETTINGS, PICOGETBLOCKDATAANALOG.

arguments
    obj  icdevice
end

% BLOCK
blockObj = picoGetChildObject(obj,'Block');

% MEASURE
[runBlock, timeIndisposedMs] = invoke(blockObj, 'runBlock', 0); %#ok<ASGLU> 
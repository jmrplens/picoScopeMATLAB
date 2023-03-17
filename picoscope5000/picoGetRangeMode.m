function rangeMode = picoGetRangeMode(Vmv)
% PICOGETRANGEMODE Obtains the range mode of the oscilloscope from a
% voltage value in millivolts. You can send a value or an array of values.
%
% rangeMode = picoGetRangeMode(Vmv)
%
% Copyright: © 2023 <a href="https://bio.jmrp.io">Jose Manuel Requena Plens</a>
%
% <a href="matlab:help('picoscope5000')">Go to main help.</a>
%

arguments
    Vmv (1,:) {mustBePositive,mustBeReal} = 2000
end

rangeMode = zeros(1,numel(Vmv));
for i=1:numel(Vmv)
    switch true
        case Vmv(i) <= 10
            rangeMode(i) = 0;
        case Vmv(i) > 10 && Vmv(i) <= 20
            rangeMode(i) = 1;
        case Vmv(i) > 20 && Vmv(i) <= 50
            rangeMode(i) = 2;
        case Vmv(i) > 50 && Vmv(i) <= 100
            rangeMode(i) = 3;
        case Vmv(i) > 100 && Vmv(i) <= 200
            rangeMode(i) = 4;
        case Vmv(i) > 200 && Vmv(i) <= 500
            rangeMode(i) = 5;
        case Vmv(i) > 500 && Vmv(i) <= 1000
            rangeMode(i) = 6;
        case Vmv(i) > 1000 && Vmv(i) <= 2000
            rangeMode(i) = 7;
        case Vmv(i) > 2000 && Vmv(i) <= 5000
            rangeMode(i) = 8;
        case Vmv(i) > 5000 && Vmv(i) <= 10000
            rangeMode(i) = 9;
        case Vmv(i) > 10000 && Vmv(i) <= 20000
            rangeMode(i) = 10;
        case Vmv(i) > 20000 && Vmv(i) <= 50000
            rangeMode(i) = 11;
        otherwise
            rangeMode(i) = 11;

    end
end
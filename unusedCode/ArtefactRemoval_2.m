function [pulse_sound] = removeInflationNoise(tsignal, signal)

MinPeakHeight = 300;

marker = 1; 
while marker ==1
    
[peak,locs] = findpeaks(signal, 'MinPeakHeight',MinPeakHeight, 'MinPeakDistance', 1670);
pumps = length(locs);
if pumps < 33
    MinPeakHeight = MinPeakHeight -100;
    
    [peak,locs] = findpeaks(signal, 'MinPeakHeight',MinPeakHeight, 'MinPeakDistance', 1670);
    pumps = length(locs);
end


if pumps >=28
    marker = 0;
end

end

for v = 1:1:length(locs)
    
    signal( locs(v)-40: locs(v) + 110 )= smooth(signal(locs(v)-40:locs(v)+110),90);


end

signal = lowPassFIR(signal);
signal = smooth(signal,90);


pulse_sound = signal;
% figure;hold on;
% plot(tsignal,signal);
% plot(tsignal(locs),signal(locs),'x','linewidth',3, 'color','b');

end

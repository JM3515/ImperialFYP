%% files
clear all;
clc;
x = load('signal_1.mat');
pulse_sound_extract = x.pulse_sound_extract;
test2 = x.tsound_extract;


accousticfile = 'signals/sound_deflation_10.log';



[tsound, pulse_sound] = loadAccFile(accousticfile);



pulse_sound = zeroSignal(pulse_sound);
[pulse_sound] = removeInflationNoise(tsound , pulse_sound);
figure; hold on;
plot(tsound,pulse_sound);
section = 61;
[tsound_temp, pulse_sound_temp] = extract(tsound,pulse_sound,section);




figure; hold on;
subplot(2,1,1);
plot(tsound_temp, pulse_sound_temp);

%differenciate 
pulse_sound_diff = diff(pulse_sound_temp);
pulse_sound_diff = [pulse_sound_diff;0];
pulse_sound_diff = lowPassFIR(pulse_sound_diff);

[peak_max,locs_max] = findpeaks(pulse_sound_diff, 'MinPeakHeight',0.000001);

subplot(2,1,2);hold on;
plot(tsound_temp',pulse_sound_diff);
plot(tsound_temp(locs_max),pulse_sound_diff(locs_max),'x','linewidth',3, 'color','b');




return; 

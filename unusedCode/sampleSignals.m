%% files
clear all;
clc;



accousticfile = 'signals/sound_deflation_9.log';



[tsound, pulse_sound] = loadAccFile(accousticfile);



pulse_sound = zeroSignal(pulse_sound);

[pulse_sound] = removeInflationNoise(tsound , pulse_sound);
figure;hold on;
plot(tsound,pulse_sound);

return;

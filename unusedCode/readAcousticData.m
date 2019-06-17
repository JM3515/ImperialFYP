clear all;
clc;



accousticfile = 'signals/sound_deflation_10.log';
pressureFile = 'signals/pressure_10.TXT';



[tsound, pulse_sound]= loadAccFile(accousticfile);

cuffP = loadPresFile(pressureFile);


pulse_sound = zeroSignal(pulse_sound);

[pulse_sound] = removeInflationNoise(tsound , pulse_sound);
figure; hold on;
plot(tsound,pulse_sound);


section = 60;
[tsound_temp, pulse_sound_temp] = extract(tsound,pulse_sound,section);

tsound_temp = tsound_temp(1090:1203);
pulse_sound_temp = pulse_sound_temp(1090:1203);

% signal 10 section 40 798:1218 has 5hz whole signal
% signal 10 section 45 748:1018 has 7.75hz whole signal 
% signal 10 section 47 900:1148 has 8.4hz whole signal 
% signal 10 section 51 1635:1733 has 21.21 hz peak to peak FFT
% signal 10 section 60 1090:1203 has 18.42 hz peak to peak FFT



figure; hold on; 
plot(tsound_temp, pulse_sound_temp);

[f, P1] = fftFunction(pulse_sound_temp);


figure; plot(f, P1, 'linewidth', 1);
xlim([0, 60]);
title('FFT of ECG Signal');
xlabel('Frequency /Hz');
ylabel('Power');
legend('FFT');

set(gca, 'fontsize', 16);
grid on; grid minor; box on;

return;

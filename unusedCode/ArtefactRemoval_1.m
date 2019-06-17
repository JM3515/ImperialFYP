%% files
clear all;
clc;

accousticfile = 'signals/sound_deflation_5.log';
pressureFile = 'signals/pressure_5.TXT';


[tsound, pulse_sound]= loadAccFile(accousticfile);

cuffP = loadPresFile(pressureFile);

pulse_sound = zeroSignal(pulse_sound);

figure;hold on;
plot(tsound,pulse_sound);
figure;hold on;
plot(tsound(37264:37338),pulse_sound(37264:37338));


T = array2table(tsound);
% Write data to text file
writetable(T, 'Signal.TXT')

return; 


fileID = fopen('Signal.TXT','r');

formatSpec = '%d %f';
sizeA = [2 Inf];

A = fscanf(fileID,formatSpec,sizeA)
fclose(fileID);

return;

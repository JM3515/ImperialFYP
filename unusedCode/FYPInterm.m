%% Clear workspace and load data
clear all; 
close all;
load('sampleECG.mat')

%% Plot sampleECG 
% data =  val(1,:);
% plot(data);
% legend('Signal', 'Drift')
% set(gca, 'fontsize', 16);
% grid on; grid minor; box on;
% title('Raw ECG signal plot from Physiobank ATM');
% xlabel('Sample Point');
% ylabel('Amplitude');


%% Moving average filter (remove sensor drift)
data = val(1,:);
data_nodrift = data - smooth(data, 700)';
data_nodrift_smooth = smooth(data_nodrift, 700);
figure; 

subplot(1,2,1); hold on;
plot(data, 'linewidth', 1)
plot(smooth(data, 700), 'linewidth', 1)
title('ECG signal with moving average plotted');
xlabel('Sample Point');
ylabel('Amplitude');
legend('Signal', 'Drift')
set(gca, 'fontsize', 16);
grid on; grid minor; box on;

subplot(1,2,2); hold on;
plot(data_nodrift, 'linewidth', 1)
plot(data_nodrift_smooth, 'linewidth', 1)
title('ECG signal minus smoothed ECG signal with moving average plotted');
xlabel('Sample Point');
ylabel('Amplitude');
legend('Signal', 'Drift')
set(gca, 'fontsize', 16);
grid on; grid minor; box on;

%% Peak detection
[pks,locs] = findpeaks(data_nodrift, 'MinPeakDistance', 500, 'MinPeakHeight', 500);

%% Visualise Peak detection
figure; hold on;
plot(data_nodrift, 'linewidth', 1);
plot(locs, data_nodrift(locs), 'x', 'linewidth', 3);
title('Peak Detection Visualised');
xlabel('Sample Point');
ylabel('Amplitude');
legend('Signal', 'Peaks');
set(gca, 'fontsize', 16);
grid on; grid minor; box on;

%% Detect envelope
data_nodrift_envelope = envelope(data_nodrift, 500, 'peak');

figure; hold on;
plot(data_nodrift, 'linewidth', 1);
plot(data_nodrift_envelope, 'linewidth', 2);

title('Envelope of ECG');
xlabel('Sample Point');
ylabel('Amplitude');
legend('Signal', 'Envelope');
set(gca, 'fontsize', 16);
grid on; grid minor; box on;

%% FFT 
Fs = 1000;
Y = fft(data_nodrift);
L = length(data_nodrift);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;


figure; plot(f, P1, 'linewidth', 1);
xlim([0, 60]);
title('FFT of ECG Signal');
xlabel('Frequency /Hz');
ylabel('Power');
legend('FFT');

set(gca, 'fontsize', 16);
grid on; grid minor; box on;

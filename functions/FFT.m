function [f, P1] = fftFunction(pulse_sound)

Fs = 2100;
Y = fft(pulse_sound);
L = length(pulse_sound);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

% 
% figure;
% plot(f, P1, 'linewidth', 1);
% xlim([1, 70]);
% title('FFT of ECG Signal');
% xlabel('Frequency /Hz');
% ylabel('Power');
% legend('FFT');
% set(gca, 'fontsize', 16);
% grid on; grid minor; box on;

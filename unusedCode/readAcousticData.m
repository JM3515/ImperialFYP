%% Read the pulse sound file
clc;
clear all;

 

% Read the last column of the log file

T = textread('Test1.log','%*s %*s %*s %s');

% DALog-1.log is a good one - was done with band to apply more pressure
% DALog-2.log Sitting upright. Wrist relaxed on stair rest
% DALog-3.log Wrist on table, wrist bend back 








% Defines

samples_per_row = 13;

REF = 1.2;

MAX = 2^12 - 1;


% Container for saving the table values in decimal

decValues = zeros(length(T), samples_per_row);

% Loop through to get values at each row

for i=1:length(T)

   

    currentTableValue = T{i};

    splitValues = regexp(currentTableValue,',','split');

   

    for j=1:samples_per_row

        decValues(i,j) = str2double(splitValues{j+1});

    end

end


for i=1:1:length(decValues)/6   % Find out the packet indices

    index(i) = decValues(6*i,samples_per_row);

end

index_diff = diff(index);

a = find(abs(index_diff)>3000);   % Find where the packet number is changing from 4095 to 0


if(length(a)==1)   % to see whether packet number 4095 and 0 lies in the same file

    for i=a+1:1:length(decValues)/6

        decValues(6*i,samples_per_row) = MAX + decValues(6*i,samples_per_row) + 1;

    end

elseif(length(a)==2)

    for i=a(1)+1:1:a(2)

        decValues(6*i,samples_per_row) = MAX + decValues(6*i,samples_per_row) + 1;

    end   

    for i=a(2)+1:1:length(decValues)/6

        decValues(6*i,samples_per_row) = (MAX*2) + decValues(6*i,samples_per_row) + 2;

    end    

end


total_packets = decValues(end,samples_per_row)-decValues(6,samples_per_row)+1;

packet = cell(1,total_packets+1); % packet number starts from 0


for i=1:1:length(decValues)/6

    packet_number = decValues(6*i,samples_per_row)-decValues(6,samples_per_row)+1; % packet number starts from 0

    packet{packet_number} = decValues(6*(i-1)+1:6*i,:);

end


for i=1:1:total_packets

    if isempty(packet{i})    % if the packet is empty then create a packet with mean value

        mat = mean(mean(cell2mat(packet(i-1))))*ones(6,samples_per_row);

        %%%%%% Introduced new %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%         matrix = cell2mat(packet(i-1))'; % to replace lost packets with extrapolated value

%         matrix = matrix(:);

%         matrix = matrix(1:end-1);

%         matrix1 = interp1(1:length(matrix),matrix,length(matrix)+1:2*length(matrix),'next','extrap');

%         for j=1:5

%            mat(j,:) = matrix1(13*(j-1)+1:13*j);

%         end

%         mat(6,:) = [matrix1(13*5+1:13*6-1) 0];

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        mat(6,samples_per_row) = decValues(6,samples_per_row)+i-1;

        packet{i} = mat;

    end

end


decValues_mod = [];

for i=1:1:length(packet)

    decValues_mod = [decValues_mod;cell2mat(packet(i))];

end


data = decValues_mod;

for i=1:1:length(decValues_mod)/6   % Replace the packet number with NaN

    data(6*i,samples_per_row) = NaN;

end


allDecValues = data';

allDecValues = allDecValues(:);

allDecValues = allDecValues(allDecValues>=0);

pulse_sound = allDecValues / MAX * REF * 1000;


fs = 1000000/476;


input = pulse_sound; %pulse_sound is the actual accoustic signal 

input = input - mean(input);

input = input/max(abs(input));

tsound = 0:1/fs:(length(input)-1)/fs; %tsound sets the time scale of the plot

figure;
plot(tsound,pulse_sound)


%% finding the peaks using find peaks 

[pks,locs] = findpeaks(pulse_sound, 'MinPeakDistance', 900, 'MinPeakHeight', 580);

figure; hold on;
plot(tsound, pulse_sound, 'linewidth', 1);
plot(tsound(locs), pulse_sound(locs), 'x', 'linewidth', 1)

%% finding average distance between peaks 

[m,n] = size(locs);

for v = 1:1:m
    if v == 1
        av = locs(v);
    else
        av = av + locs(v) - locs(v-1);
    end
end

distance = av/m;

% sampling frequency = 2.1k
% therefore time period of one sample is 1/2.1k

heartBeat = 60/(distance * (1/2100)) 

%% fft on singal 

Fs = 2100;
Y = fft(pulse_sound);
L = length(pulse_sound);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;


figure; 
plot(f, P1, 'linewidth', 1);
xlim([1, 70]);
title('FFT of ECG Signal');
xlabel('Frequency /Hz');
ylabel('Power');
legend('FFT');

set(gca, 'fontsize', 16);
grid on; grid minor; box on;

%% simple  FIR low pass filter (window method)

N   = 100;        % FIR filter order
Fp  = 6e3;       % 20 kHz passband-edge frequency
Fs  = 50e3;       % 96 kHz sampling frequency
Rp  = 0.00057565; % Corresponds to 0.01 dB peak-to-peak ripple
Rst = 0.05e-4;       % Corresponds to 80 dB stopband attenuation

eqnum = firceqrip(N,Fp/(Fs/2),[Rp Rst],'passedge'); % eqnum = vec of coeffs

% fvtool(eqnum,'Fs',Fs,'Color','White'); % Visualize filter

lowpassFIR = dsp.LMSFilter('Numerator',eqnum);
% lowpassFIR = dsp.FIRFilter('Numerator',eqnum); %or eqNum200 or numMinOrder
% fvtool(lowpassFIR,'Fs',Fs,'Color','White');% Visualize filter

pulse_sound_filtered = lowpassFIR(pulse_sound);

pulse_sound_filtered2 = lowpassFIR(pulse_sound_filtered);

figure;
plot(pulse_sound_filtered);


%% FFT of filtered signal 

Fs = 2100;
Y = fft(pulse_sound_filtered2);
L = length(pulse_sound_filtered2);

P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;


figure; 
plot(f, P1, 'linewidth', 1);
xlim([1, 70]);
title('FFT of ECG Signal');
xlabel('Frequency /Hz');
ylabel('Power');
legend('FFT');

set(gca, 'fontsize', 16);
grid on; grid minor; box on;
















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

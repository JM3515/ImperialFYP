%% https://uk.mathworks.com/help/signal/examples/peak-analysis.html

%% Clear workspace and load data
clear all; 
close all;
load('sampleECG.mat')


%% Show all peaks in the first plot
data = val(1,1:2000);

figure;

subplot(1,2,1); hold on;
plot(data)
subplot(1,2,2);hold on;
findpeaks(data)

%% Detrending Data
load('sampleECG.mat')
data = val(1,1:2000);
[p,s,mu] = polyfit(1:2000,data,6);
f_y = polyval(p,1:2000,[],mu);


ECG_data = data - f_y;% Detrend data
subplot(1,2,1);hold on;
plot(data)
subplot(1,2,2); hold on;
plot(ECG_data)

%% Thresholding to Find R_wave peak and S_wave peak

[peak,locs_Rwave] = findpeaks(ECG_data, 'MinPeakHeight',600, 'MinPeakDistance', 300);


plot(ECG_data);
hold on;
plot(locs_Rwave,ECG_data(locs_Rwave),'x', 'linewidth', 3)
hold on;


[peak,locs_Swave] = findpeaks(-ECG_data, 'MinPeakHeight',600, 'MinPeakDistance', 300);

hold on;
plot(locs_Swave, ECG_data(locs_Swave), 'x', 'linewidth', 3)


%% Finding Q_wave peaks


smoothECG = sgolayfilt(ECG_data,7,21);

% plot(1:2000,ECG_data,'b',1:2000,smoothECG,'r')
% grid on
% axis tight

[locs,min_locs] = findpeaks(-smoothECG, 'MinPeakDistance',40);

locs_Qwave = min_locs(smoothECG(min_locs)>-500 & smoothECG(min_locs)<-310);

hold on;
plot(locs_Qwave,smoothECG(locs_Qwave),'x','linewidth',3);

hold on;
plot(ECG_data)

%% Finding all three peaks 

load('sampleECG.mat')

data = val(1,1:2000);

[p,s,mu] = polyfit(1:2000,data,6);
f_y = polyval(p,1:2000,[],mu);
ECG_data = data - f_y;

[peak,locs_Rwave] = findpeaks(ECG_data, 'MinPeakHeight',600, 'MinPeakDistance', 300);
[peak,locs_Swave] = findpeaks(-ECG_data, 'MinPeakHeight',600, 'MinPeakDistance', 300);

smoothECG = sgolayfilt(ECG_data,7,21);
[locs,min_locs] = findpeaks(-smoothECG, 'MinPeakDistance',40);
locs_Qwave = min_locs(smoothECG(min_locs)>-500 & smoothECG(min_locs)<-310);

hold on;
plot(locs_Qwave,smoothECG(locs_Qwave),'x','linewidth',3, 'color','b');
plot(locs_Swave, ECG_data(locs_Swave), 'rv', 'linewidth', 3, 'color','g');
plot(locs_Rwave,ECG_data(locs_Rwave),'rs', 'linewidth', 3, 'color','k');


hold on;
plot(ECG_data,'color','r')

%% Gradient
load('sampleECG.mat')

data = val(1,1:2000);

[p,s,mu] = polyfit(1:2000,data,6);
f_y = polyval(p,1:2000,[],mu);
ECG_data = data - f_y;

xGradient = gradient(ECG_data);

%plot(xGradient)

[maxValue, maxIndex] = max(xGradient);
m = round(maxValue);

hold on;
plot(ECG_data);
hold on;
plot(maxIndex, ECG_data(maxIndex),'x','linewidth',3)





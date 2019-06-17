%% Pump pressure and acoustic sounds together

clc;
clear all;

aFileName = 'Test4.log';
pFileName = 'Test4.TXT';




T = textread(aFileName,'%*s %*s %*s %s');

samples_per_row = 13;
REF = 1.2;
MAX = 2^12 - 1;
decValues = zeros(length(T), samples_per_row);
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




a = load(pFileName);

cuffP = [a(1,:),a(2,:)];
cuffP(1:23) = 0; % set first values to 0 rather than initial spike 

s = 341;
test = 0 
for i = 1:31
    
    test = test+1
    
    if s == 341
        cuffP(s:s+50) = mean(cuffP(s:s+50));
        s = s + 50;
    else
        s = s+5;
        test = test+1;
        cuffP(s:s+50) = mean(cuffP(s:s+50));
        s = s+50;
    
    end 
    
end








figure;
hold on;
set(gca,'XTick',0:100:3000)
set(gca,'XTickLabel',0:1:30)%convert x-axis to the time domain 
xlabel('Time/s');
ylabel('Pressure/mmHg');
plot(cuffP);


figure; hold on;
plot(tsound,pulse_sound);

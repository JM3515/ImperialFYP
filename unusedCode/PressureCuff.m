%% Plot pressure curve 

clear all
close all
a = load('Test1.TXT');

cuffP = [a(1,:),a(2,:)];
cuffP(1:23) = 0; % set first values to 0 rather than initial spike 

hold on;
set(gca,'XTick',0:100:3000)
set(gca,'XTickLabel',0:1:30)%convert x-axis to the time domain 
xlabel('Time/s');
ylabel('Pressure/mmHg');
plot(cuffP);

%% Look at two plots next to each other 

clear all
close all
a = load('002.TXT');
b = load('001.TXT');

cuffP = [a(1,:),a(2,:)];
cuffP(1:23) = 0; % set first values to 0 rather than initial spike 

cuffP2 = [b(1,:),b(2,:)];
cuffP2(1:23) = 0; % set first values to 0 rather than initial spike 


subplot(1,2,1);
hold on;
set(gca,'XTick',0:100:3000)
set(gca,'XTickLabel',0:1:30)%convert x-axis to the time domain 
xlabel('Time/s');
ylabel('Pressure Initial code/mmHg');
plot(cuffP);


subplot(1,2,2);
hold on;
set(gca,'XTick',0:100:3000)
set(gca,'XTickLabel',0:1:30)%convert x-axis to the time domain 
xlabel('Time/s');
ylabel('Pressure New Code/mmHg');
plot(cuffP2);



%% smooth out signal only using smooth function

clear all
close all
a = load('002.TXT');

cuffP = [a(1,:),a(2,:)];
cuffP(1:23) = 0; % set first values to 0 rather than initial spike 

smooth = smooth(cuffP,'rloess')
plot(smooth');

%% smooth out signal by smoothing only the correct intervals of 50 samples at a time 

clear all
close all
a = load('Test3.TXT');

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

hold on;
set(gca,'XTick',0:100:3000)
set(gca,'XTickLabel',0:1:30)%convert x-axis to the time domain 
xlabel('Time/s');
ylabel('Pressure/mmHg');
plot(cuffP);




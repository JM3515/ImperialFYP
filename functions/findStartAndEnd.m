function [StartPosition, EndPosition] = findStartAndEnd(pressureFile)

cuffP = loadPresFile(pressureFile);  % function to load the contents of the pressure file to cuffP. 

figure;
hold on;
set(gca,'XTick',0:100:3000)
set(gca,'XTickLabel',0:1:30)%convert x-axis to the time domain 
title('Cuff Pressure');
xlabel('Time (seconds)');
ylabel('Pressure (mmHg)');
plot(cuffP);

[peak_max,locs_max] = findpeaks(cuffP); % find all the peaks of cuffP

a=0;
max_pressure=0;
for x = 1:1:length(locs_max) % for loop to find the value of the highest pressure within the cuff
   if x == 1
       max_pressure = cuffP(locs_max(x));
       
   else
       a = cuffP(locs_max(x));
       if a > max_pressure
           max_pressure;
           max_pressure = a;
       end
       
   end
end
rg = 0;
for v = 1500:1:length(cuffP)
    if cuffP(v) < 20 % less than 20mmhg
        rg = v; 
        break;
    end
end

re = min(find(cuffP==max_pressure)); % find the element location of the maximum pressure found within cuffP
StartPosition = (11 + (re/100)) * 2100; % set StartPosition to time delay calculated to cuff max pressure multiplied by 2100 so as to find the equivelent position within pulse_sound.
if rg == 0
    EndPosition = (41-(re/100)) * 2100; %  find EndPosition sample with the last element recorded by the cuff and multiply by 2100 to find equivelent sample point within pulse_sound.
else
    EndPosition = (11 + ((rg-re)/100) ) * 2100; % EndPosition is at the location of when the pressure is bellow 20 mmhg
end
end













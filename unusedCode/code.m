previous_code 


locs_max_found = locs_max;

w=1;
for v = 1 : 1 : (length(locs_max)-1)
    
    if v >=length(locs_max)
       break; 
    end
    
    if locs_max(v+1) - locs_max(v) < 800 
        window = pulse_sound_norm( locs_max(v) - 2*exact_peak_frequency_window_width  : locs_max(v) + 2*exact_peak_frequency_window_width );
        freq_v = findFreqSpecPeak(window)
    
        window = pulse_sound_norm( locs_max(v+1) - 2*exact_peak_frequency_window_width  : locs_max(v+1) + 2*exact_peak_frequency_window_width );
        freq_v1 = findFreqSpecPeak(window)
        
        if freq_v > freq_v1
            if isempty(freq_v) ==0
                frequencys_kept(w) = freq_v;
            end
            
            pulse_locations(w) = locs_max(v);
            locs_max(v+1) =[];
            w=w+1;
%             pulse_sound_norm( locs_max(v)-80: locs_max(v) + 80 ) = 0;
        else
            if isempty(freq_v1) ==0
                frequencys_kept(w) = freq_v1;
            end
            pulse_locations(w) = locs_max(v+1);
            locs_max(v) =[];
            w=w+1;
%             pulse_sound_norm( locs_max(v)-80: locs_max(v) + 80 ) = 0;

        end
    
%     if isempty() == 0
%         frequency_test(v) = x;
%         if x >20
% %             if x<52
%                 pulse_locations(w) = locs_max(v);
%                 w = w + 1;
% %             end
%         end
%                     
%     end    
%     
    end
end

figure;
ax1 = subplot(3,1,1);hold on;
plot(tsound, pulse_sound_norm_before);

ax2 = subplot(3,1,2); hold on; 
plot(tsound, pulse_sound);
plot(tsound(locs_max_found), pulse_sound(locs_max_found), 'x','linewidth',3, 'color','m');
for p = 1:1:length(tg)
    text(tsound(locs_max_found(p)), pulse_sound(locs_max_found(p))+0.05 , num2str(tg(p)) , 'FontSize' , 10 );
end

ax3 = subplot(3,1,3);hold on;
plot(tsound, pulse_sound_norm);
plot(tsound(pulse_locations),pulse_sound_norm(pulse_locations), 'x', 'linewidth', 3, 'color' , 'k');

linkaxes([ax1,ax2,ax3],'x');

disp('finished again');
return;



%%


% while marker == 1
%         
%         position
%         
%         for v = 1:1:length(Inflation)
%             
%             
%             if Inflation(v) >= (position +(inflation_gap_time-width_search_area)) && Inflation(v) <= (position +(inflation_gap_time+width_search_area))
%                 position = Inflation(v);
%                 found = 1; %next position already found 
%                 break;
%             else 
%                 found =0; % next position not found 
%             end
%         end
%         
%         
%         
%         
%         if found == 0
%             
%             
%             if position +(inflation_gap_time+width_search_area)  >= length(pulse_sound_norm) %no more signal left
%                 marker = 0;
%                 
%             elseif position +(inflation_gap_time+width_search_area)  <= length(pulse_sound_norm) %still room for another artefact
%                 
%                 window = pulse_sound_norm(position +(inflation_gap_time-width_search_area) : position +(inflation_gap_time+width_search_area));
%                 twindow = tsound(position +(inflation_gap_time-width_search_area) : position +(inflation_gap_time+width_search_area));
%                 
% %                 figure; hold on;
% %                 plot(twindow, window);
%                 
%                 
% %                 [peak_max,locs_max] = findpeaks(window);
% %                 idx_h = max(window(locs_max));
% %                 idx = min(find(window == idx_h));
%                 
%                 [peak_max,locs_max] = findpeaks(window, 'MinPeakHeight', 0.1);
%                 for i = 1:1:length(locs_max)
%                     
%                     window = pulse_sound_norm( position + inflation_gap_time - width_search_area + locs_max(i) - 7*exact_peak_frequency_window_width  : position + inflation_gap_time - width_search_area + locs_max(i) + 7*exact_peak_frequency_window_width );
%                 
%                     x = findFreqSpecPeak(window);
%                 
%                     if isempty(x) == 0
%                         frequency_test(r) = x;
%                     
%                         test_inflation(r) = position + inflation_gap_time-width_search_area + locs_max(i);
%                         r=r+1;
%                         if x > 13 %if peak has the right frequency
% %                             if x<17
%                                 j = length(Inflation);
%                                 Inflation(j+1) = position + inflation_gap_time-width_search_area + locs_max(i);
%                                 Inflation = sort(Inflation,'ascend');
%                                 idx = locs_max(i);
%                                 
% %                             elseif x> 102.438
% %                                 if x < 102.440
% %                                     j = length(Inflation);
% %                                     Inflation(j+1) = position + inflation_gap_time-width_search_area + locs_max(i);
% %                                     Inflation = sort(Inflation,'ascend');
%                                 end
% %                             end
%                         end
%                     end
%                 end
%                 
% %                
%                 position = position + inflation_gap_time-width_search_area + idx;
%             
%             
%             end
%         
%         checkAdd = 0;
%         found = 1;
%     end
% 
% 
% 
%%


% 
% 
% 
% cuffP = loadPresFile(pressureFile);
% 
% figure;
% hold on;
% set(gca,'XTick',0:100:3000)
% set(gca,'XTickLabel',0:1:30)%convert x-axis to the time domain 
% xlabel('Time/s');
% ylabel('Pressure/mmHg');
% plot(cuffP);
% return;
% width = 210;
% for v = 1:1:300
%     
%    [tsound_temp, pulse_sound_temp] = extractSectionSpecific(tsound,pulse_sound, v, width);
%    
%    [peak,locs] = findpeaks(pulse_sound_temp, 'MinPeakHeight', 0.1);
%    
%    z(v) = length(locs);
%     
% end 
% 
% maxlocation = max(z);
% idx = find(z == maxlocation);
% 
% 
%  for v = idx:1:300
%     if z(v) ==0
%        break;  
%     end
%  end
% 
% 
% StartPosition = (width/2) *(v-1);
% 
% EndPosition = StartPosition + 30*2100;
%%

% remove remaining faulse inflation points 
z = length(Inflation)-1;
for x = 1:1:z
 
    % some pulses are able to get through this because they are larger than
    %   inflation noise, this needs to be looked at 
    
    if Inflation(x+1) - Inflation(x) <= 1050 %half a sectond 
        a = pulse_sound_norm(Inflation(x+1));
        b = pulse_sound_norm(Inflation(x));
        if a > b 
            Inflation(x) = 1;
            height(x) = 0;
            z = z-1;
            x = x-1;
        else
            Inflation(x+1) = 1;
            height(x) = 0;
            z = z-1;
            x = x-1;
        end
    end
    
    
end

heightBefore = height;

idx = find(Inflation == 1);
Inflation(idx) = [];
idx = find(height == 0);
height(idx) = [];

height_mean = mean(height);
InflationIn = Inflation;

figure; 
ax1 = subplot(2,1,1);hold on;
title('Inflation found with frequency');
plot(tsound, pulse_sound);
plot(tsound(Inflation), pulse_sound(Inflation), 'x','linewidth',3, 'color','m');

ax2 = subplot(2,1,2);hold on;
plot(tsound, pulse_sound_norm);
plot(tsound(Inflation), pulse_sound_norm(Inflation), 'x','linewidth',3, 'color','m');

linkaxes([ax1, ax2],'x');





for i = 1:1:g
    
    y = locations_max(i);
    x = locations_min(i);
    
    
    
    
    
    if y < x % up then down 
        
        [q] = nextPeakBefore(y,x,tsound,pulse_sound);
        
        [w] = nextPeakAfter(y,x,tsound,pulse_sound);
        
        [r,e] = findZero(y,x,q,w,pulse_sound,tsound);
        
      
    elseif y > x % down then up 
        
        [q] = nextPeakBefore(y,x,tsound,pulse_sound);
        
        q
        
        [w] = nextPeakAfter(y,x,tsound,pulse_sound);
        w
        
        [r,e] = findZero(y,x,q,w,pulse_sound,tsound);
         
        
        
    end 
    locations_peak_before(i) = min(q);
    locations_peak_after(i) = min(w);
    location_zero_end(i) = min(e);
    location_zero_start(i) = min(r); %need min coz sometimes two values give same thing
    
    
    
    
end

figure; hold on; 
plot(tsound,pulse_sound, 'DisplayName','signal');
plot(tsound(locations_max),pulse_sound(locations_max),'x','linewidth',6, 'color','m', 'DisplayName','max');
plot(tsound(locations_min),pulse_sound(locations_min),'x','linewidth',6, 'color','c','DisplayName','min');
plot(tsound(locations_peak_before),pulse_sound(locations_peak_before),'x','linewidth',2, 'color','b','DisplayName','peak before');
plot(tsound(locations_peak_after),pulse_sound(locations_peak_after),'x','linewidth',2, 'color','r','DisplayName','peak after');
plot(tsound(location_zero_start),pulse_sound(location_zero_start),'x','linewidth',4, 'color','g','DisplayName','zero start');
plot(tsound( location_zero_end),pulse_sound( location_zero_end),'x','linewidth',4, 'color','k','DisplayName','zero end');
legend;

return; 

for f = 1:1:length(location_zero_end)
    [frequency] = findFreqSpecPeak(location_zero_start(f), location_zero_end(f), pulse_sound);
    frequencies(f) = frequency;
end


for u = 1:1:length(location_zero_end)
   
    distance(u) = (location_zero_end(u) -   location_zero_start(u))/2100;%distance in seconds
    
    
end

figure; hold on;

ax1 = subplot(2,1,1);
hold on;
plot(tsound,pulse_sound, 'DisplayName','signal');
plot(tsound(locations_max),pulse_sound(locations_max),'x','linewidth',6, 'color','m', 'DisplayName','max');
plot(tsound(locations_min),pulse_sound(locations_min),'x','linewidth',6, 'color','c','DisplayName','min');
plot(tsound(locations_peak_before),pulse_sound(locations_peak_before),'x','linewidth',2, 'color','b','DisplayName','peak before');
plot(tsound(locations_peak_after),pulse_sound(locations_peak_after),'x','linewidth',2, 'color','r','DisplayName','peak after');
plot(tsound(location_zero_start),pulse_sound(location_zero_start),'x','linewidth',4, 'color','g','DisplayName','zero start');
plot(tsound( location_zero_end),pulse_sound( location_zero_end),'x','linewidth',4, 'color','k','DisplayName','zero end');
legend;
for p = 1:1:length(frequencies)
    text(tsound(location_zero_start(p)), pulse_sound(location_zero_start(p)) , num2str(frequencies(p)) );
end
for p = 1:1:length(distance)
    text(tsound(location_zero_start(p)), pulse_sound(location_zero_start(p))-0.00003 , num2str(distance(p)) );
end

ax2 = subplot(2,1,2);

plot(tsound_original,pulse_sound_original*0.000001, 'DisplayName','signal');

linkaxes([ax1,ax2],'xy')
return;



% idx = find(locations_max == 0);
% locations_max(idx) = [];
% idx = find(locations_min == 0);
% locations_min(idx) = [];

%number of crossings

for v = 1:1:150
    
   [tsound_temp, pulse_sound_temp] = extractSectionSpecific(tsound,pulse_sound, v, 210);
   
   crossings = zeroCrossings(pulse_sound_temp);
    
   Xv(v) = crossings;
    
    
end 


%find minimum after the peak 
% [locations_max_min] = nextMin(locations_max,tsound,pulse_sound);
disp('3');

%find max of min peaks sections 
% [locations_min_max] = nextMin2(locations_min,tsound,pulse_sound);
disp('4');


    
   

% for i = 1:1:2
%     
%     y = locations_max(i);
%     x = locations_min(i);
%     
%     if y > x 
%        
%         
%         z = x - locations_min_max(i);
%         pulse_sound_temp = pulse_sound((x-z):x);
%         tsound_temp = tsound((x-z):x);
%     
%         dist = abs(pulse_sound_temp);
%         minDist = min(dist);
%         idx = find(dist == minDist);
%     
%         zero_location_start(i) = x - (z - idx);
% 
% 
%         w = locations_max_min(i) - y;
%         
%         pulse_sound_temp = pulse_sound(y:y+w);
%         tsound_temp = tsound(y:y+w);
%         
%         dist = abs(pulse_sound_temp);
%         minDist = min(dist);
%         idx = find(dist == minDist);
%         
%         zero_location_end(i) = y + idx;
%  
%         
%         
%         figure; hold on; 
%         plot(tsound,pulse_sound);
%         plot(tsound(zero_location_start(i)),pulse_sound(zero_location_start(i)),'x','linewidth',3, 'color','b');
%         plot(tsound( zero_location_end(i)),pulse_sound( zero_location_end(i)),'x','linewidth',3, 'color','b');
%         
%         
%         
%         
%     
%     elseif x>y
%         
%     
%         z =  y - locations_max_min(i)
%         pulse_sound_temp = pulse_sound((y-z):y);
%         tsound_temp = tsound((y-z):y);
%     
%         dist = abs(pulse_sound_temp)
%         minDist = min(dist)
%         idx = find(dist == minDist)
%         y - (z - idx)
%         return;
%         zero_location_start(i) = y - (z - idx);
%         
%         
%         
%         w = locations_min_max(i) - x;
%         
%         pulse_sound_temp = pulse_sound(x:x+w);
%         tsound_temp = tsound(x:x+w);
%         
%         dist = abs(pulse_sound_temp);
%         minDist = min(dist);
%         idx = find(dist == minDist);
%         
%         zero_location_end(i) = x + idx;
%         
%          figure; hold on; 
%         plot(tsound,pulse_sound);
%         plot(tsound(zero_location_start(i)),pulse_sound(zero_location_start(i)),'x','linewidth',3, 'color','b');
%         plot(tsound( zero_location_end(i)),pulse_sound( zero_location_end(i)),'x','linewidth',3, 'color','b');
%         
%         
%     end 
% 
%     
% 
% end

% locations_max_min = unique(locations_max_min);
% locations_min_max = unique(locations_min_max);
% locations_max = unique(locations_max);
% locations_min = unique(locations_min);


figure; hold on; 
plot(tsound,pulse_sound);
plot(tsound(locations_max),pulse_sound(locations_max),'x','linewidth',3, 'color','b');
plot(tsound(locations_max_min),pulse_sound(locations_max_min),'x','linewidth',3, 'color','r');
plot(tsound(locations_min),pulse_sound(locations_min),'x','linewidth',3, 'color','g');
plot(tsound(locations_min_max),pulse_sound(locations_min_max),'x','linewidth',3, 'color','k');
plot(tsound(zero_locations),pulse_sound(zero_locations),'x','linewidth',3, 'color','c');

return; 

frequencies = zeros(0,32);
s = min(length(locations_max),length(locations_min));
for q = 1:1:s
    start = min(locations_max(q),locations_min(q));
    finish = max(locations_max(q),locations_min(q));
    

    
    %find largest frequencies within the FFT 
    [f, P1] = fftFunction(pulse_sound(start:finish));
    
    [pks,locs] = findpeaks(P1);
    

    
%     figure;hold on;
%     plot(f, P1, 'linewidth', 1);
%     xlim([1, 70]);
%     title('FFT of ECG Signal');
%     xlabel('Frequency /Hz');
%     ylabel('Power');
%     legend('FFT');
%     set(gca, 'fontsize', 16);
%     grid on; grid minor; box on;
    
    %find the frequecy with the largest power within FFT
    len = length(P1);
    P2 = P1(2:len);
    w = max(P2);
    w = find(pks == w);
    
    w = f(locs(w)); % w is the largest frequency
    
    frequencies(q) = w;
    
    

end 



return;




for x = 1:1:(length(locations_max)-1)
  
    if locations_max(x) < locations_min(x)
        
        if locations_min(x) > 2102
            k = (locations_min(x)-(1*2102));
        else 
            k = 2;
        end
        
        for v = locations_max(x):-1:k
            pulse_sound(v)
            if pulse_sound(v) > 0
                if pulse_sound(v-1) < 0
                    zero_front(x) = v;
                    
                end
            elseif pulse_sound(v) < 0
                if pulse_sound(v-1) > 0
                    zero_back(x) = v;
                    
                end
            end
            
        
        end
        
        for v = locations_min(x):1:k
            if pulse_sound(v) > 0
                if pulse_sound(v-1) < 0
                    zero_front(x) = v;
                    
                end
            elseif pulse_sound(v) < 0
                if pulse_sound(v-1) > 0
                    zero_back(x) = v;
                    
                end
            end
            
        end
    
        
    elseif locations_max(x) > locations_min(x)
       
        if locations_min(x) > 2102
            k = (locations_min(x)-(1*2102));
        else 
            k = 2;
        end
        
        for v = locations_min(x):-1:k
            
           if pulse_sound(v) > 0
               v
               pulse_sound(v-1)
                if pulse_sound(v-1) < 0
                    zero_front(x) = v;
                    
                end
            elseif pulse_sound(v) < 0
                if pulse_sound(v-1) > 0
                    
                    zero_back(x) = v;
                    
                    
                end
            end
        
        end
        
        for v = locations_max(x):1:k
            if pulse_sound(v) > 0
                if pulse_sound(v-1) < 0
                    zero_front(x) = v;
                    
                    
                end
            elseif pulse_sound(v) < 0
                if pulse_sound(v-1) > 0
                    zero_back(x) = v;
                   
                end
            end
            
        end



    end
    
end

figure; hold on; 

% ax1 = subplot(2,1,1);
plot(tsound,pulse_sound);
title('5. Peaks Detected');
plot(tsound(locations_max),pulse_sound(locations_max),'x','linewidth',6, 'color','m');
plot(tsound(locations_min),pulse_sound(locations_min),'x','linewidth',6, 'color','k');
plot(tsound(zero_front),pulse_sound(zero_front),'x','linewidth',6, 'color','r');
plot(tsound(zero_back),pulse_sound(zero_back),'x','linewidth',6, 'color','b');


return;

















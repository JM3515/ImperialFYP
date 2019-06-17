clear all;
clc;


%global variables 

% accousticfile = 'signals/sound_deflation_10.log';
% pressureFile = 'signals/pressure_10.TXT';


accousticfile = 'signals/More/pressure_sound_deflation_2 (15).log';
pressureFile = 'signals/More/pressure_deflation_2 (15).TXT';







%10 we get all the artefacts

% 9 we get pulses mixed with artefacts because from the first round of
% artefact detection 

%7 doesnt work for artefacts

%6





manualInflationTime = (1000) * 2.1; % 1000 ms pressure cuff step deflation delay 

sectionWidth = 0.5*2100; %initial section width searching for peaks 

crossings_check_signal_width = 45; %width of the signal windows when searching for crossings 
Number_of_zero_crossings = 8; % heighest pulse crossings found was 7 

inflationFreq = 10;
exact_peak_frequency_window_width = 20;
exactFrequencyPeak = 35;

width_search_area = 450; %600 % for signal 7 use 600



[tsound, pulse_sound]= loadAccFile(accousticfile);

% figure; hold on;
% title('Plot of an example of an "accousticfile" after decoding its .log file');
% xlabel('tsound (seconds)');
% ylabel('pulse\_sound');
% plot(tsound,pulse_sound);


% pulse_sound = normalizeSignal(pulse_sound);

pulse_sound = pulse_sound - mean(pulse_sound);
pulse_sound = pulse_sound./max(abs(pulse_sound));

% figure; hold on;
% title('Normalized Signal'); 
% xlabel('tsound (seconds)');
% ylabel('pulse\_sound');
% plot(tsound,pulse_sound);       


[StartPosition, EndPosition] = findStartAndEnd(pressureFile);

pulse_sound = pulse_sound(StartPosition: EndPosition);
tsound = tsound(StartPosition: EndPosition);





% % 
% figure; hold on;
% % % ax1 = subplot(6,1,1);
% title('Extracted pulse\_sound when cuff is Deflating');
% xlabel('tsound (seconds)');
% ylabel('pulse\_sound');
% plot(tsound, pulse_sound);
% 
% 
% return;




%process signal for peak detection 
%[pulse_sound] = removeInflationNoise(tsound , pulse_sound);

pulse_sound_norm = pulse_sound;
pulse_sound_start= pulse_sound;

pulse_sound = lowPassFIR(pulse_sound);
% 
% figure; 
% ax1= subplot(2,1,1);hold on;
% title('Original pulse\_sound without filtering, now assigned to pulse\_sound\_norm');
% xlabel('tsound (seconds)');
% ylabel('pulse\_sound\_norm');
% plot(tsound, pulse_sound_norm);
% 
% 
% ax2 = subplot(2,1,2);hold on;
% title('Pulse\_sound after low pass filter');
% xlabel('tsound (seconds)');
% ylabel('pulse\_sound');
% plot(tsound,pulse_sound);
% 
% linkaxes([ax1,ax2],'x');
% return; 




disp('start');

%find max peaks of each sections
[locations_max] = peaksSection(tsound , pulse_sound,StartPosition,EndPosition,sectionWidth);

%find min peaks of sections 
[locations_min] = peaksSection(tsound , -pulse_sound,StartPosition,EndPosition,sectionWidth);

% remove any repeated peak locations found
locations_max = unique(locations_max); 
locations_min = unique(locations_min);



% 
% figure;
% hold on;

% ax3 = subplot(9,1,3);hold on;
% % title('5. Peaks Detected');
% plot(tsound(locations_max),pulse_sound(locations_max),'x','linewidth',3, 'color','m');
% plot(tsound(locations_min),pulse_sound(locations_min),'x','linewidth',3, 'color','k');
% plot(tsound,pulse_sound);




% find zero location to the right of maximum points 
for v = 1:1:length(locations_max)
    v1 =v
    notZero = 1; 
    
    location = locations_max(v);
    
    while notZero == 1
        
        if pulse_sound(location) > 0 
            if  location == max(locations_max)
                notZero = 0;
            end
            if pulse_sound(location+1) < 0 
                zero_Max_Right(v) = location;
                notZero = 0;
            end
        end
    
        location = location+1;
        
    end
    
end
% find zero location to the left of maximum points 
for v = 1:1:length(locations_max)
    v2 =v
    notZero = 1; 
    
    location = locations_max(v);
    
    while notZero == 1
        
        if pulse_sound(location) > 0
            if  location == 1
                zero_Max_Left(v) = 1;
                notZero = 0;
            elseif pulse_sound(location-1) < 0 
                zero_Max_Left(v) = location;
                notZero = 0;
            end
        end
    
        location = location-1;
        
    end
    
end
% find zero location to the right of minimum points 
for v = 1:1:length(locations_min)
    v3 =v
    notZero = 1; 
    
    location = locations_min(v);
    
    while notZero == 1
        
        if pulse_sound(location) < 0 
            if  location == max(locations_min)
                notZero = 0;
            end
            if pulse_sound(location+1) > 0 
                zero_Min_Right(v) = location;
                notZero = 0;
            end
        end
    
        location = location+1;
        
    end
    
end
% find zero location to the left of minimum points 
for v = 1:1:length(locations_min)
    v4 =v
    notZero = 1; 
    
    location = locations_min(v);
    
    while notZero == 1
        
        if pulse_sound(location) < 0 
            if location ==  1
                zero_Min_Left(v) = 1;
                notZero=0;
            elseif pulse_sound(location-1) > 0 
                zero_Min_Left(v) = location;
                notZero = 0;
            end
            
                
        end
    
        location = location-1;
        
    end
    
end



% ax4 = subplot(9,1,4); hold on;
% 
% plot(tsound(zero_Max_Right),pulse_sound(zero_Max_Right),'x','linewidth',3, 'color','y');
% plot(tsound(zero_Max_Left),pulse_sound(zero_Max_Left),'x','linewidth',3, 'color','g');
% plot(tsound(locations_max),pulse_sound(locations_max),'x','linewidth',3, 'color','m');
% plot(tsound,pulse_sound);


% ax5 = subplot(9,1,5);hold on;
% 
% plot(tsound(zero_Min_Right),pulse_sound(zero_Min_Right),'x','linewidth',3, 'color','b');
% plot(tsound(zero_Min_Left),pulse_sound(zero_Min_Left),'x','linewidth',3, 'color','r');
% plot(tsound(locations_min),pulse_sound(locations_min),'x','linewidth',3, 'color','k');
% plot(tsound,pulse_sound);

z = length(locations_max);

i = 1;

% 1 on both sides using max and filtered signal 
for v = 1:1:z

distance = min(abs(locations_max(v) - locations_min));

k = find (locations_min == (locations_max(v)-distance));
if isempty(k) == 1
    k = find (locations_min == (locations_max(v)+distance));
end 

h = locations_max(v) - locations_min(k);

for b = 1:1:8
    frequency(b) = 0;
end

% s = locations_max(v)/2100 +12.39
% t = locations_min(k)/2100 +12.39

%if h is negative so max is before min
if h < 0
    
    if v <= length(zero_Max_Left) && v <= length(zero_Max_Right) 
        % comparison to k min
        
        fr = min( zero_Max_Left(v) , zero_Max_Right(v) );
        ba = max( zero_Max_Left(v) , zero_Max_Right(v) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(1) = x;
            end
        end
    end 
    
    
    if v <= length(zero_Max_Left) && k <= length(zero_Min_Right) 
        % comparison to k min
        zero_Max_Left(v)
        zero_Min_Right(k)
        fr = min( zero_Max_Left(v) , zero_Min_Right(k) );
        ba = max( zero_Max_Left(v) , zero_Min_Right(k) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(2) = x;
            end
        end
    end 
    
    if v <= length(zero_Max_Left) && k+1 <= length(zero_Min_Right)
        %comparison to k+1 min 
        fr = min( zero_Max_Left(v) , zero_Min_Right(k+1) );
        ba = max( zero_Max_Left(v) , zero_Min_Right(k+1) );
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_max1(3) = x;
            end
        end
    end
    
    if k>2 && v <= length(zero_Max_Right) && k-1 <= length(zero_Min_Left)
        
        %comparisonto k-1 min 
        fr = min( zero_Min_Left(k-1) , zero_Max_Right(v) );
        ba = max( zero_Min_Left(k-1) , zero_Max_Right(v) );
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(4) = x;
            end
        end
    end
    if k>2 && v <= length(zero_Max_Right) && k-2 <= length(zero_Min_Left) 
        
        %comparison to k-2 min
        fr = min(zero_Min_Left(k-2) , zero_Max_Right(v));
        ba = max(zero_Min_Left(k-2) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_max1(5) = x;
            end
        end
    end
    if v+1 <= length(zero_Max_Right) && v <= length(zero_Max_Left)
        %comparison to v+1 max
        fr = min(zero_Max_Left(v) , zero_Max_Right(v+1));
        ba = max(zero_Max_Left(v) , zero_Max_Right(v+1)); 
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(6) = x;
            end
        end
    end
    if v <= (length(zero_Max_Right)-2) && v <= length(zero_Max_Left)
        %comparison to v+2 max
        
        fr = min(zero_Max_Left(v) , zero_Max_Right(v+2));
        ba = max(zero_Max_Left(v) , zero_Max_Right(v+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
            
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_max1(7) = x;
            end
        end
    end 
    
    if v >1 && v <= length(zero_Max_Right) && v-1 <= length(zero_Max_Left)
        
        %comparison to v-1 max
        fr = min(zero_Max_Left(v-1) , zero_Max_Right(v));
        ba = max(zero_Max_Left(v-1) , zero_Max_Right(v)); 
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(8) = x;
            end
        end
    end
    if v>2 && v <= length(zero_Max_Right) && v-2 <= length(zero_Max_Left)
        
        %comparison to v-2 max
        fr = min(zero_Max_Left(v-2) , zero_Max_Right(v));
        ba = max(zero_Max_Left(v-2) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_max1(9) = x;
            end
        end
    end
end



if h > 0 
    
    if v <= length(zero_Max_Left) && v <= length(zero_Max_Right) 
        % comparison to k min
        
        fr = min( zero_Max_Left(v) , zero_Max_Right(v) );
        ba = max( zero_Max_Left(v) , zero_Max_Right(v) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(1) = x;
            end
        end
    end 
    
    if k <= length(zero_Min_Left) && v <= length(zero_Max_Right)
        %comparison to k min
        fr = min( zero_Min_Left(k) , zero_Max_Right(v) );
        ba = max( zero_Min_Left(k) , zero_Max_Right(v) );
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(2) = x;
            end
        end
    end
    
    if k > 1 && v <= length(zero_Max_Right) && k-1 <= length(zero_Min_Left)
        %comparison to k-1 min 
        fr = min( zero_Min_Left(k-1) , zero_Max_Right(v));
        ba = max( zero_Min_Left(k-1) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(3) = x;
            end
        end
    end
    
    if k+1 <= length(zero_Min_Right) && v <= length(zero_Max_Left)
        %comparison to k+1 min
        fr = min(zero_Max_Left(v) , zero_Min_Right(k+1));
        ba = max(zero_Max_Left(v) , zero_Min_Right(k+1));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_max1(4) = x;
            end
        end
    end
    
    if k+2 <= length(zero_Min_Right) && v <= length(zero_Max_Left)
        %comparison to k+2 min
        fr = min(zero_Max_Left(v) , zero_Min_Right(k+2));
        ba = max(zero_Max_Left(v) , zero_Min_Right(k+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_max1(5) = x;
            end
        end
    end
    
    if v <= length(zero_Max_Left) && v+1 <= length(zero_Max_Right)
        %comparison to v+1 max
        fr = min(zero_Max_Left(v) , zero_Max_Right(v+1));
        ba = max(zero_Max_Left(v) , zero_Max_Right(v+1));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(6) = x;
            end
        end
    end
    
    if v <= length(zero_Max_Left) && v+2 <= length(zero_Max_Right)
        %comparison to v+2 max
        fr = min(zero_Max_Left(v) , zero_Max_Right(v+2));
        ba = max(zero_Max_Left(v) , zero_Max_Right(v+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_max1(7) = x;
            end
        end
    end
    
    if v>1 && v-1 <= length(zero_Min_Left) && v <= length(zero_Max_Right)
        %comparison to v-1 max
        fr = min(zero_Min_Left(v-1) , zero_Max_Right(v));
        ba = max(zero_Min_Left(v-1) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(8) = x;
            end
        end
    end
    
    if v>2 && v-2 <= length(zero_Min_Left) && v <= length(zero_Max_Right) 
        %comparison to v-2 max
        fr = min(zero_Min_Left(v-2) , zero_Max_Right(v));
        ba = max(zero_Min_Left(v-2) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_max1(9) = x;
            end
        end
    end
end

average_fMax1_filt(v) = mean(frequency_max1); 

end
    
% 1 on both sides using max and using un-filtered signal
for v = 1:1:z

distance = min(abs(locations_max(v) - locations_min));

k = find (locations_min == (locations_max(v)-distance));
if isempty(k) == 1
    k = find (locations_min == (locations_max(v)+distance));
end 

h = locations_max(v) - locations_min(k);

for b = 1:1:8
    frequency(b) = 0;
end

% s = locations_max(v)/2100 +12.39
% t = locations_min(k)/2100 +12.39

%if h is negative so max is before min
if h < 0
    
    if v <= length(zero_Max_Left) && v <= length(zero_Max_Right) 
        % comparison to k min
        
        fr = min( zero_Max_Left(v) , zero_Max_Right(v) );
        ba = max( zero_Max_Left(v) , zero_Max_Right(v) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(1) = x;
            end
        end
    end 
    
    
    if v <= length(zero_Max_Left) && k <= length(zero_Min_Right) 
        % comparison to k min
        zero_Max_Left(v)
        zero_Min_Right(k)
        fr = min( zero_Max_Left(v) , zero_Min_Right(k) );
        ba = max( zero_Max_Left(v) , zero_Min_Right(k) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(2) = x;
            end
        end
    end 
    
    if v <= length(zero_Max_Left) && k+1 <= length(zero_Min_Right)
        %comparison to k+1 min 
        fr = min( zero_Max_Left(v) , zero_Min_Right(k+1) );
        ba = max( zero_Max_Left(v) , zero_Min_Right(k+1) );
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_max1(3) = x;
            end
        end
    end
    
    if k>2 && v <= length(zero_Max_Right) && k-1 <= length(zero_Min_Left)
        
        %comparisonto k-1 min 
        fr = min( zero_Min_Left(k-1) , zero_Max_Right(v) );
        ba = max( zero_Min_Left(k-1) , zero_Max_Right(v) );
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(4) = x;
            end
        end
    end
    if k>2 && v <= length(zero_Max_Right) && k-2 <= length(zero_Min_Left) 
        
        %comparison to k-2 min
        fr = min(zero_Min_Left(k-2) , zero_Max_Right(v));
        ba = max(zero_Min_Left(k-2) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_max1(5) = x;
            end
        end
    end
    if v+1 <= length(zero_Max_Right) && v <= length(zero_Max_Left)
        %comparison to v+1 max
        fr = min(zero_Max_Left(v) , zero_Max_Right(v+1));
        ba = max(zero_Max_Left(v) , zero_Max_Right(v+1)); 
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(6) = x;
            end
        end
    end
    if v <= (length(zero_Max_Right)-2) && v <= length(zero_Max_Left)
        %comparison to v+2 max
        
        fr = min(zero_Max_Left(v) , zero_Max_Right(v+2));
        ba = max(zero_Max_Left(v) , zero_Max_Right(v+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
            
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_max1(7) = x;
            end
        end
    end 
    
    if v >1 && v <= length(zero_Max_Right) && v-1 <= length(zero_Max_Left)
        
        %comparison to v-1 max
        fr = min(zero_Max_Left(v-1) , zero_Max_Right(v));
        ba = max(zero_Max_Left(v-1) , zero_Max_Right(v)); 
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(8) = x;
            end
        end
    end
    if v>2 && v <= length(zero_Max_Right) && v-2 <= length(zero_Max_Left)
        
        %comparison to v-2 max
        fr = min(zero_Max_Left(v-2) , zero_Max_Right(v));
        ba = max(zero_Max_Left(v-2) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_max1(9) = x;
            end
        end
    end
end



if h > 0 
    
    if v <= length(zero_Max_Left) && v <= length(zero_Max_Right) 
        % comparison to k min
        
        fr = min( zero_Max_Left(v) , zero_Max_Right(v) );
        ba = max( zero_Max_Left(v) , zero_Max_Right(v) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = min(findFreqSpecPeak(pulse_sound_temp));
            if isempty(x) == 0
                frequency_max1(1) = x;
            end
        end
    end 
    
    if k <= length(zero_Min_Left) && v <= length(zero_Max_Right)
        %comparison to k min
        fr = min( zero_Min_Left(k) , zero_Max_Right(v) );
        ba = max( zero_Min_Left(k) , zero_Max_Right(v) );
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(2) = x;
            end
        end
    end
    
    if k > 1 && v <= length(zero_Max_Right) && k-1 <= length(zero_Min_Left)
        %comparison to k-1 min 
        fr = min( zero_Min_Left(k-1) , zero_Max_Right(v));
        ba = max( zero_Min_Left(k-1) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(3) = x;
            end
        end
    end
    
    if k+1 < length(zero_Min_Right) && v <= length(zero_Max_Left)
        %comparison to k+1 min
        fr = min(zero_Max_Left(v) , zero_Min_Right(k+1));
        ba = max(zero_Max_Left(v) , zero_Min_Right(k+1));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_max1(4) = x;
            end
        end
    end
    
    if k+2 < length(zero_Min_Right) && v <= length(zero_Max_Left)
        %comparison to k+2 min
        fr = min(zero_Max_Left(v) , zero_Min_Right(k+2));
        ba = max(zero_Max_Left(v) , zero_Min_Right(k+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_max1(5) = x;
            end
        end
    end
    
    if v <= length(zero_Max_Left) && v+1 <= length(zero_Max_Right)
        %comparison to v+1 max
        fr = min(zero_Max_Left(v) , zero_Max_Right(v+1));
        ba = max(zero_Max_Left(v) , zero_Max_Right(v+1));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(6) = x;
            end
        end
    end
    
    if v < length(zero_Max_Left) && v+2 <= length(zero_Max_Right)
        %comparison to v+2 max
        fr = min(zero_Max_Left(v) , zero_Max_Right(v+2));
        ba = max(zero_Max_Left(v) , zero_Max_Right(v+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_max1(7) = x;
            end
        end
    end
    
    if v>1 && v <= length(zero_Min_Left) && v <= length(zero_Max_Right)
        %comparison to v-1 max
        fr = min(zero_Min_Left(v-1) , zero_Max_Right(v));
        ba = max(zero_Min_Left(v-1) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max1(8) = x;
            end
        end
    end
    
    if v>2 && v-2 <= length(zero_Min_Left) && v <= length(zero_Max_Right) 
        %comparison to v-2 max
        fr = min(zero_Min_Left(v-2) , zero_Max_Right(v));
        ba = max(zero_Min_Left(v-2) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_max1(9) = x;
            end
        end
    end
end

average_fMax1_unfilt(v) = mean(frequency_max1); 

if mean(frequency_max1) > inflationFreq
    checkForInflation(i) = locations_max(v);
    checkForInflation_freq(i) = mean(frequency_max1);
    i = i+1;
end
    
    
end


% 2 on both sides using max and filtered signal
for v = 1:1:z

distance = min(abs(locations_max(v) - locations_min));

k = find (locations_min == (locations_max(v)-distance));
if isempty(k) == 1
    k = find (locations_min == (locations_max(v)+distance));
end 

h = locations_max(v) - locations_min(k);

for b = 1:1:8
    frequency(b) = 0;
end

% s = locations_max(v)/2100 +12.39
% t = locations_min(k)/2100 +12.39

%if h is negative so max is before min
if h < 0
    
    if v <= length(zero_Max_Left) && v <= length(zero_Max_Right) 
        % comparison to k min
        
        fr = min( zero_Max_Left(v) , zero_Max_Right(v) );
        ba = max( zero_Max_Left(v) , zero_Max_Right(v) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(1) = x;
            end
        end
    end 
    
    
    if v <= length(zero_Max_Left) && k <= length(zero_Min_Right) 
        % comparison to k min
        zero_Max_Left(v)
        zero_Min_Right(k)
        fr = min( zero_Max_Left(v) , zero_Min_Right(k) );
        ba = max( zero_Max_Left(v) , zero_Min_Right(k) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(2) = x;
            end
        end
    end 
    
    if v <= length(zero_Max_Left) && k+1 <= length(zero_Min_Right)
        %comparison to k+1 min 
        fr = min( zero_Max_Left(v) , zero_Min_Right(k+1) );
        ba = max( zero_Max_Left(v) , zero_Min_Right(k+1) );
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(3) = x;
            end
        end
    end
    
    if k>2 && v <= length(zero_Max_Right) && k-1 <= length(zero_Min_Left)
        
        %comparisonto k-1 min 
        fr = min( zero_Min_Left(k-1) , zero_Max_Right(v) );
        ba = max( zero_Min_Left(k-1) , zero_Max_Right(v) );
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(4) = x;
            end
        end
    end
    if k>2 && v <= length(zero_Max_Right) && k-2 <= length(zero_Min_Left) 
        
        %comparison to k-2 min
        fr = min(zero_Min_Left(k-2) , zero_Max_Right(v));
        ba = max(zero_Min_Left(k-2) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(5) = x;
            end
        end
    end
    if v+1 <= length(zero_Max_Right) && v <= length(zero_Max_Left)
        %comparison to v+1 max
        fr = min(zero_Max_Left(v) , zero_Max_Right(v+1));
        ba = max(zero_Max_Left(v) , zero_Max_Right(v+1)); 
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(6) = x;
            end
        end
    end
    if v <= (length(zero_Max_Right)-2) && v <= length(zero_Max_Left)
        %comparison to v+2 max
        
        fr = min(zero_Max_Left(v) , zero_Max_Right(v+2));
        ba = max(zero_Max_Left(v) , zero_Max_Right(v+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
            
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(7) = x;
            end
        end
    end 
    
    if v >1 && v <= length(zero_Max_Right) && v-1 <= length(zero_Max_Left)
        
        %comparison to v-1 max
        fr = min(zero_Max_Left(v-1) , zero_Max_Right(v));
        ba = max(zero_Max_Left(v-1) , zero_Max_Right(v)); 
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(8) = x;
            end
        end
    end
    if v>2 && v <= length(zero_Max_Right) && v-2 <= length(zero_Max_Left)
        
        %comparison to v-2 max
        fr = min(zero_Max_Left(v-2) , zero_Max_Right(v));
        ba = max(zero_Max_Left(v-2) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(9) = x;
            end
        end
    end
end



if h > 0 
    
    if v <= length(zero_Max_Left) && v <= length(zero_Max_Right) 
        % comparison to k min
        
        fr = min( zero_Max_Left(v) , zero_Max_Right(v) );
        ba = max( zero_Max_Left(v) , zero_Max_Right(v) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(1) = x;
            end
        end
    end 
    
    if k <= length(zero_Min_Left) && v <= length(zero_Max_Right)
        %comparison to k min
        fr = min( zero_Min_Left(k) , zero_Max_Right(v) );
        ba = max( zero_Min_Left(k) , zero_Max_Right(v) );
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(2) = x;
            end
        end
    end
    
    if k > 1 && v <= length(zero_Max_Right) && k-1 <= length(zero_Min_Left)
        %comparison to k-1 min 
        fr = min( zero_Min_Left(k-1) , zero_Max_Right(v));
        ba = max( zero_Min_Left(k-1) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(3) = x;
            end
        end
    end
    
    if k+1 <= length(zero_Min_Right) && v <= length(zero_Max_Left)
        %comparison to k+1 min
        fr = min(zero_Max_Left(v) , zero_Min_Right(k+1));
        ba = max(zero_Max_Left(v) , zero_Min_Right(k+1));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(4) = x;
            end
        end
    end
    
    if k+2 <= length(zero_Min_Right) && v <= length(zero_Max_Left)
        %comparison to k+2 min
        fr = min(zero_Max_Left(v) , zero_Min_Right(k+2));
        ba = max(zero_Max_Left(v) , zero_Min_Right(k+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(5) = x;
            end
        end
    end
    
    if v <= length(zero_Max_Left) && v+1 <= length(zero_Max_Right)
        %comparison to v+1 max
        fr = min(zero_Max_Left(v) , zero_Max_Right(v+1));
        ba = max(zero_Max_Left(v) , zero_Max_Right(v+1));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(6) = x;
            end
        end
    end
    
    if v <= length(zero_Max_Left) && v+2 <= length(zero_Max_Right)
        %comparison to v+2 max
        fr = min(zero_Max_Left(v) , zero_Max_Right(v+2));
        ba = max(zero_Max_Left(v) , zero_Max_Right(v+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(7) = x;
            end
        end
    end
    
    if v>1 && v <= length(zero_Min_Left) && v <= length(zero_Max_Right)
        %comparison to v-1 max
        fr = min(zero_Min_Left(v-1) , zero_Max_Right(v));
        ba = max(zero_Min_Left(v-1) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(8) = x;
            end
        end
    end
    
    if v>2 && v-2 <= length(zero_Min_Left) && v <= length(zero_Max_Right) 
        %comparison to v-2 max
        fr = min(zero_Min_Left(v-2) , zero_Max_Right(v));
        ba = max(zero_Min_Left(v-2) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(9) = x;
            end
        end
    end
end

average_fMax2_filt(v) = mean(frequency_max2); 

end

% 2 on both sides using max and un-filtered signal
for v = 1:1:z

distance = min(abs(locations_max(v) - locations_min));

k = find (locations_min == (locations_max(v)-distance));
if isempty(k) == 1
    k = find (locations_min == (locations_max(v)+distance));
end 

h = locations_max(v) - locations_min(k);

for b = 1:1:8
    frequency(b) = 0;
end

% s = locations_max(v)/2100 +12.39
% t = locations_min(k)/2100 +12.39

%if h is negative so max is before min
if h < 0
    
    if v <= length(zero_Max_Left) && v <= length(zero_Max_Right) 
        % comparison to k min
        
        fr = min( zero_Max_Left(v) , zero_Max_Right(v) );
        ba = max( zero_Max_Left(v) , zero_Max_Right(v) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(1) = x;
            end
        end
    end 
    
    
    if v <= length(zero_Max_Left) && k <= length(zero_Min_Right) 
        % comparison to k min
        zero_Max_Left(v)
        zero_Min_Right(k)
        fr = min( zero_Max_Left(v) , zero_Min_Right(k) );
        ba = max( zero_Max_Left(v) , zero_Min_Right(k) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(2) = x;
            end
        end
    end 
    
    if v <= length(zero_Max_Left) && k+1 <= length(zero_Min_Right)
        %comparison to k+1 min 
        fr = min( zero_Max_Left(v) , zero_Min_Right(k+1) );
        ba = max( zero_Max_Left(v) , zero_Min_Right(k+1) );
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(3) = x;
            end
        end
    end
    
    if k>2 && v <= length(zero_Max_Right) && k-1 <= length(zero_Min_Left)
        
        %comparisonto k-1 min 
        fr = min( zero_Min_Left(k-1) , zero_Max_Right(v) );
        ba = max( zero_Min_Left(k-1) , zero_Max_Right(v) );
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(4) = x;
            end
        end
    end
    if k>2 && v <= length(zero_Max_Right) && k-2 <= length(zero_Min_Left) 
        
        %comparison to k-2 min
        fr = min(zero_Min_Left(k-2) , zero_Max_Right(v));
        ba = max(zero_Min_Left(k-2) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(5) = x;
            end
        end
    end
    if v+1 <= length(zero_Max_Right) && v <= length(zero_Max_Left)
        %comparison to v+1 max
        fr = min(zero_Max_Left(v) , zero_Max_Right(v+1));
        ba = max(zero_Max_Left(v) , zero_Max_Right(v+1)); 
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(6) = x;
            end
        end
    end
    if v <= (length(zero_Max_Right)-2) && v <= length(zero_Max_Left)
        %comparison to v+2 max
        
        fr = min(zero_Max_Left(v) , zero_Max_Right(v+2));
        ba = max(zero_Max_Left(v) , zero_Max_Right(v+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
            
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(7) = x;
            end
        end
    end 
    
    if v >1 && v <= length(zero_Max_Right) && v-1 <= length(zero_Max_Left)
        
        %comparison to v-1 max
        fr = min(zero_Max_Left(v-1) , zero_Max_Right(v));
        ba = max(zero_Max_Left(v-1) , zero_Max_Right(v)); 
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(8) = x;
            end
        end
    end
    if v>2 && v <= length(zero_Max_Right) && v-2 <= length(zero_Max_Left)
        
        %comparison to v-2 max
        fr = min(zero_Max_Left(v-2) , zero_Max_Right(v));
        ba = max(zero_Max_Left(v-2) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(9) = x;
            end
        end
    end
end



if h > 0 
    
    if v <= length(zero_Max_Left) && v <= length(zero_Max_Right) 
        % comparison to k min
        
        fr = min( zero_Max_Left(v) , zero_Max_Right(v) );
        ba = max( zero_Max_Left(v) , zero_Max_Right(v) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = min(findFreqSpecPeak(pulse_sound_temp));
            if isempty(x) == 0
                frequency_max2(1) = x;
            end
        end
    end 
    
    if k <= length(zero_Min_Left) && v <= length(zero_Max_Right)
        %comparison to k min
        fr = min( zero_Min_Left(k) , zero_Max_Right(v) );
        ba = max( zero_Min_Left(k) , zero_Max_Right(v) );
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(2) = x;
            end
        end
    end
    
    if k > 1 && v <= length(zero_Max_Right) && k-1 <= length(zero_Min_Left)
        %comparison to k-1 min 
        fr = min( zero_Min_Left(k-1) , zero_Max_Right(v));
        ba = max( zero_Min_Left(k-1) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(3) = x;
            end
        end
    end
    
    if k+1 <= length(zero_Min_Right) && v <= length(zero_Max_Left)
        %comparison to k+1 min
        fr = min(zero_Max_Left(v) , zero_Min_Right(k+1));
        ba = max(zero_Max_Left(v) , zero_Min_Right(k+1));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(4) = x;
            end
        end
    end
    
    if k+2 <= length(zero_Min_Right) && v <= length(zero_Max_Left)
        %comparison to k+2 min
        fr = min(zero_Max_Left(v) , zero_Min_Right(k+2));
        ba = max(zero_Max_Left(v) , zero_Min_Right(k+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(5) = x;
            end
        end
    end
    
    if v <= length(zero_Max_Left) && v+1 <= length(zero_Max_Right)
        %comparison to v+1 max
        fr = min(zero_Max_Left(v) , zero_Max_Right(v+1));
        ba = max(zero_Max_Left(v) , zero_Max_Right(v+1));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(6) = x;
            end
        end
    end
    
    if v <= length(zero_Max_Left) && v+2 <= length(zero_Max_Right)
        %comparison to v+2 max
        fr = min(zero_Max_Left(v) , zero_Max_Right(v+2));
        ba = max(zero_Max_Left(v) , zero_Max_Right(v+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(7) = x;
            end
        end
    end
    
    if v>1 && v <= length(zero_Min_Left) && v <= length(zero_Max_Right)
        %comparison to v-1 max
        fr = min(zero_Min_Left(v-1) , zero_Max_Right(v));
        ba = max(zero_Min_Left(v-1) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(8) = x;
            end
        end
    end
    
    if v>2 && v-2 <= length(zero_Min_Left) && v <= length(zero_Max_Right) 
        %comparison to v-2 max
        fr = min(zero_Min_Left(v-2) , zero_Max_Right(v));
        ba = max(zero_Min_Left(v-2) , zero_Max_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_max2(9) = x;
            end
        end
    end
end

average_fMax2_unfilt(v) = mean(frequency_max2); 

if mean(frequency_max2) > inflationFreq
    checkForInflation(i) = locations_max(v);
    checkForInflation_freq(i) = mean(frequency_max2);
    i = i+1;
end

end


z = length(locations_min);

% 1 on both sides using min and filtered signal 
for v = 1:1:z

% finding the closets max location to the v'th min location
distance = min(abs(locations_min(v) - locations_max));

k = find (locations_max == (locations_min(v)-distance));
if isempty(k) == 1
    k = find (locations_max == (locations_min(v)+distance));
end 



h = locations_min(v) - locations_max(k);

for b = 1:1:8
    frequency(b) = 0;
end

% s = locations_max(v)/2100 +12.39
% t = locations_min(k)/2100 +12.39

%if h is negative so max is before min
if h < 0
    
    if v <= length(zero_Min_Left) && v <= length(zero_Min_Right) 
        % comparison to v min
        
        fr = min( zero_Min_Left(v) , zero_Min_Right(v) );
        ba = max( zero_Min_Left(v) , zero_Min_Right(v) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(1) = x;
            end
        end
    end 
    
    
    if v <= length(zero_Min_Left) && k <= length(zero_Max_Right) 
        % comparison to k max
    
        fr = min( zero_Min_Left(v) , zero_Max_Right(k) );
        ba = max( zero_Min_Left(v) , zero_Max_Right(k) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(2) = x;
            end
        end
    end 
    
    if v <= length(zero_Min_Left) && k+1 <= length(zero_Max_Right)
        %comparison to k+1 max 
        fr = min( zero_Min_Left(v) , zero_Max_Right(k+1) );
        ba = max( zero_Min_Left(v) , zero_Max_Right(k+1) );
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_min1(3) = x;
            end
        end
    end
    
    if k>2 && v <= length(zero_Min_Right) && k-1 <= length(zero_Max_Left)
        
        %comparisonto k-1 min 
        fr = min( zero_Max_Left(k-1) , zero_Min_Right(v) );
        ba = max( zero_Max_Left(k-1) , zero_Min_Right(v) );
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(4) = x;
            end
        end
    end
    
    if k>2 && v <= length(zero_Min_Right) && k-2 <= length(zero_Max_Left) 
        
        %comparison to k-2 min
        fr = min(zero_Max_Left(k-2) , zero_Min_Right(v));
        ba = max(zero_Max_Left(k-2) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_min1(5) = x;
            end
        end
    end
    if v+1 <= length(zero_Min_Right) && v <= length(zero_Min_Left)
        %comparison to v+1 max
        fr = min(zero_Min_Left(v) , zero_Min_Right(v+1));
        ba = max(zero_Min_Left(v) , zero_Min_Right(v+1)); 
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(6) = x;
            end
        end
    end
    if v <= (length(zero_Min_Right)-2) && v <= length(zero_Min_Left)
        %comparison to v+2 max
        
        fr = min(zero_Min_Left(v) , zero_Min_Right(v+2));
        ba = max(zero_Min_Left(v) , zero_Min_Right(v+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
            
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_min1(7) = x;
            end
        end
    end 
    
    if v >1 && v <= length(zero_Min_Right) && v-1 <= length(zero_Min_Left)
        
        %comparison to v-1 max
        fr = min(zero_Min_Left(v-1) , zero_Min_Right(v));
        ba = max(zero_Min_Left(v-1) , zero_Min_Right(v)); 
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(8) = x;
            end
        end
    end
    if v>2 && v <= length(zero_Min_Right) && v-2 <= length(zero_Min_Left)
        
        %comparison to v-2 max
        fr = min(zero_Min_Left(v-2) , zero_Min_Right(v));
        ba = max(zero_Min_Left(v-2) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_min1(9) = x;
            end
        end
    end
end



if h > 0 
    
    if v <= length(zero_Min_Left) && v <= length(zero_Min_Right) 
        % comparison to k min
        
        fr = min( zero_Min_Left(v) , zero_Min_Right(v) );
        ba = max( zero_Min_Left(v) , zero_Min_Right(v) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(1) = x;
            end
        end
    end 
    
    if k <= length(zero_Max_Left) && v <= length(zero_Min_Right)
        %comparison to k min
        fr = min( zero_Max_Left(k) , zero_Min_Right(v) );
        ba = max( zero_Max_Left(k) , zero_Min_Right(v) );
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(2) = x;
            end
        end
    end
    
    if k > 1 && v <= length(zero_Min_Right) && k-1 <= length(zero_Max_Left)
        %comparison to k-1 min 
        fr = min( zero_Max_Left(k-1) , zero_Min_Right(v));
        ba = max( zero_Max_Left(k-1) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(3) = x;
            end
        end
    end
    
    if k+1 <= length(zero_Max_Right) && v <= length(zero_Min_Left)
        %comparison to k+1 min
        fr = min(zero_Min_Left(v) , zero_Max_Right(k+1));
        ba = max(zero_Min_Left(v) , zero_Max_Right(k+1));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_min1(4) = x;
            end
        end
    end
    
    if k+2 <= length(zero_Max_Right) && v <= length(zero_Min_Left)
        %comparison to k+2 min
        fr = min(zero_Min_Left(v) , zero_Max_Right(k+2));
        ba = max(zero_Min_Left(v) , zero_Max_Right(k+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_min1(5) = x;
            end
        end
    end
    
    if v <= length(zero_Min_Left) && v+1 <= length(zero_Min_Right)
        %comparison to v+1 max
        fr = min(zero_Min_Left(v) , zero_Min_Right(v+1));
        ba = max(zero_Min_Left(v) , zero_Min_Right(v+1));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(6) = x;
            end
        end
    end
    
    if v <= length(zero_Min_Left) && v+2 <= length(zero_Min_Right)
        %comparison to v+2 max
        fr = min(zero_Min_Left(v) , zero_Min_Right(v+2));
        ba = max(zero_Min_Left(v) , zero_Min_Right(v+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_min1(7) = x;
            end
        end
    end
    
    if v>1 && v <= length(zero_Max_Left) && v <= length(zero_Min_Right)
        %comparison to v-1 max
        fr = min(zero_Max_Left(v-1) , zero_Min_Right(v));
        ba = max(zero_Max_Left(v-1) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(8) = x;
            end
        end
    end
    
    if v>2 && v-2 <= length(zero_Min_Left) && v <= length(zero_Min_Right) 
        %comparison to v-2 max
        fr = min(zero_Min_Left(v-2) , zero_Min_Right(v));
        ba = max(zero_Min_Left(v-2) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_min1(9) = x;
            end
        end
    end
end

average_fMin1_filt(v) = mean(frequency_min1); 

end

% 1 on both sides using min and un-filtered signal 
for v = 1:1:z

% finding the closets max location to the v'th min location
distance = min(abs(locations_min(v) - locations_max));

k = find (locations_max == (locations_min(v)-distance));
if isempty(k) == 1
    k = find (locations_max == (locations_min(v)+distance));
end 



h = locations_min(v) - locations_max(k);

for b = 1:1:8
    frequency(b) = 0;
end

% s = locations_max(v)/2100 +12.39
% t = locations_min(k)/2100 +12.39

%if h is negative so max is before min
if h < 0
    
    if v <= length(zero_Min_Left) && v <= length(zero_Min_Right) 
        % comparison to v min
        
        fr = min( zero_Min_Left(v) , zero_Min_Right(v) );
        ba = max( zero_Min_Left(v) , zero_Min_Right(v) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(1) = x;
            end
        end
    end 
    
    
    if v <= length(zero_Min_Left) && k <= length(zero_Max_Right) 
        % comparison to k max
    
        fr = min( zero_Min_Left(v) , zero_Max_Right(k) );
        ba = max( zero_Min_Left(v) , zero_Max_Right(k) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(2) = x;
            end
        end
    end 
    
    if v <= length(zero_Min_Left) && k+1 <= length(zero_Max_Right)
        %comparison to k+1 max 
        fr = min( zero_Min_Left(v) , zero_Max_Right(k+1) );
        ba = max( zero_Min_Left(v) , zero_Max_Right(k+1) );
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_min1(3) = x;
            end
        end
    end
    
    if k>2 && v <= length(zero_Min_Right) && k-1 <= length(zero_Max_Left)
        
        %comparisonto k-1 min 
        fr = min( zero_Max_Left(k-1) , zero_Min_Right(v) );
        ba = max( zero_Max_Left(k-1) , zero_Min_Right(v) );
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(4) = x;
            end
        end
    end
    
    if k>2 && v <= length(zero_Min_Right) && k-2 <= length(zero_Max_Left) 
        
        %comparison to k-2 min
        fr = min(zero_Max_Left(k-2) , zero_Min_Right(v));
        ba = max(zero_Max_Left(k-2) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_min1(5) = x;
            end
        end
    end
    if v+1 <= length(zero_Min_Right) && v <= length(zero_Min_Left)
        %comparison to v+1 max
        fr = min(zero_Min_Left(v) , zero_Min_Right(v+1));
        ba = max(zero_Min_Left(v) , zero_Min_Right(v+1)); 
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(6) = x;
            end
        end
    end
    if v <= (length(zero_Min_Right)-2) && v <= length(zero_Min_Left)
        %comparison to v+2 max
        
        fr = min(zero_Min_Left(v) , zero_Min_Right(v+2));
        ba = max(zero_Min_Left(v) , zero_Min_Right(v+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
            
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_min1(7) = x;
            end
        end
    end 
    
    if v >1 && v <= length(zero_Min_Right) && v-1 <= length(zero_Min_Left)
        
        %comparison to v-1 max
        fr = min(zero_Min_Left(v-1) , zero_Min_Right(v));
        ba = max(zero_Min_Left(v-1) , zero_Min_Right(v)); 
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(8) = x;
            end
        end
    end
    if v>2 && v <= length(zero_Min_Right) && v-2 <= length(zero_Min_Left)
        
        %comparison to v-2 max
        fr = min(zero_Min_Left(v-2) , zero_Min_Right(v));
        ba = max(zero_Min_Left(v-2) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_min1(9) = x;
            end
        end
    end
end



if h > 0 
    
    if v <= length(zero_Min_Left) && v <= length(zero_Min_Right) 
        % comparison to k min
        
        fr = min( zero_Min_Left(v) , zero_Min_Right(v) );
        ba = max( zero_Min_Left(v) , zero_Min_Right(v) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(1) = x;
            end
        end
    end 
    
    if k <= length(zero_Max_Left) && v <= length(zero_Min_Right)
        %comparison to k min
        fr = min( zero_Max_Left(k) , zero_Min_Right(v) );
        ba = max( zero_Max_Left(k) , zero_Min_Right(v) );
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(2) = x;
            end
        end
    end
    
    if k > 1 && v <= length(zero_Min_Right) && k-1 <= length(zero_Max_Left)
        %comparison to k-1 min 
        fr = min( zero_Max_Left(k-1) , zero_Min_Right(v));
        ba = max( zero_Max_Left(k-1) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(3) = x;
            end
        end
    end
    
    if k+1 <= length(zero_Max_Right) && v <= length(zero_Min_Left)
        %comparison to k+1 min
        fr = min(zero_Min_Left(v) , zero_Max_Right(k+1));
        ba = max(zero_Min_Left(v) , zero_Max_Right(k+1));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_min1(4) = x;
            end
        end
    end
    
    if k+2 < length(zero_Max_Right) && v <= length(zero_Min_Left)
        %comparison to k+2 min
        fr = min(zero_Min_Left(v) , zero_Max_Right(k+2));
        ba = max(zero_Min_Left(v) , zero_Max_Right(k+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_min1(5) = x;
            end
        end
    end
    
    if v <= length(zero_Min_Left) && v+1 <= length(zero_Min_Right)
        %comparison to v+1 max
        fr = min(zero_Min_Left(v) , zero_Min_Right(v+1));
        ba = max(zero_Min_Left(v) , zero_Min_Right(v+1));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(6) = x;
            end
        end
    end
    
    if v < length(zero_Min_Left) && v+2 <= length(zero_Min_Right)
        %comparison to v+2 max
        fr = min(zero_Min_Left(v) , zero_Min_Right(v+2));
        ba = max(zero_Min_Left(v) , zero_Min_Right(v+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_min1(7) = x;
            end
        end
    end
    
    if v>1 && v <= length(zero_Max_Left) && v <= length(zero_Min_Right)
        %comparison to v-1 max
        fr = min(zero_Max_Left(v-1) , zero_Min_Right(v));
        ba = max(zero_Max_Left(v-1) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min1(8) = x;
            end
        end
    end
    
    if v>2 && v-2 <= length(zero_Min_Left) && v <= length(zero_Min_Right) 
        %comparison to v-2 max
        fr = min(zero_Min_Left(v-2) , zero_Min_Right(v));
        ba = max(zero_Min_Left(v-2) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
%                 frequency_min1(9) = x;
            end
        end
    end
end

average_fMin1_unfilt(v) = mean(frequency_min1); 

if mean(frequency_min1) > inflationFreq
    checkForInflation(i) = locations_min(v);
    checkForInflation_freq(i) = mean(frequency_min1);
    i = i+1;
end

end


% 2 on both sides using min and filtered signal 
for v = 1:1:z

% finding the closets max location to the v'th min location
distance = min(abs(locations_min(v) - locations_max));

k = find (locations_max == (locations_min(v)-distance));
if isempty(k) == 1
    k = find (locations_max == (locations_min(v)+distance));
end 



h = locations_min(v) - locations_max(k);

for b = 1:1:8
    frequency(b) = 0;
end

% s = locations_max(v)/2100 +12.39
% t = locations_min(k)/2100 +12.39

%if h is negative so max is before min
if h < 0
    
    if v <= length(zero_Min_Left) && v <= length(zero_Min_Right) 
        % comparison to v min
        
        fr = min( zero_Min_Left(v) , zero_Min_Right(v) );
        ba = max( zero_Min_Left(v) , zero_Min_Right(v) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(1) = x;
            end
        end
    end 
    
    
    if v <= length(zero_Min_Left) && k <= length(zero_Max_Right) 
        % comparison to k max
    
        fr = min( zero_Min_Left(v) , zero_Max_Right(k) );
        ba = max( zero_Min_Left(v) , zero_Max_Right(k) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(2) = x;
            end
        end
    end 
    
    if v <= length(zero_Min_Left) && k+1 <= length(zero_Max_Right)
        %comparison to k+1 max 
        fr = min( zero_Min_Left(v) , zero_Max_Right(k+1) );
        ba = max( zero_Min_Left(v) , zero_Max_Right(k+1) );
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(3) = x;
            end
        end
    end
    
    if k>2 && v <= length(zero_Min_Right) && k-1 <= length(zero_Max_Left)
        
        %comparisonto k-1 min 
        fr = min( zero_Max_Left(k-1) , zero_Min_Right(v) );
        ba = max( zero_Max_Left(k-1) , zero_Min_Right(v) );
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(4) = x;
            end
        end
    end
    
    if k>2 && v <= length(zero_Min_Right) && k-2 <= length(zero_Max_Left) 
        
        %comparison to k-2 min
        fr = min(zero_Max_Left(k-2) , zero_Min_Right(v));
        ba = max(zero_Max_Left(k-2) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(5) = x;
            end
        end
    end
    if v+1 <= length(zero_Min_Right) && v <= length(zero_Min_Left)
        %comparison to v+1 max
        fr = min(zero_Min_Left(v) , zero_Min_Right(v+1));
        ba = max(zero_Min_Left(v) , zero_Min_Right(v+1)); 
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(6) = x;
            end
        end
    end
    if v <= (length(zero_Min_Right)-2) && v <= length(zero_Min_Left)
        %comparison to v+2 max
        
        fr = min(zero_Min_Left(v) , zero_Min_Right(v+2));
        ba = max(zero_Min_Left(v) , zero_Min_Right(v+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
            
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(7) = x;
            end
        end
    end 
    
    if v >1 && v <= length(zero_Min_Right) && v-1 <= length(zero_Min_Left)
        
        %comparison to v-1 max
        fr = min(zero_Min_Left(v-1) , zero_Min_Right(v));
        ba = max(zero_Min_Left(v-1) , zero_Min_Right(v)); 
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(8) = x;
            end
        end
    end
    if v>2 && v <= length(zero_Min_Right) && v-2 <= length(zero_Min_Left)
        
        %comparison to v-2 max
        fr = min(zero_Min_Left(v-2) , zero_Min_Right(v));
        ba = max(zero_Min_Left(v-2) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(9) = x;
            end
        end
    end
end



if h > 0 
    
    if v <= length(zero_Min_Left) && v <= length(zero_Min_Right) 
        % comparison to k min
        
        fr = min( zero_Min_Left(v) , zero_Min_Right(v) );
        ba = max( zero_Min_Left(v) , zero_Min_Right(v) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(1) = x;
            end
        end
    end 
    
    if k <= length(zero_Max_Left) && v <= length(zero_Min_Right)
        %comparison to k min
        fr = min( zero_Max_Left(k) , zero_Min_Right(v) );
        ba = max( zero_Max_Left(k) , zero_Min_Right(v) );
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(2) = x;
            end
        end
    end
    
    if k > 1 && v <= length(zero_Min_Right) && k-1 <= length(zero_Max_Left)
        %comparison to k-1 min 
        fr = min( zero_Max_Left(k-1) , zero_Min_Right(v));
        ba = max( zero_Max_Left(k-1) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(3) = x;
            end
        end
    end
    
    if k+1 <= length(zero_Max_Right) && v <= length(zero_Min_Left)
        %comparison to k+1 min
        fr = min(zero_Min_Left(v) , zero_Max_Right(k+1));
        ba = max(zero_Min_Left(v) , zero_Max_Right(k+1));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(4) = x;
            end
        end
    end
    
    if k+2 < length(zero_Max_Right) && v <= length(zero_Min_Left)
        %comparison to k+2 min
        fr = min(zero_Min_Left(v) , zero_Max_Right(k+2));
        ba = max(zero_Min_Left(v) , zero_Max_Right(k+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(5) = x;
            end
        end
    end
    
    if v <= length(zero_Min_Left) && v+1 <= length(zero_Min_Right)
        %comparison to v+1 max
        fr = min(zero_Min_Left(v) , zero_Min_Right(v+1));
        ba = max(zero_Min_Left(v) , zero_Min_Right(v+1));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(6) = x;
            end
        end
    end
    
    if v < length(zero_Min_Left) && v+2 <= length(zero_Min_Right)
        %comparison to v+2 max
        fr = min(zero_Min_Left(v) , zero_Min_Right(v+2));
        ba = max(zero_Min_Left(v) , zero_Min_Right(v+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(7) = x;
            end
        end
    end
    
    if v>1 && v <= length(zero_Min_Left) && v <= length(zero_Min_Right)
        %comparison to v-1 max
        fr = min(zero_Min_Left(v-1) , zero_Min_Right(v));
        ba = max(zero_Min_Left(v-1) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(8) = x;
            end
        end
    end
    
    if v>2 && v-2 <= length(zero_Min_Left) && v <= length(zero_Min_Right) 
        %comparison to v-2 max
        fr = min(zero_Min_Left(v-2) , zero_Min_Right(v));
        ba = max(zero_Min_Left(v-2) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(9) = x;
            end
        end
    end
end

average_fMin2_filt(v) = mean(frequency_min2); 

end

% 2 on both sides using min and un-filtered signal 
for v = 1:1:z

% finding the closets max location to the v'th min location
distance = min(abs(locations_min(v) - locations_max));

k = find (locations_max == (locations_min(v)-distance));
if isempty(k) == 1
    k = find (locations_max == (locations_min(v)+distance));
end 



h = locations_min(v) - locations_max(k);

for b = 1:1:8
    frequency(b) = 0;
end

% s = locations_max(v)/2100 +12.39
% t = locations_min(k)/2100 +12.39

%if h is negative so max is before min
if h < 0
    
    if v <= length(zero_Min_Left) && v <= length(zero_Min_Right) 
        % comparison to v min
        
        fr = min( zero_Min_Left(v) , zero_Min_Right(v) );
        ba = max( zero_Min_Left(v) , zero_Min_Right(v) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(1) = x;
            end
        end
    end 
    
    
    if v <= length(zero_Min_Left) && k <= length(zero_Max_Right) 
        % comparison to k max
    
        fr = min( zero_Min_Left(v) , zero_Max_Right(k) );
        ba = max( zero_Min_Left(v) , zero_Max_Right(k) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(2) = x;
            end
        end
    end 
    
    if v <= length(zero_Min_Left) && k+1 <= length(zero_Max_Right)
        %comparison to k+1 max 
        fr = min( zero_Min_Left(v) , zero_Max_Right(k+1) );
        ba = max( zero_Min_Left(v) , zero_Max_Right(k+1) );
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(3) = x;
            end
        end
    end
    
    if k>2 && v <= length(zero_Min_Right) && k-1 <= length(zero_Max_Left)
        
        %comparisonto k-1 min 
        fr = min( zero_Max_Left(k-1) , zero_Min_Right(v) );
        ba = max( zero_Max_Left(k-1) , zero_Min_Right(v) );
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(4) = x;
            end
        end
    end
    
    if k>2 && v <= length(zero_Min_Right) && k-2 <= length(zero_Max_Left) 
        
        %comparison to k-2 min
        fr = min(zero_Max_Left(k-2) , zero_Min_Right(v));
        ba = max(zero_Max_Left(k-2) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(5) = x;
            end
        end
    end
    if v+1 <= length(zero_Min_Right) && v <= length(zero_Min_Left)
        %comparison to v+1 max
        fr = min(zero_Min_Left(v) , zero_Min_Right(v+1));
        ba = max(zero_Min_Left(v) , zero_Min_Right(v+1)); 
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(6) = x;
            end
        end
    end
    if v <= (length(zero_Min_Right)-2) && v <= length(zero_Min_Left)
        %comparison to v+2 max
        
        fr = min(zero_Min_Left(v) , zero_Min_Right(v+2));
        ba = max(zero_Min_Left(v) , zero_Min_Right(v+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
            
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(7) = x;
            end
        end
    end 
    
    if v >1 && v <= length(zero_Min_Right) && v-1 <= length(zero_Min_Left)
        
        %comparison to v-1 max
        fr = min(zero_Min_Left(v-1) , zero_Min_Right(v));
        ba = max(zero_Min_Left(v-1) , zero_Min_Right(v)); 
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(8) = x;
            end
        end
    end
    if v>2 && v <= length(zero_Min_Right) && v-2 <= length(zero_Min_Left)
        
        %comparison to v-2 max
        fr = min(zero_Min_Left(v-2) , zero_Min_Right(v));
        ba = max(zero_Min_Left(v-2) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );

            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(9) = x;
            end
        end
    end
end



if h > 0 
    
    if v <= length(zero_Min_Left) && v <= length(zero_Min_Right) 
        % comparison to k min
        
        fr = min( zero_Min_Left(v) , zero_Min_Right(v) );
        ba = max( zero_Min_Left(v) , zero_Min_Right(v) );
    
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
      
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(1) = x;
            end
        end
    end 
    
    if k <= length(zero_Max_Left) && v <= length(zero_Min_Right)
        %comparison to k min
        fr = min( zero_Max_Left(k) , zero_Min_Right(v) );
        ba = max( zero_Max_Left(k) , zero_Min_Right(v) );
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(2) = x;
            end
        end
    end
    
    if k > 1 && v <= length(zero_Min_Right) && k-1 <= length(zero_Max_Left)
        %comparison to k-1 min 
        fr = min( zero_Max_Left(k-1) , zero_Min_Right(v));
        ba = max( zero_Max_Left(k-1) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(3) = x;
            end
        end
    end
    
    if k+1 <= length(zero_Max_Right) && v <= length(zero_Min_Left)
        %comparison to k+1 min
        fr = min(zero_Min_Left(v) , zero_Max_Right(k+1));
        ba = max(zero_Min_Left(v) , zero_Max_Right(k+1));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(4) = x;
            end
        end
    end
    
    if k+2 < length(zero_Max_Right) && v <= length(zero_Min_Left)
        %comparison to k+2 min
        fr = min(zero_Min_Left(v) , zero_Max_Right(k+2));
        ba = max(zero_Min_Left(v) , zero_Max_Right(k+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(5) = x;
            end
        end
    end
    
    if v <= length(zero_Min_Left) && v+1 <= length(zero_Min_Right)
        %comparison to v+1 max
        fr = min(zero_Min_Left(v) , zero_Min_Right(v+1));
        ba = max(zero_Min_Left(v) , zero_Min_Right(v+1));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(6) = x;
            end
        end
    end
    
    if v < length(zero_Min_Left) && v+2 <= length(zero_Min_Right)
        %comparison to v+2 max
        fr = min(zero_Min_Left(v) , zero_Min_Right(v+2));
        ba = max(zero_Min_Left(v) , zero_Min_Right(v+2));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(7) = x;
            end
        end
    end
    
    if v>1 && v <= length(zero_Min_Left) && v <= length(zero_Min_Right)
        %comparison to v-1 max
        fr = min(zero_Min_Left(v-1) , zero_Min_Right(v));
        ba = max(zero_Min_Left(v-1) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm(fr:ba);
            tsound_temp = tsound(fr:ba);
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(8) = x;
            end
        end
    end
    
    if v>2 && v-2 <= length(zero_Min_Left) && v <= length(zero_Min_Right) 
        %comparison to v-2 max
        fr = min(zero_Min_Left(v-2) , zero_Min_Right(v));
        ba = max(zero_Min_Left(v-2) , zero_Min_Right(v));
        
        if ba - fr > 2 
            pulse_sound_temp = pulse_sound_norm( fr : ba );
            tsound_temp = tsound( fr : ba );
    
            x = findFreqSpecPeak(pulse_sound_temp);
            if isempty(x) == 0
                frequency_min2(9) = x;
            end
        end
    end
end

average_fMin2_unfilt(v) = mean(frequency_min2);

if mean(frequency_min2) > inflationFreq
    checkForInflation(i) = locations_min(v);
    checkForInflation_freq(i) = mean(frequency_min2);
    i = i+1;
end

end

checkForInflation = unique(checkForInflation, 'sorted');
% 
% ax2 = subplot(6,1,2);hold on;
% % title('4. Low Pass Filter');
% plot(tsound,pulse_sound);
%% 
% figure;
% % ax3 = subplot(2,2,1);
% hold on;
% title('average\_fMax1 Frequencies');
% xlabel('tsound (seconds)');
% ylabel('pulse\_sound');
% plot(tsound,pulse_sound);
% plot(tsound(locations_max),pulse_sound(locations_max),'x','linewidth',3, 'color','m');
% % plot(tsound(locations_min),pulse_sound(locations_min),'x','linewidth',3, 'color','k');
% 
% for p = 33:1:40%1:1:length(average_fMax1_filt)
% %     text(tsound(locations_max(p)), pulse_sound(locations_max(p))+0.05 , num2str(average_fMax1_filt(p)) , 'FontSize' , 10 );
%     text(tsound(locations_max(p)), pulse_sound(locations_max(p))+0.005 , num2str(average_fMax1_unfilt(p)) , 'FontSize' , 15, 'color','r' );
% end
% % 
% % ax4 = subplot(2,2,2);
% figure;
% hold on;
% title('average\_fMax2 Frequencies');
% xlabel('tsound (seconds)');
% ylabel('pulse\_sound');
% plot(tsound,pulse_sound);
% plot(tsound(locations_max),pulse_sound(locations_max),'x','linewidth',3, 'color','m');
% % plot(tsound(locations_min),pulse_sound(locations_min),'x','linewidth',3, 'color','k');
% 
% for p = 33:1:40%1:1:length(average_fMax2_unfilt)
% %     text(tsound(locations_max(p)), pulse_sound(locations_max(p))+0.05 , num2str(average_fMax2_filt(p)) , 'FontSize' , 10 );
%     text(tsound(locations_max(p)), pulse_sound(locations_max(p))+0.005 , num2str(average_fMax2_unfilt(p)) , 'FontSize' , 15 , 'color','r' );
% end
% % 
% % 
% % ax5 = subplot(2,2,3);
% figure;
% hold on;
% title('average\_fMin1 Frequencies');
% xlabel('tsound (seconds)');
% ylabel('pulse\_sound');
% plot(tsound,pulse_sound);
% % plot(tsound(locations_max),pulse_sound(locations_max),'x','linewidth',3, 'color','m');
% plot(tsound(locations_min),pulse_sound(locations_min),'x','linewidth',3, 'color','k');
% 
% for p = 34:1:41%1:1:length(average_fMin1_unfilt)
% %     text(tsound(locations_min(p)), pulse_sound(locations_min(p))+0.05 , num2str(average_fMin1_filt(p)) , 'FontSize' , 10 );
%     text(tsound(locations_min(p)), pulse_sound(locations_min(p))-0.005 , num2str(average_fMin1_unfilt(p)) , 'FontSize' , 15 , 'color','r' );
% end
% % 
% % 
% % ax6 = subplot(2,2,4);
% figure;
% hold on;
% title('average\_fMin2 Frequencies');
% xlabel('tsound (seconds)');
% ylabel('pulse\_sound');
% plot(tsound,pulse_sound);
% % plot(tsound(locations_max),pulse_sound(locations_max),'x','linewidth',3, 'color','m');
% plot(tsound(locations_min),pulse_sound(locations_min),'x','linewidth',3, 'color','k');
% 
% for p = 34:1:41%length(average_fMin2_unfilt)
% %     text(tsound(locations_min(p)), pulse_sound(locations_min(p))+0.05 , num2str(average_fMin2_filt(p)) , 'FontSize' , 10 );
%     text(tsound(locations_min(p)), pulse_sound(locations_min(p))-0.005 , num2str(average_fMin2_unfilt(p)) , 'FontSize' , 15, 'color','r' );
% end
% 
% figure;
% hold on;
% title('pulse\_sound\_norm, this is the signal the frequencies are calculated from');
% xlabel('tsound (seconds)');
% ylabel('pulse\_sound\_norm');
% plot(tsound,pulse_sound_norm);
% plot(tsound(locations_max),pulse_sound(locations_max),'x','linewidth',3, 'color','m');
% plot(tsound(locations_min),pulse_sound(locations_min),'x','linewidth',3, 'color','k');
% % 
% linkaxes([ ax3 , ax4 , ax5 , ax6] , 'x');

% return; 
% 
% figure; hold on;
% title('deflation locations found before zero crossing elimination performed');
% xlabel('tsound (seconds)');
% ylabel('pulse\_sound\_norm');
% plot(tsound,pulse_sound_norm);
% plot(tsound(checkForInflation),pulse_sound_norm(checkForInflation), 'x','linewidth',3,'color','g');
% % return;

clc;

v=1;
y=1;
for x = 1:1:length(checkForInflation)
    
    if isempty(pulse_sound_norm(checkForInflation(x)+crossings_check_signal_width)) == 1
        pulse_sound_check = pulse_sound_norm( checkForInflation(x)-crossings_check_signal_width : length(pulse_sound_norm));
        tsound_check = tsound(checkForInflation(x)-crossings_check_signal_width : length(pulse_sound_norm));
    elseif checkForInflation(x)-crossings_check_signal_width <=0
        pulse_sound_check = pulse_sound_norm( 1 : checkForInflation(x)+crossings_check_signal_width );
        tsound_check = tsound( 1 : checkForInflation(x)+crossings_check_signal_width);
    else
        pulse_sound_check = pulse_sound_norm( checkForInflation(x)-crossings_check_signal_width : checkForInflation(x)+crossings_check_signal_width );
        tsound_check = tsound(checkForInflation(x)-crossings_check_signal_width : checkForInflation(x)+crossings_check_signal_width);
    end
%     y = zeros(length(pulse_sound_check),1);
%     figure; hold on;
%     title('Zero Crosses Check');
%     xlabel('tsound (seconds)');
%     ylabel('pulse\_sound\_norm');
%     plot(tsound_check ,pulse_sound_check );
%     plot(tsound_check,y, 'color', 'g');
%     plot(tsound_check(45) , pulse_sound_check(45), 'x', 'linewidth', 3, 'color', 'r');
  
    crossings = zeroCrossings(pulse_sound_check);
    
    if crossings >= Number_of_zero_crossings % if there are the right number of crossing
        if isempty(pulse_sound_norm(checkForInflation(x) + crossings_check_signal_width)) == 1
            window = pulse_sound_norm( checkForInflation(x) - crossings_check_signal_width : length(pulse_sound_norm) );
            twindow = tsound( checkForInflation(x) - crossings_check_signal_width : length(pulse_sound_norm) );
            bet = 1;
        elseif checkForInflation(x) - crossings_check_signal_width <=0
            window = pulse_sound_norm( 1 : checkForInflation(x) + crossings_check_signal_width );
            twindow = tsound( 1 : checkForInflation(x) + crossings_check_signal_width );
            bet = 2;
        else
            window = pulse_sound_norm( checkForInflation(x) - crossings_check_signal_width : checkForInflation(x) + crossings_check_signal_width );
            twindow = tsound( checkForInflation(x) - crossings_check_signal_width : checkForInflation(x) + crossings_check_signal_width );
            bet = 1;
        end
        
        
        [peak_max,locs_max] = findpeaks(window); % find posative peak of inflation window 
        idx_h = max(window(locs_max));
        idx = find(window == idx_h, 1 );
        
%         figure; hold on;
%         plot(twindow, window);
%         plot(twindow(idx), window(idx), 'x');
%         [peak_max,locs_max] = findpeaks(-window); % find posative peak of inflation window 
%         ufh = min(window(locs_max));
       
        if  bet==2
            if abs(pulse_sound_norm(idx))>0.2 %removes points found that are within the noise
                Inflation(v) = idx;
%                 height(v) = idx_h - ufh;
                cross0(v) = crossings;
                Inflation_freq(v) = checkForInflation_freq(x);
                v = v + 1;
            end
        elseif bet==1
            if abs(pulse_sound_norm(checkForInflation(x) - crossings_check_signal_width + idx))>0.2  %removes points found that are within the noise
                Inflation(v) = checkForInflation(x) - crossings_check_signal_width + idx; % keep inflation point 
%                 height(v) = idx_h - ufh; % height of the point from max to min 
                cross0(v) = crossings;
                Inflation_freq(v) = checkForInflation_freq(x); 
                v = v + 1;
                
            end
        end

       
        
    end
end
Inflation =  unique(Inflation);
% return;
figure; hold on;
title('Inflation locations remaining after eliminating based on number of zero crossings');
xlabel('tsound (seconds)');
ylabel('pulse\_sound\_norm');
plot(tsound, pulse_sound_norm);
plot(tsound(Inflation), pulse_sound_norm(Inflation),'x','linewidth',3,'color','r');
% for p = 1:1:length(cross0)
%     text(tsound(Inflation(p)), pulse_sound(Inflation(p))+0.05 , num2str(cross0(p)) , 'FontSize' , 10 );
%     text(tsound(Inflation(p)), pulse_sound(Inflation(p))-0.05 , num2str(Inflation_freq(p)) , 'FontSize' , 10 );
% 
% end
% return;
% Inflation = unique(Inflation);
y = zeros(length(pulse_sound_norm),1);

Inflation_b = Inflation;

t=1;
% find peak frequencys around points already found 
% for v = 1:1:length(Inflation_b)
%     if Inflation_b(v) - exact_peak_frequency_window_width <0 
%         window = pulse_sound_norm( 1  : Inflation_b(v) + exact_peak_frequency_window_width );
% 
%     elseif Inflation_b(v) + exact_peak_frequency_window_width > length(pulse_sound_norm)
%         window = pulse_sound_norm( Inflation_b(v) - exact_peak_frequency_window_width  : Inflation_b(v) + exact_peak_frequency_window_width );
% 
%     else
%         window = pulse_sound_norm( Inflation_b(v) - exact_peak_frequency_window_width  : Inflation_b(v) + exact_peak_frequency_window_width );
% 
%     end
%     %twindow = tsound( Inflation_b(v) - 4*exact_peak_frequency_window_width : Inflation_b(v) + 4*exact_peak_frequency_window_width );
% %     figure; hold on;
% %     plot(twindow, window);
%     
%     x = findFreqSpecPeak(window);
%     if isempty(x) == 0
%         
%         if x > exactFrequencyPeak
%             
%             frequency(t) = x;
%             Inflation(t) = Inflation_b(v);
%             t = t + 1;
%         end
%     end
%     %34.4262 for signal 10 
%     
%     %34.4262 for signal 9 but less frequent, but 34.4262 is the lowest
%     %   frequency of all the ones calculated 
%     
%     
% end 
% 
y = zeros(length(pulse_sound_norm),1);
figure;
ax1 = subplot(2,1,1); hold on;
title('points found before');
plot(tsound, pulse_sound_norm);
plot(tsound, y);
ax2 = subplot(2,1,2); hold on;
plot(tsound, pulse_sound_norm);
plot(tsound(Inflation), pulse_sound_norm(Inflation), 'x', 'linewidth', 3, 'color' , 'r');
% 
% for p = 1:1:length(frequency)
%     text(tsound(Inflation(p)), pulse_sound(Inflation(p))+0.05 , num2str(frequency(p)) , 'FontSize' , 10 );
% end
linkaxes([ax1 , ax2] , 'x');

% return;

%%
gap_times = [];
p=1;%find average time between inflations 
for x = 1:1:(length(Inflation)-1)
    if Inflation(x+1) - Inflation(x) < 2730 %1.3 seconds time between inflations
        if Inflation(x+1) - Inflation(x) > 1470 % more that 0.7 second between inflations 
            gap_times(p) = Inflation(x+1) - Inflation(x);
            p = p+1;
        end
    end
    
end

if isempty(gap_times) == 1
    inflation_gap_time = manualInflationTime;
else 
    inflation_gap_time = mean(gap_times);
end

inflation_gap_time = floor(inflation_gap_time);
marker =1; % search for more inflation points 
position = Inflation(1);
disp('final stage');
r=1; 
a=1;
potencial_location = [];
highestFrequency = 13;
%need to do some code for if the first inflation isnt found
% save variables.mat;
% return;
%%

figure; hold on;
plot(tsound, pulse_sound_norm);
plot(tsound(Inflation), pulse_sound_norm(Inflation), 'x', 'linewidth', 3, 'color' , 'r');
 
while marker == 1
        
        position
        
        for v = 1:1:length(Inflation)
            
            
            if Inflation(v) >= (position +(inflation_gap_time-width_search_area)) && Inflation(v) <= (position +(inflation_gap_time+width_search_area))
                position = Inflation(v);
                found = 1; %next position already found 
                break;
            else 
                found =0; % next position not found 
            end
        end

        
        if found == 0
            
            
            if position +(inflation_gap_time+width_search_area)  >= length(pulse_sound_norm) %no more signal left
                marker = 0;
                
            elseif position +(inflation_gap_time+width_search_area)  <= length(pulse_sound_norm) %still room for another artefact
                
                window = pulse_sound_norm(position +(inflation_gap_time-width_search_area) : position +(inflation_gap_time+width_search_area));
                twindow = tsound(position +(inflation_gap_time-width_search_area) : position +(inflation_gap_time+width_search_area));
                
%                 figure; hold on;
%                 plot(twindow, window);
                
                
                
                [peak_max,locs_max] = findpeaks(window, 'MinPeakHeight', 0.1); % see if we can remove this 0.1
                
%                 figure; hold on;
%                 title('window of time, at a distance of the cuff time period from pervious deflation artefact found');
%                 xlabel('tsound (seconds)');
%                 ylabel('pulse\_sound\_norm');
%                 plot(twindow, window);
%                 plot(twindow(locs_max), window(locs_max),'x','linewidth',3,'color','r');
%                 return;
                
                for i = 1:1:length(locs_max) % find all peaks that have the right frequency spectrum
                    
                    window2 = pulse_sound_norm( position + inflation_gap_time - width_search_area + locs_max(i) - 7*exact_peak_frequency_window_width  : position + inflation_gap_time - width_search_area + locs_max(i) + 7*exact_peak_frequency_window_width );
                    
                    x = findFreqSpecPeak(window2);
                    
                    if isempty(x) == 0
                        frequency_test(r) = x;
                    
%                         test_inflation(r) = position + inflation_gap_time - width_search_area + locs_max(i);
                        test_inflation(r) = locs_max(i);

                        r=r+1;
                        
                        if x > 13 %if peak has the right frequency
                            
                            if x >= ( highestFrequency - 0.5 )
                                if x > ( highestFrequency + 0.5 )
                                    highestFrequency = x;
                                    potencial_location = [];
                                    a = 1; 
                                end
                                potencial_location(a) = position + inflation_gap_time - width_search_area + locs_max(i); % all the locations which have the right frequency
                                a=a+1;
                                
%                                 if i == length(locs_max) && position > 2000
%                                     potencial_location
%                                     return;
%                                 end
                            end
                        end
                    end
                end
%                 figure; hold on;
%                 title('frequency points');
%                 plot(twindow, window);
%                 plot(twindow(test_inflation), window(test_inflation), 'x','linewidth',3, 'color','r');
%                 plot(twindow(450),0, 'x' ,'linewidth', 6,'color','k');
%                 for p = 1:1:length(frequency_test)
%                     text(twindow(test_inflation(p)), window(test_inflation(p))+0.05 , num2str(frequency_test(p)) , 'FontSize' , 15 );
%                 end
%                 
%                 return;
                distance = width_search_area; 
                if isempty(potencial_location) == 0
                    for i = 1:1:length(potencial_location) % find the point left over that is closest to the expected gap time location 
                        if abs( (position + inflation_gap_time) - potencial_location(i) ) < distance
                            j = length(Inflation);
                            Inflation(j+1) = potencial_location(i);
                            Inflation = sort(Inflation,'ascend');
                            position = potencial_location(i);
                        end
                    end
                else 
                    % if we cant find the inflation then just move the position to where we expected it to be 
                    % we want to not have to use this as much as possible
                    % because not very precise 
                    j = length(Inflation);
                    Inflation(j+1) = position + inflation_gap_time; 
                    Inflation = sort(Inflation,'ascend');
                    position = position + inflation_gap_time;  
                end
               
                
            
            
            end
        
        a=1;
        found = 1;
        potencial_location = [];
    end

end

% figure; hold on;
% title('frequency points');
% plot(tsound, pulse_sound_norm);
% plot(tsound(test_inflation), pulse_sound_norm(test_inflation), 'x','linewidth',3, 'color','r');
% for p = 1:1:length(frequency_test)
%     text(tsound(test_inflation(p)), pulse_sound(test_inflation(p))+0.05 , num2str(frequency_test(p)) , 'FontSize' , 10 );
% end
% 
% figure; 





disp('finished');

for v = 1 : 1 : length(Inflation)
    if Inflation(v) - 90 <= 0
        window = pulse_sound_norm( 1 : Inflation(v) + 90 );
        twindow = tsound( 1 : Inflation(v) + 90  );
    elseif ( Inflation(v) + 90 ) > length(pulse_sound_norm) 
        window = pulse_sound_norm( Inflation(v) - 90 : length(pulse_sound_norm) );
        twindow = tsound(Inflation(v) - 90 : length(pulse_sound_norm)  );
    else
        window = pulse_sound_norm( Inflation(v) - 90 : Inflation(v) + 90 );
        twindow = tsound( Inflation(v) - 90 : Inflation(v) + 90 );
    end
    
%     figure; 
%     plot(twindow, window);

    [peak_max,locs_max] = findpeaks(window);
    idx = max(window(locs_max));
    ids = min(find(window == idx)); % find the max location ie the peak of the inflation point
    Inflation(v) = Inflation(v) - 90 + ids; % can be a few locations that have the same max height so just pick the smallest one 
end

ax1 = subplot(2,1,1);hold on;
% figure; hold on;
title('pulse\_sound\_norm');
xlabel('tsound (seconds)');
ylabel('pulse\_sound\_norm');
plot(tsound, pulse_sound_norm);
plot(tsound(Inflation), pulse_sound_norm(Inflation), 'x','linewidth',3, 'color','r');
% 
% ax2 = subplot(4,1,2);hold on;
% plot(tsound, pulse_sound_norm);
% plot(tsound(Inflation), pulse_sound_norm(Inflation), 'x','linewidth',3, 'color','m');


pulse_sound_norm_before = pulse_sound_norm;
for v =1:1:length(Inflation) %zeros all the inflations to then find the pulses 
    if Inflation(v)- 45 <= 0
        pulse_sound_norm( 1 : Inflation(v) + 90 ) = 0;
    elseif Inflation(v) + 90 >= length(pulse_sound_norm)
        pulse_sound_norm( Inflation(v)- 45: length(pulse_sound_norm)) = 0;
    else
        pulse_sound_norm( Inflation(v) - 45 : Inflation(v) + 90) = 0;
    end
    
end


pulse_sound = lowPassFIR(pulse_sound_norm);
% 
ax3 = subplot(2,1,2);
hold on; 
title('pulse\_sound\_norm with artefacts zeroed');
xlabel('tsound (seconds)');
ylabel('pulse\_sound\_norm');
plot(tsound, pulse_sound_norm);
% 
% ax4 = subplot(4,1,4);
% plot(tsound, pulse_sound);
% 
% 
% 
linkaxes([ax1, ax3],'x');
% 
figure; hold on;
title('pulse\_sound\_norm with artefacts zeroed');
xlabel('tsound (seconds)');
ylabel('pulse\_sound\_norm');
plot(tsound, pulse_sound_norm);




% save variables.mat
% return;
%%
% clear all;
% load('variables.mat');

[peak_max,locs_max] = findpeaks(pulse_sound_norm, 'MinPeakHeight' , 0.05 ); % problem found here is that if the threshold is too low then it picks up more peaks but lots of noise also has the same frequency so the accuracy is really bad 
% the signals with low strength like signal 5 i think needs a low threshold
% but a strong signal like 9 it doesnt and a low threshold is bad because
% the noise is higher amplidude aswell 
% % 
% figure; hold on;
% plot(tsound, pulse_sound_norm);
% plot(tsound(locs_max), pulse_sound_norm(locs_max), 'x','linewidth',3,'color','r');
% return;
w=1;

for v = 1:1: length(locs_max)
    if locs_max(v) < 7 *exact_peak_frequency_window_width
        window = pulse_sound_norm( 1  : locs_max(v) + 7 *exact_peak_frequency_window_width );
        twindow = tsound( 1  : locs_max(v) + 7 *exact_peak_frequency_window_width);
    elseif length(pulse_sound_norm) - locs_max(v) < 7 *exact_peak_frequency_window_width
        window = pulse_sound_norm( locs_max(v) - 7 *exact_peak_frequency_window_width  : length(pulse_sound_norm) );
        twindow = tsound( locs_max(v) - 7 *exact_peak_frequency_window_width  : length(pulse_sound_norm) );
    else
        window = pulse_sound_norm( locs_max(v) - 7 *exact_peak_frequency_window_width  : locs_max(v) + 7 *exact_peak_frequency_window_width );
        twindow = tsound( locs_max(v) - 7 *exact_peak_frequency_window_width  : locs_max(v) + 7 *exact_peak_frequency_window_width );
    end
%     figure;hold on;
%     plot(twindow, window);
%     plot(twindow(140), window(140), 'x','linewidth',3,'color','r');
    x = findFreqSpecPeak(window);
    if isempty(x) ==0
        tg(v) = x;
%         if x > 15
%             if locs_max(v) < 90 
%                 pulse_sound_norm( 1  : locs_max(v) + 90 ) = 0;
%             elseif length(pulse_sound_norm) - locs_max(v) < 90
%                 pulse_sound_norm( locs_max(v) - 90  : length(pulse_sound_norm) ) = 0;
%             else
%                 pulse_sound_norm( locs_max(v) - 90  : locs_max(v) + 90 ) = 0;
%             end
        if x > 7.4730 
            if x< 7.4734  %&& pulse_sound_norm(locs_max(v))>=0.075 %some points found within noise
                p_locs(w) = locs_max(v);
                w=w+1
            elseif x > 14.9464 %sometimes the pulse is a multiple of 2 
                if x < 14.9468 %&& pulse_sound_norm(locs_max(v))>=0.075 % some points are found within noise
                    p_locs(w) = locs_max(v);
                    w=w+1
                end
            end
        
        end
        
        
    end
    
end

% for p = 1:1:length(tg)
%     text(tsound(locs_max(p)), pulse_sound(locs_max(p))+0.05 , num2str(tg(p)) , 'FontSize' , 10 );
% end

% return;
for v = 1:1:length(p_locs) %find the max peak of the locations of the pulses
    if  p_locs(v) - 200 <=0
        window = pulse_sound_norm( 1 : p_locs(v) + 200);
    elseif p_locs(v) + 200 > length(pulse_sound_norm)
        window = pulse_sound_norm( p_locs(v) - 200 : length(pulse_sound_norm));
    else
        window = pulse_sound_norm( p_locs(v) - 200 : p_locs(v) + 200);
    end
%    twindow = tsound( p_locs(v) - 90 : p_locs(v) + 90);
%    figure;
%    plot(twindow,window);
   [peak_max,locs_max] = findpeaks(window);
   idx_h = max(window(locs_max));
   if isempty(idx_h)==0
    idx = min(find(window == idx_h));
    p_locs(v) = p_locs(v) -200 + idx;
   end
   
end
p_locs = unique(p_locs);
len_p_locs = length(p_locs)-1;
stop = 0;
for v = 1:1:len_p_locs
    if stop + v == len_p_locs
        break;
    end
    if v+1 <= length(p_locs)-1
        if abs(p_locs(v+1) - p_locs(v)) < 630 
            if pulse_sound_norm(p_locs(v))  > pulse_sound_norm(p_locs(v+1))
                p_locs(v+1) = [];
                stop = stop + 1;
            else
                p_locs(v) = [];
                stop = stop + 1;
            end
        end
    end
end

figure; 
hold on;

plot(tsound,pulse_sound_norm);
plot(tsound(p_locs), pulse_sound_norm(p_locs),'x','linewidth',6,'color','b');

% return;

% p_locs is the locations of the pulses
% Inflation is the locations of the artefacts
signalfilt = lowPassFIR(pulse_sound_norm);

ax1 = subplot(2,1,1); hold on; 
title('heartbeat pulses peak locations plotted on pulse\_sound\_norm');
xlabel('tsound (seconds)');
ylabel('pulse\_sound\_norm');
plot(tsound,pulse_sound_norm);
plot(tsound(p_locs),pulse_sound_norm(p_locs),'x','linewidth',4,'color','r');

ax2 = subplot(2,1,2);hold on;
plot(tsound,signalfilt);
plot(tsound(p_locs),signalfilt(p_locs),'x','linewidth',4,'color','r');

linkaxes([ax1,ax2],'x');

figure; hold on;
title('Cuff deflation artefact peaks plotted on pulse\_sound\_norm with cuff deflation artefacts not zeroed');
xlabel('tsound (seconds)');
ylabel('pulse\_sound\_norm');
plot(tsound, pulse_sound_norm_before);
plot(tsound(Inflation),pulse_sound_norm_before(Inflation)+0.005,'x','linewidth',4,'color','b');


figure;
ax1 = subplot(2,1,1); hold on;
title('pulse\_sound\_norm with cuff deflation artefact peaks and heartbeat peaks located');
xlabel('tsound (seconds)');
ylabel('pulse\_sound\_norm');
plot(tsound,pulse_sound_norm_before);
plot(tsound(Inflation),pulse_sound_norm_before(Inflation)+0.005,'x','linewidth',4,'color','b');
plot(tsound(p_locs),pulse_sound_norm_before(p_locs),'x','linewidth',4,'color','r');

signalfilt = lowPassFIR(pulse_sound_norm_before);

ax2 = subplot(2,1,2); hold on;
plot(tsound,signalfilt);
plot(tsound(Inflation),signalfilt(Inflation)+0.005,'x','linewidth',4,'color','b');
plot(tsound(p_locs),signalfilt(p_locs),'x','linewidth',4,'color','r');

linkaxes([ax1,ax2],'x');
return;





































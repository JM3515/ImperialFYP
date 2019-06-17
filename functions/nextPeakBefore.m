function [locations_peak] = nextPeakBefore(y,x,tsound,pulse_sound)
   
    
    
    if y<x
        m = y;
    elseif y>x
        m = x;
    end
   
    if m < 299
        d = m-1;
    else 
        d = 299;
    end
    pulse_sound_temp = pulse_sound((m-d):m);
    tsound_temp = tsound((m-d):m);
    
%     figure; hold on; 
%     plot(tsound_temp,pulse_sound_temp);
%     return;
    
    marker = 1;
    height = 1.1; 
    while marker == 1
        if y>x
            
            [peak_max,locs_max] = findpeaks(pulse_sound_temp, 'MinPeakHeight', height);
        
%            if length(locs_max) > 1
%            height = height + 0.001*10^-5 
%            end
%         
%            if length(locs_max) ==1
%             
%            marker = 0;
%            locations_min_max(i) = locations_min(i) - 300 + locs_max;
%            end
            if isempty(locs_max)
                height = height - 0.1;
            
            else 
                marker = 0;
                locations_peak = m - d + max(locs_max);
            
            end
            
        elseif y<x
            [peak_max,locs_max] = findpeaks(-pulse_sound_temp, 'MinPeakHeight', height);
            
            if isempty(locs_max)
                height = height - 0.1;
            
            else 
                marker = 0;
                locations_peak = m - d + max(locs_max);
            end
            
        end
            
        end
 
    
    
   
    end


% for i = 1:1:55
%     x = locations_min(i);
%     pulse_sound_temp = pulse_sound((x-300):x);
%     tsound_temp = tsound((x-300):x);
%     
% %     figure; hold on; 
% %     plot(tsound_temp,pulse_sound_temp);
% %     return;
%     
%     marker = 1;
%     height = 5*10^-3; 
%     while marker == 1
%     
%         [peak_max,locs_max] = findpeaks(pulse_sound_temp, 'MinPeakHeight', height);
%         
% %         if length(locs_max) > 
% %             height = height + 0.001*10^-5 
% %         end
% %         
% %         if length(locs_max) ==1
% %             
% %             marker = 0;
% %             locations_min_max(i) = locations_min(i) - 300 + locs_max;
% %         end
%         if isempty(locs_max)
%             height = height - 0.1*10^-4;
%         else 
%             marker = 0;
%             locations_min_max(i) = locations_min(i) - 300 + max(locs_max);
%         end
%         end
%         
%     end 
    
    






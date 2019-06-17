function [location_zero_start , location_zero_end] = findZero(y , x , locations_peak_before , locations_peak_after , pulse_sound , tsound)

if y > x 
        x
        z = x - locations_peak_before
        pulse_sound_temp = pulse_sound((x-z):x);
%         tsound_temp = tsound((x-z):x);
      

        dist = abs(pulse_sound_temp);
        minDist = min(dist);
        idx = find(dist == minDist);
    
        location_zero_start = x - (z - idx);


        w = locations_peak_after - y;
        pulse_sound_temp = pulse_sound(y:y+w);
%         tsound_temp = tsound(y:y+w);
        
        dist = abs(pulse_sound_temp);
        minDist = min(dist);
        idx = find(dist == minDist);
        
        location_zero_end = y + idx;
 
        
        
        
        
        
    
elseif x > y
        
       
        z =  y - locations_peak_before;
        pulse_sound_temp = pulse_sound((y-z):y);
        tsound_temp = tsound((y-z):y);
%         
%         figure; hold on;
%         plot(tsound_temp,pulse_sound_temp);
%         return;
        dist = abs(pulse_sound_temp);
        minDist = min(dist);
        idx = find(dist == minDist);
  
      
        location_zero_start = y - (z - idx);
        
        
        
        w = locations_peak_after - x;
        pulse_sound_temp = pulse_sound(x:x+w);
%         tsound_temp = tsound(x:x+w);
        
        dist = abs(pulse_sound_temp);
        minDist = min(dist);
        idx = find(dist == minDist);
        
        location_zero_end = x + idx;
        
        
        
end 





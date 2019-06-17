function [locations_Peak] = nextPeakAfter(y,x,tsound,pulse_sound)

    if y<x
        m = x;
    elseif y>x
        m = y;
     end
    
    pulse_sound_temp = pulse_sound(m:m+300);
    
    
    marker = 1;
    height = 1.1; 
    while marker == 1
       
        if y>x
            
            [peak_max,locs_max] = findpeaks(-pulse_sound_temp, 'MinPeakHeight', height);
        
        
            if length(locs_max) > 1
               height = height + 0.1;
            end
        
            if length(locs_max) == 1
                marker = 0;
                locations_Peak = m + locs_max;
            end
            if isempty(locs_max)
                height = height - 0.01;
            end
        elseif y<x
            
            [peak_max,locs_max] = findpeaks(pulse_sound_temp, 'MinPeakHeight', height);
        
        
            if length(locs_max) > 1
               height = height + 0.1;
            end
        
            if length(locs_max) == 1
                marker = 0;
                locations_Peak = m + locs_max;
            end
            if isempty(locs_max)
                height = height - 0.01;
            end
            
            
        end
    end 
    
    
    
end

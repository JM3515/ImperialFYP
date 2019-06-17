function crossings = zeroCrossings(pulse_sound)
crossings=0;

for v = 1:1:(length(pulse_sound)-1)
    
    if pulse_sound(v) > 0
        if pulse_sound(v+1) <0
            crossings = crossings + 1;
        end 
    end
    
    if pulse_sound(v) < 0
        if pulse_sound(v+1) > 0
            crossings = crossings + 1;
        end
    end
    
end

    
end


function [tsound_temp, pulse_sound_temp] = extractSectionSpecific(tsound,pulse_sound, section, width)


front = 0;
back = 0;
sectionWidth = width;

if section == 1
    
    front = 1;
    back = sectionWidth;

else 
    
    front = 1 + ((width/2) * section);
    back = sectionWidth + ((width/2) * section);

end


tsound_temp = tsound(front:back);
pulse_sound_temp = pulse_sound(front:back);


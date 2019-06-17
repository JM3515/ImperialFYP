function [tsound_temp, pulse_sound_temp] = extractSection(tsound,pulse_sound,section,sectionWidth)


front = 0;
back = 0;

if section ==1
    front = 1;
    back = sectionWidth;

else 
    front = 1 + ((sectionWidth/2) * (section-1));
    back = sectionWidth + ((sectionWidth/2) * (section-1));
end
tsound_temp = tsound(front:back);
pulse_sound_temp = pulse_sound(front:back);


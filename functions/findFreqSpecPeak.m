function  frequency = findFreqSpecPeak(pulse_sound)



%find largest frequencies within the FFT 
[f, P1] = fftFunction(pulse_sound);
    
[pks,locs] = findpeaks(P1);
    

    
   
    
    %find the frequecy with the largest power within FFT
len = length(P1);
P2 = P1(2:len);
w = max(P2);
w = find(pks == w);
     
w = f(locs(w)); % w is the largest frequency
    
frequency = w;
% 
%     figure;hold on;
%     plot(f, P1, 'linewidth', 1);
%     xlim([1, 150]);
%     title('FFT');
%     xlabel('Frequency /Hz');
%     ylabel('Power');
%     set(gca, 'fontsize', 16);
%     grid on; grid minor; box on;
end
    
    






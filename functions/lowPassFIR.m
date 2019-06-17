function pulse_sound_filtered = lowPassFIR(pulse_sound)


fc = 30;
fs = 2100;

[b,a] = butter(10,fc/(fs/2));
% fvtool(b,a)
pulse_sound_filtered = filtfilt(b,a,pulse_sound);

end



% N   = 300;        % FIR filter order
% Fp  = 30;       % 20 kHz passband-edge frequency
% Fs  = 2100;       % 96 kHz sampling frequency
% Rp  = 0.00057565; % Corresponds to 0.01 dB peak-to-peak ripple
% Rst = 0.05e-4;       % Corresponds to 80 dB stopband attenuation
% 
% eqnum = firceqrip(N,Fp/(Fs/2),[Rp Rst],'passedge'); % eqnum = vec of coeffs
% 
% % fvtool(eqnum,'Fs',Fs,'Color','White'); % Visualize filter
% 
% % lowpassFIR = dsp.LMSFilter('Numerator',eqnum);
% lowpassFIR = dsp.FIRFilter('Numerator',eqnum); %or eqNum200 or numMinOrder
% % fvtool(lowpassFIR,'Fs',Fs,'Color','White');% Visualize filter
% 
% pulse_sound_filtered = lowpassFIR(pulse_sound);

% aliasing 
% f/2 2100/2
% 100hz



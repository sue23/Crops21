function [emg_bandPass, envelope] = EMGAnalysis( emg_raw,Fs )
% Funzione per filtrare passa-banda,rettificare, 
%filtrare passa-basso per ottenere
% l'inviluppo y_env
%%input: emg raw and Fs=1000Hz sampling frequency
%%%output: rwa emg and envelope



n = 100;                                % n=order of the filter

Wn = [20 350]/(Fs/2);                   % Wn=bands of the filter
ftype = 'bandpass';
[b,a] = fir1(n,Wn,ftype);               %returns an order N bandpass filter with passband Wn
% emg_bandPass= filtfilt(b,a,[emg_raw(1)*ones(50,1) ; emg_raw]); 
emg_bandPass= filtfilt(b,a,emg_raw); 

                         
rec_emg = abs(emg_bandPass);%rectification of the EMG signal


Fc= 4; %4;->de Luca
N = 2; %4; 
Wn = Fc/(Fs/2);
[B, A] = butter(N,Wn, 'low'); %filter's parameters
envelope=filtfilt(B, A, rec_emg); %in the case of Off-line treatment
%envelope=envelope
end


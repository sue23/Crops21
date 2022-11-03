
function [prematfilec3d]=emgroutine(emg_clean_r,emg_clean_l,fr)

%% Emgroutine
% - input : emg left and right (raw or with peaks removed)
% - output - struct: envelope and "clean" emg signal

for i=1:size(emg_clean_r,2)
    [emgBP_r(:,i), env_r(:,i)] = EMGAnalysis(emg_clean_r(:,i),fr); % Output: envelope and "clean" emg
    loc_0=find(env_r(:,i)==0);
    for l1=1:length(loc_0)  %Remove zero values and and assigne NAN
        levemg_clean_la=loc_0(l1)-500:loc_0(l1)+500;
        leva(leva<=0)=[];
        leva(leva>length(env_r))=[];
        env_r(leva,i)=nan;
    end

end
    





for i=1:size(emg_clean_l,2)
    [emgBP_l(:,i), env_l(:,i)] = EMGAnalysis(emg_clean_l(:,i),fr); % Questa funzione mi estrae l'inviluppo e il segnale pulito
    loc_0=find(env_l(:,i)==0);
    for l1=1:length(loc_0)  % Faccio un ciclo for per eliminare i valori pari a zero e li faccio diventare dei nan
        levemg_clean_la=loc_0(l1)-500:loc_0(l1)+500;
        leva(leva<=0)=[];
        leva(leva>length(env_l))=[];
        env_l(leva,i)=nan;
    end
   
end

prematfilec3d.emgBP=cat(3,emgBP_r,emgBP_l);
prematfilec3d.env=cat(3,env_r,env_l);





end


















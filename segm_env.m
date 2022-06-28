function [segm_envel]=segm_env(c3d,prematfilec3d)
%% Segm_env
% input: matfilec3d, prematfilec3d
% output: a struct with: envelope (8*100), percleft/right toeoff,
%         normamplitude (8*step*100)

 if ~isnan(c3d.infostruct.analog.footstrike1(1,1)) % if left exist

tmpPercleft_footoff=[]; % calculate the toe off % for the left side
for k=1:size(c3d.infostruct.analog.footstrike1,1) % steps number
    if isnan(c3d.infostruct.analog.footstrike1(1,1)) && isnan(c3d.infostruct.analog.footstrike2(1,1))
        continue
    else
        l_time=(c3d.infostruct.analog.footstrike2(k,1)-c3d.infostruct.analog.footstrike1(k,1))/c3d.infostruct.Frame_rate_analog;
        tmpPercleft_footoff=[tmpPercleft_footoff; (c3d.infostruct.analog.footoff(k,1)-c3d.infostruct.analog.footstrike1(k,1))/c3d.infostruct.Frame_rate_analog/l_time*100];
        
        
    end
end

Percleft_footoff=tmpPercleft_footoff;

%% Envelop
% Left envelop
u=1; %giunti
for i=1:length(c3d.muscle_lab_left) %muscle
    tmp_left_env=[];
    
    if isnan(c3d.infostruct.analog.footstrike1(1,1)) || isnan(c3d.infostruct.analog.footstrike2(1,1))% se è nan vado alla prova successiva
        
        continue
    else
        for j=1:size(c3d.infostruct.analog.footstrike1,1) % step for trial
            nc = length(c3d.infostruct.analog.footstrike1(j,1):c3d.infostruct.analog.footstrike2(j,1)); % nc is the length
            oldtime=1:nc;  % old time
            newtime= linspace(1, nc,100);   %  new time, is a % of gait cycle
            if nc>1 % i have a value!
                if ~isnan(c3d.infostruct.analog.footstrike2(j,1))
                    if  ~isempty( prematfilec3d.env_l) &&  size( prematfilec3d.env_l,1)>c3d.infostruct.analog.footstrike2(j,1)
                        tmp_left_env= [ tmp_left_env; interp1(oldtime, prematfilec3d.env_l(c3d.infostruct.analog.footstrike1(j,1):c3d.infostruct.analog.footstrike2(j,1),i)',newtime,'linear')];
                        
                    end
                end
            else
                
                continue
            end
        end
        
    end
    
    left_env_perc(u,:,:)= tmp_left_env;
    
    u=u+1;
end



tmp_norm_lef_env=[];
tmp_mean_norm_left=[];
for p=1:size(left_env_perc,2) % steps
    
    left_env1=left_env_perc(:,p,:);
    tmp_norm_lef_env=[tmp_norm_lef_env reshape(left_env1,8,100)]; % vector: [muscle channel; step*frame]left_env_perc{y}(:,p,:)
    tmp_mean_norm_left=[tmp_mean_norm_left  nanmean(tmp_norm_lef_env,2)];
end
norm_left_env= tmp_norm_lef_env./nanmean(tmp_norm_lef_env,2);
mean_norm_left=tmp_mean_norm_left;

u=1; % joint
for i=1:length(norm_left_env)/100
    normamplitude_left_env(:,i,:)=norm_left_env(:,100*(i-1)+1:100*(i-1)+100);
end



for j=1:size(normamplitude_left_env,1) % channel
    subplot(8,2,2*j-1)
    hold on
    
    
    left_mean_env(j,:,:)=nanmean(normamplitude_left_env(j,:,:));
    left_std_env(j,:,:)=nanstd(normamplitude_left_env(j,:,:));
    
end



segm_envel.Percleft_footoff=Percleft_footoff;
segm_envel.left_mean_env= left_mean_env;
segm_envel.left_std_env =left_std_env;
segm_envel.normamplitude_left_env =normamplitude_left_env;
 end


%% Segmentazione right
 if ~isnan(c3d.infostruct.analog.footstrike1(1,2))
tmpPercright_footoff=[];
for k=1:size(c3d.infostruct.analog.footstrike1,1)
    if isnan(c3d.infostruct.analog.footstrike1(1,2)) && isnan(c3d.infostruct.analog.footstrike2(1,2)) %|| isempty(TRJ{y}{j})
        continue
    else
        r_time=(c3d.infostruct.analog.footstrike2(k,2)-c3d.infostruct.analog.footstrike1(k,2))/c3d.infostruct.Frame_rate_analog;
        tmpPercright_footoff=[tmpPercright_footoff; (c3d.infostruct.analog.footoff(k,2)-c3d.infostruct.analog.footstrike1(k,2))/c3d.infostruct.Frame_rate_analog/r_time*100];
        
        
    end
end
Percright_footoff=tmpPercright_footoff;



u=1; %giunti

for i=1:8 %i => u, sono i giunti, eseguo incremento sui giunti
    tmp_right_env=[];
    
    
    if isnan(c3d.infostruct.analog.footstrike1(1,2)) || isnan(c3d.infostruct.analog.footstrike2(1,2))% se è nan vado alla prova successiva
        
        continue
    else
        for j=1:size(c3d.infostruct.analog.footstrike1,1) % scorri i passi per ciascuna prova
            nc = length(c3d.infostruct.analog.footstrike1(j,2):c3d.infostruct.analog.footstrike2(j,2)); % mi trovo nc come lunghezza
            oldtime=1:nc;  % mi calcolo old time
            newtime= linspace(1, nc,100);   % mi calcolo new time, è una % sul ciclo del passo
            if nc>1 % significa che ho un valore, se no sarebbe vuoto
                if ~isnan(c3d.infostruct.analog.footstrike2(j,2))
                    if  ~isempty(prematfilec3d.env_r) &&  size(prematfilec3d.env_r,1)>c3d.infostruct.analog.footstrike2(j,2)
                        
                        tmp_right_env= [ tmp_right_env; interp1(oldtime,prematfilec3d.env_r(c3d.infostruct.analog. footstrike1(j,2):c3d.infostruct.analog.footstrike2(j,2),i)',newtime,'linear')];
                        
                        
                    end
                end
            else
                
                continue
            end
        end
        
    end
    
    right_env_perc(u,:,:)= tmp_right_env;
    
    
    u=u+1;
end


tmp_norm_right_env=[];
tmp_mean_norm_right=[];

for p=1:size(right_env_perc,2) % ciclo for per i passi
    
    right_env1=right_env_perc(:,p,:);
    tmp_norm_right_env=[tmp_norm_right_env reshape(right_env1,8,100)]; % in questo modo ottengo un vettore con il [numero dei muscoli; passi*frame]left_env_perc{y}(:,p,:
    tmp_mean_norm_right=[tmp_mean_norm_right,nanmean(tmp_norm_right_env,2)];
    
    
end
norm_right_env= tmp_norm_right_env./nanmean(tmp_norm_right_env,2);
mean_norm_right=tmp_mean_norm_right;





%% Inviluppo

for i=1:length(norm_right_env)/100
    normamplitude_right_env(:,i,:)=norm_right_env(:,100*(i-1)+1:100*(i-1)+100);
end

for j=1:size(normamplitude_right_env,1) % per ogni muscolo
    right_mean_env(j,:,:)=nanmean(normamplitude_right_env(j,:,:));
    right_std_env(j,:,:)=nanstd(normamplitude_right_env(j,:,:));
end

% Save in a struct
segm_envel.Percright_footoff=Percright_footoff;
segm_envel.right_mean_env= right_mean_env;
segm_envel.right_std_env =right_std_env;
segm_envel.normamplitude_right_env =normamplitude_right_env;

 end
end
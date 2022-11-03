function [ events]=extrapolate_events(events,markers)


if isfield(events,'events') && ~isempty(events.events.general.event.vframe) & length(events.events.general.event.vframe)>1
    lim1 = events.events.general.event.vframe(1);
    lim2 = events.events.general.event.vframe(2);
    %ylasi-ylank
    Dyl1 = markers(1:lim1,2,2) - markers(1:lim1,2,1);
    Dyl2 = markers(lim2:end,2,2) - markers(lim2:end,2,1);
    % strikel = events_matrix(sum(events_matrix(:,2:3),2)==2,1);
    
    Dyr1 = markers(1:lim1,2,4) - markers(1:lim1,2,3);
    Dyr2 = markers(lim2:end,2,4) - markers(lim2:end,2,3);
    % striker = events_matrix(sum(events_matrix(:,2:3),2)==3,1);
    
    fillNaN_L=1:size(Dyl1,1);
    Dyl1(isnan(Dyl1)) = interp1(fillNaN_L(~isnan(Dyl1)),Dyl1(~isnan(Dyl1)),fillNaN_L(isnan(Dyl1))) ;
    fillNaN_R=1:size(Dyr1,1);
    Dyr1(isnan(Dyr1)) = interp1(fillNaN_R(~isnan(Dyr1)),Dyr1(~isnan(Dyr1)),fillNaN_R(isnan(Dyr1))) ;
    fillNaN_L=1:size(Dyl2,1);
    Dyl2(isnan(Dyl2)) = interp1(fillNaN_L(~isnan(Dyl2)),Dyl2(~isnan(Dyl2)),fillNaN_L(isnan(Dyl2))) ;
    fillNaN_R=1:size(Dyr2,1);
    Dyr2(isnan(Dyr2)) = interp1(fillNaN_R(~isnan(Dyr2)),Dyr2(~isnan(Dyr2)),fillNaN_R(isnan(Dyr2))) ;
    
    delta = markers(end,2,1)-markers(1,2,1);%markers(end,2)-markers(1,2);  %%orientazione gait: Yank(1)-Yank(end)
    if delta>0     %%decrescente
        [~,l_hs1]=findpeaks(-Dyl1,'MinPeakProminence',50);
        [~,l_hs2]=findpeaks(Dyl2,'MinPeakProminence',50);
%         l_hs2 = l_hs2+lim2;
        
        [~,r_hs1]=findpeaks(-Dyr1,'MinPeakProminence',50);
        [~,r_hs2]=findpeaks(Dyr2,'MinPeakProminence',50);
%         r_hs2 = r_hs2+lim2;
        
        [~,l_fo1]=findpeaks(Dyl1,'MinPeakProminence',50);
        [~,l_fo2]=findpeaks(-Dyl2,'MinPeakProminence',50);
%         l_fo2 = l_fo2+lim2;
        
        [~,r_fo1]=findpeaks(Dyr1,'MinPeakProminence',50);
        [~,r_fo2]=findpeaks(-Dyr2,'MinPeakProminence',50);
%         r_fo2 = r_fo2+lim2;
    else
        [~,l_hs1]=findpeaks(Dyl1,'MinPeakProminence',50);
        [~,l_hs2]=findpeaks(-Dyl2,'MinPeakProminence',50);
        
        
        [~,r_hs1]=findpeaks(Dyr1,'MinPeakProminence',50);
        [~,r_hs2]=findpeaks(-Dyr2,'MinPeakProminence',50);
        
        
        [~,l_fo1]=findpeaks(-Dyl1,'MinPeakProminence',50);
        [~,l_fo2]=findpeaks(Dyl2,'MinPeakProminence',50);
        
        
        [~,r_fo1]=findpeaks(-Dyr1,'MinPeakProminence',50);
        [~,r_fo2]=findpeaks(Dyr2,'MinPeakProminence',50);
        
    end
    
    
    if l_fo1(1)<l_hs1(1)
        l_fo1(1)=[];
    end
    if l_fo1(end)>l_hs1(end)
        l_fo1(end)=[];
    end
    
    if r_fo1(1)<r_hs1(1)
        r_fo1(1)=[];
    end
    if r_fo1(end)>r_hs1(end)
        r_fo1(end)=[];
    end
    
    
    if l_fo2(1)<l_hs2(1)
        l_fo2(1)=[];
    end
    if l_fo2(end)>l_hs2(end)
        l_fo2(end)=[];
    end
    
    if r_fo2(1)<r_hs2(1)
        r_fo2(1)=[];
    end
    if r_fo2(end)>r_hs2(end)
        r_fo2(end)=[];
    end
    
    figure
    subplot(2,2,1)
    sample=1:1:size(Dyl1,1);
    plot(sample,Dyl1)
    hold on
    plot(sample(l_hs1),Dyl1(l_hs1),'dr')
    plot(sample(l_fo1),Dyl1(l_fo1),'*r')
    title('Left1')
    
    
    subplot(2,2,2)
    sample=1:1:size(Dyl2,1);
    plot(sample,Dyl2)
    hold on
    plot(sample(l_hs2),Dyl2(l_hs2),'dr')
    plot(sample(l_fo2),Dyl2(l_fo2),'*r')
    title('Left2')
    
    subplot(2,2,3)
    sample=1:1:size(Dyr1,1);
    plot(sample,Dyr1)
    hold on
    plot(sample(r_hs1),Dyr1(r_hs1),'dr')
    plot(sample(r_fo1),Dyr1(r_fo1),'*r')
    title('Right1')
    
    subplot(2,2,4)
    sample=1:1:size(Dyr2,1);
    plot(sample,Dyr2)
    hold on
    plot(sample(r_hs2),Dyr2(r_hs2),'dr')
    plot(sample(r_fo2),Dyr2(r_fo2),'*r')
    title('Right2')
    
    l_hs2 = l_hs2+lim2;
    r_hs2 = r_hs2+lim2;
    l_fo2 = l_fo2+lim2;
    r_fo2 = r_fo2+lim2;
    events_mat = nan*ones(2,7,2);
    if length([l_hs1; l_fo1])~=7
        v_nan = nan(7 - length([l_hs1; l_fo1]),1);
        events_mat(1,:,1)=[sort([l_hs1; l_fo1]);v_nan];
        v_nan = nan(7 - length([r_hs1; r_fo1]),1);
        events_mat(1,:,2)=[sort([r_hs1; r_fo1]); v_nan];
    else
        events_mat(1,:,1)=sort([l_hs1; l_fo1]);
        events_mat(1,:,2)=sort([r_hs1; r_fo1]);
    end
    if length([l_hs2; l_fo2])~=7
        v_nan = nan(7 - length([l_hs2; l_fo2]),1);
        events_mat(2,:,1)=[sort([l_hs2; l_fo2]);v_nan];
        v_nan = nan(7 - length([r_hs2; r_fo2]),1);
        events_mat(2,:,2)=[sort([r_hs2; r_fo2]); v_nan];
    else
        events_mat(2,:,1)=sort([l_hs2; l_fo2]);
        events_mat(2,:,2)=sort([r_hs2; r_fo2]);
    end
else
    
 try
    %ylasi-ylank
    Dyl = markers(:,2,2) - markers(:,2,1);
    % strikel = events_matrix(sum(events_matrix(:,2:3),2)==2,1);
 catch
     keyboard
 end
    Dyr = markers(:,2,4) - markers(:,2,3);
    % striker = events_matrix(sum(events_matrix(:,2:3),2)==3,1);
    
    fillNaN_L=1:size(Dyl,1);
    Dyl(isnan(Dyl)) = interp1(fillNaN_L(~isnan(Dyl)),Dyl(~isnan(Dyl)),fillNaN_L(isnan(Dyl))) ;
    fillNaN_R=1:size(Dyr,1);
    Dyr(isnan(Dyr)) = interp1(fillNaN_R(~isnan(Dyr)),Dyr(~isnan(Dyr)),fillNaN_R(isnan(Dyr))) ;
    
    delta = markers(find(~isnan(markers(:,2,1)),1,'last'),2,1)-markers(find(~isnan(markers(:,2,1)),1,'first'),2,1);  %%orientazione gait: Yank(end)-Yank(1)
    if delta>0     %%concorde con y del lab quindi hs è il minimo e fo è il massimo
        [~,l_hs]=findpeaks(-Dyl,'MinPeakProminence',max(-Dyl)/2);
        [~,r_hs]=findpeaks(-Dyr,'MinPeakProminence',max(-Dyr)/2);
        [~,l_fo]=findpeaks(Dyl,'MinPeakProminence',max(Dyl)/2);
        [~,r_fo]=findpeaks(Dyr,'MinPeakProminence',max(Dyr)/2);
    else
        [~,l_hs]=findpeaks(Dyl,'MinPeakProminence',max(Dyl)/2);
        [~,r_hs]=findpeaks(Dyr,'MinPeakProminence',max(Dyr)/2);
        [~,l_fo]=findpeaks(-Dyl,'MinPeakProminence',max(-Dyl)/2);
        [~,r_fo]=findpeaks(-Dyr,'MinPeakProminence',max(-Dyr)/2);
    end
    
    
    
    
    if l_fo(1)<l_hs(1)
        l_fo(1)=[];
    end
    if l_fo(end)>l_hs(end)
        l_fo(end)=[];
    end
    
    if r_fo(1)<r_hs(1)
        r_fo(1)=[];
    end
    if r_fo(end)>r_hs(end)
        r_fo(end)=[];
    end
    
   
    
  
  
    if length(l_hs)>length(r_hs)
        if delta>0     %%concorde con y del lab quindi posso eliminare gli ultimi passi
            l_hs = l_hs(1:end-(length(l_hs)-length(r_hs)));
            l_fo = l_fo(1:end-(length(l_fo)-length(r_fo)));
        else
            l_hs = l_hs(1+(length(l_hs)-length(r_hs)):end);
            l_fo = l_fo(1+(length(l_fo)-length(r_fo)):end);
        end
    end

    if length(r_hs)>length(l_hs)
        if delta>0     %%concorde con y del lab quindi posso eliminare gli ultimi passi
            r_hs = r_hs(1:end-(length(r_hs)-length(l_hs)));
            r_fo = r_fo(1:end-(length(r_fo)-length(l_fo)));
        else
            r_hs = r_hs(1+(length(r_hs)-length(l_hs)):end);
            r_fo = r_fo(1+(length(r_fo)-length(l_fo)):end);
        end
    end
    
    events.events.left.footstrike.vframe = sort([l_hs]);
    events.events.left.footoff.vframe = sort([l_fo]);
    events.events.right.footstrike.vframe = sort([r_hs]);
    events.events.right.footoff.vframe = sort([r_fo]);
  
    events.events.left.footstrike.aframe = sort([l_hs])*events.analog_fs/events.video_fs;
    events.events.left.footoff.aframe = sort([l_fo])*events.analog_fs/events.video_fs;
    events.events.right.footstrike.aframe = sort([r_hs])*events.analog_fs/events.video_fs;
    events.events.right.footoff.aframe = sort([r_fo])*events.analog_fs/events.video_fs;

    events.events.left.footstrike.time=events.events.left.footstrike.aframe/events.analog_fs;
    events.events.left.footoff.time = events.events.left.footoff.aframe /events.analog_fs;
    events.events.right.footstrike.time = events.events.right.footstrike.aframe /events.analog_fs;
    events.events.right.footoff.time=events.events.right.footoff.aframe /events.analog_fs;
end


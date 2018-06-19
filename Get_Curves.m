function [  Angles, Kinetic ] = Get_Curves( Angles_ul_100, Angles_ll_100, Powers_100,TotPowers_100, Moments_100, subj, ntrial, nside, answer, side )
global Angles Kinetic

%sinistro e destro separati

if nside == 2
    
    Angles.Joint_angles_names = {'lneckangles','rneckangles','lshoulderangles',...
        'rshoulderangles','lelbowangles','relbowangles',...
        'lwristangles','rwristangles','lheadangles','rheadangles',...
        'lpelvisangles', 'rpelvisangles', 'lhipangles', 'rhipangles',...
        'lkneeangles', 'rkneeangles', 'lankleangles',...
        'rankleangles', 'lthoraxangles', 'rthoraxangles'...
        'lfootprogressangles','rfootprogressangles'};
    Kinetic.power_joints_names = {'lhippower','rhippower','lkneepower','rkneepower','lanklepower','ranklepower'};
    Kinetic.moments_joints_names = {'lhipmoment', 'rhipmoment', 'lkneemoment', 'rkneemoment', 'lanklemoment', 'ranklemoment'};
    
    
    
    %controllo tutti i giunti un trial alla volta se ci sono dei nan li
    %escludo dalla curva media. Lo vedo solo su un piano
    %UL
    tmptmp1=ones(100,3,10)*nan;
    tmptmp3=ones(100,3,12)*nan;
    if ~isempty(Angles_ul_100)
        trial1 = find(squeeze(sum(isnan(Angles_ul_100(:,1,:,1))))==0); %trial 1
        trial2 = find(squeeze(sum(isnan(Angles_ul_100(:,1,:,2))))==0); %trial 2
        if ntrial>2; trial3 = find(squeeze(sum(isnan(Angles_ul_100(:,1,:,3))))==0); end %trial 3
        
        tmptmp1=Angles_ul_100*nan;
        if ~isempty(trial1)
            tmp1 =Angles_ul_100(:,:,:,1);
            tmptmp1(:,:,trial1,1)=tmp1(:,:,trial1);
        end
        if ~isempty(trial2)
            tmp2 =Angles_ul_100(:,:,:,2);
            tmptmp1(:,:,trial2,2)=tmp2(:,:,trial2);
        end
        if ntrial>2 & ~isempty(trial3)
            tmp3 =Angles_ul_100(:,:,:,3);
            tmptmp1(:,:,trial3,3)=tmp3(:,:,trial3);
        end
    end
    %LL
    trial1 = find(squeeze(sum(isnan(Angles_ll_100(:,1,:,1))))==0); %trial 1
    trial2 = find(squeeze(sum(isnan(Angles_ll_100(:,1,:,2))))==0); %trial 2
    if ntrial>2; trial3 = find(squeeze(sum(isnan(Angles_ll_100(:,1,:,3))))==0);end %trial 3
    
    tmptmp3=Angles_ll_100*nan;
    if ~isempty(trial1)
        tmp1 =Angles_ll_100(:,:,:,1);
        tmptmp3(:,:,trial1,1)=tmp1(:,:,trial1);
    end
    if ~isempty(trial2)
        tmp2 =Angles_ll_100(:,:,:,2);
        tmptmp3(:,:,trial2,2)=tmp2(:,:,trial2);
    end
    if ntrial>2 & ~isempty(trial3)
        tmp3 =Angles_ll_100(:,:,:,3);
        tmptmp3(:,:,trial3,3)=tmp3(:,:,trial3);
    end
    
    Angles.Avg_trial_angles100(:,:,:,subj) =  cat(3, nanmean(tmptmp1,4), nanmean(tmptmp3,4));
    
    
    %controllo tutti i giunti un trial alla volta se ci sono dei nan li escludo dalla curva media. Lo vedo solo su un piano
    
        %power
        trial1 = find(squeeze(sum(isnan(Powers_100(:,1,:,1))))==0); %trial 1
        trial2 = find(squeeze(sum(isnan(Powers_100(:,1,:,2))))==0); %trial 2
        if ntrial>2; trial3 = find(squeeze(sum(isnan(Powers_100(:,1,:,3))))==0); end %trial 3
        
        tmptmp1=Powers_100*nan;
        if ~isempty(trial1)
            tmp1 =Powers_100(:,:,:,1);
            tmptmp1(:,:,trial1,1)=tmp1(:,:,trial1);
        end
        if ~isempty(trial2)
            tmp2 =Powers_100(:,:,:,2);
            tmptmp1(:,:,trial2,2)=tmp2(:,:,trial2);
        end
        if ntrial>2 & ~isempty(trial3)
            tmp3 =Powers_100(:,:,:,3);
            tmptmp1(:,:,trial3,3)=tmp3(:,:,trial3);
        end
        
        
        %Moments
        trial1 = find(squeeze(sum(isnan(Moments_100(:,1,:,1))))==0); %trial 1
        trial2 = find(squeeze(sum(isnan(Moments_100(:,1,:,2))))==0); %trial 2
        if ntrial>2; trial3 = find(squeeze(sum(isnan(Moments_100(:,1,:,3))))==0);end %trial 3
        
        tmptmp3=Moments_100*nan;
        if ~isempty(trial1)
            tmp1 =Moments_100(:,:,:,1);
            tmptmp3(:,:,trial1,1)=tmp1(:,:,trial1);
        end
        if ~isempty(trial2)
            tmp2 =Moments_100(:,:,:,2);
            tmptmp3(:,:,trial2,2)=tmp2(:,:,trial2);
        end
        if ntrial>2 & ~isempty(trial3)
            tmp3 =Moments_100(:,:,:,3);
            tmptmp3(:,:,trial3,3)=tmp3(:,:,trial3);
        end
        
        Kinetic.Avg_trial_power100(:,:,:,subj) =  nanmean(tmptmp1,4);
        Kinetic.Avg_trial_moments100(:,:,:,subj) =  nanmean(tmptmp3,4);
        Kinetic.Avg_trial_totpower100(:,:,subj) = nanmean(TotPowers_100,3);
else
    
    %salvo una sola linea
    Angles.Joint_angles_names = {'Neck','Shoulder','Elbow',...
        'Wrist','Head','Pelvis','Hip','Knee',...
        'Ankle', 'Thorax','FPA'};
    Kinetic.moments_joints_names = {'Hip Moment', 'Knee Moment', 'Ankle Moment'};
    Kinetic.power_joints_names = {'Hip Power','Knee Power','Ankle Power'};
    
    
    
    
    njoint = size(Angles_ul_100,3);
    %controllo tutti i giunti un trial alla volta se ci sono dei nan li
    %escludo dalla curva media. Lo vedo solo su un piano
    %UL
    tmptmp1=ones(100,3,5,3)*nan;tmptmp2=ones(100,3,5,3)*nan;
    tmptmp3=ones(100,3,6,3)*nan;tmptmp4=ones(100,3,6,3)*nan;
    if ~isempty(Angles_ul_100)
        trial1l = find(squeeze(sum(isnan(Angles_ul_100(:,1,1:2:njoint,1))))==0); %trial 1
        trial2l = find(squeeze(sum(isnan(Angles_ul_100(:,1,1:2:njoint,2))))==0); %trial 2
        if ntrial>2; trial3l = find(squeeze(sum(isnan(Angles_ul_100(:,1,1:2:njoint,3))))==0); end %trial 3
        trial1r = find(squeeze(sum(isnan(Angles_ul_100(:,1,2:2:njoint,1))))==0); %trial 1
        trial2r = find(squeeze(sum(isnan(Angles_ul_100(:,1,2:2:njoint,2))))==0); %trial 2
        if ntrial>2; trial3r = find(squeeze(sum(isnan(Angles_ul_100(:,1,2:2:njoint,3))))==0);end %trial 3
        tmptmp1=Angles_ul_100(:,:,1:2:njoint,:)*nan;tmptmp2=Angles_ul_100(:,:,2:2:njoint,:)*nan;
        if ~isempty(trial1l)
            tmp1 =Angles_ul_100(:,:,1:2:njoint,1);
            tmptmp1(:,:,trial1l,1)=tmp1(:,:,trial1l);
        end
        if ~isempty(trial2l)
            tmp2 =Angles_ul_100(:,:,1:2:njoint,2);
            tmptmp1(:,:,trial2l,2)=tmp2(:,:,trial2l);
        end
        if ntrial>2 & ~isempty(trial3l)
            tmp3 =Angles_ul_100(:,:,1:2:njoint,3);
            tmptmp1(:,:,trial3l,3)=tmp3(:,:,trial3l);
        end
        if ~isempty(trial1r)
            tmp1 =Angles_ul_100(:,:,2:2:njoint,1);
            tmptmp2(:,:,trial1r,1)=tmp1(:,:,trial1r);
        end
        if ~isempty(trial2r)
            tmp2 =Angles_ul_100(:,:,2:2:njoint,2);
            tmptmp2(:,:,trial2r,2)=tmp2(:,:,trial2r);
        end
        if ntrial>2 & ~isempty(trial3r)
            tmp3 =Angles_ul_100(:,:,2:2:njoint,3);
            tmptmp2(:,:,trial3r,3)=tmp3(:,:,trial3r);
        end
    end
    %LL
    njoint = size(Angles_ll_100,3);
    trial1l = find(squeeze(sum(isnan(Angles_ll_100(:,1,1:2:njoint,1))))==0); %trial 1
    trial2l = find(squeeze(sum(isnan(Angles_ll_100(:,1,1:2:njoint,2))))==0); %trial 2
    if ntrial>2; trial3l = find(squeeze(sum(isnan(Angles_ll_100(:,1,1:2:njoint,3))))==0);end %trial 3
    trial1r = find(squeeze(sum(isnan(Angles_ll_100(:,1,2:2:njoint,1))))==0); %trial 1
    trial2r = find(squeeze(sum(isnan(Angles_ll_100(:,1,2:2:njoint,2))))==0); %trial 2
    if ntrial>2;trial3r = find(squeeze(sum(isnan(Angles_ll_100(:,1,2:2:njoint,3))))==0);end %trial 3
    tmptmp3=Angles_ll_100(:,:,1:2:njoint,:)*nan;tmptmp4=Angles_ll_100(:,:,2:2:njoint,:)*nan;
    if ~isempty(trial1l)
        tmp1 =Angles_ll_100(:,:,1:2:njoint,1);
        tmptmp3(:,:,trial1l,1)=tmp1(:,:,trial1l);
    end
    if ~isempty(trial2l)
        tmp2 =Angles_ll_100(:,:,1:2:njoint,2);
        tmptmp3(:,:,trial2l,2)=tmp2(:,:,trial2l);
    end
    if ntrial>2 & ~isempty(trial3l)
        tmp3 =Angles_ll_100(:,:,1:2:njoint,3);
        tmptmp3(:,:,trial3l,3)=tmp3(:,:,trial3l);
    end
    if ~isempty(trial1r)
        tmp1 =Angles_ll_100(:,:,2:2:njoint,1);
        tmptmp4(:,:,trial1r,1)=tmp1(:,:,trial1r);
    end
    if ~isempty(trial2r)
        tmp2 =Angles_ll_100(:,:,2:2:njoint,2);
        tmptmp4(:,:,trial2r,2)=tmp2(:,:,trial2r);
    end
    if ntrial>2 & ~isempty(trial3r)
        tmp3 =Angles_ll_100(:,:,2:2:njoint,3);
        tmptmp4(:,:,trial3r,3)=tmp3(:,:,trial3r);
    end
    
    if strcmp(answer,'2')
        Angles.Avg_trial_angles100(:,:,:,subj) =  cat(3, nanmean(cat(4,tmptmp1, tmptmp2),4), nanmean(cat(4,tmptmp3, tmptmp4),4));
    else
        if strcmp(side,'1')
            Angles.Avg_trial_angles100(:,:,:,subj) =  cat(3, nanmean(tmptmp1,4), nanmean(tmptmp3,4));
        else
            Angles.Avg_trial_angles100(:,:,:,subj) =  cat(3, nanmean(tmptmp2,4), nanmean(tmptmp4,4));
        end
    end
    
    
        njoint = size(Powers_100,3);
        %controllo tutti i giunti un trial alla volta se ci sono dei nan li escludo dalla curva media.
        % Lo vedo solo su un piano
        
        %power
        trial1l = find(squeeze(sum(isnan(Powers_100(:,1,1:2:njoint,1))))==0); %trial 1
        trial2l = find(squeeze(sum(isnan(Powers_100(:,1,1:2:njoint,2))))==0); %trial 2
        if ntrial>2; trial3l = find(squeeze(sum(isnan(Powers_100(:,1,1:2:njoint,3))))==0); end %trial 3
        
        trial1r = find(squeeze(sum(isnan(Powers_100(:,1,2:2:njoint,1))))==0); %trial 1
        trial2r = find(squeeze(sum(isnan(Powers_100(:,1,2:2:njoint,2))))==0); %trial 2
        if ntrial>2; trial3r = find(squeeze(sum(isnan(Powers_100(:,1,2:2:njoint,3))))==0); end %trial 3
        tmptmp1=Powers_100(:,:,1:2:njoint,:)*nan;tmptmp2=Powers_100(:,:,2:2:njoint,:)*nan;
        if ~isempty(trial1l)
            tmp1 =Powers_100(:,:,1:2:njoint,1);
            tmptmp1(:,:,trial1l,1)=tmp1(:,:,trial1l);
        end
        if ~isempty(trial2l)
            tmp2 =Powers_100(:,:,1:2:njoint,2);
            tmptmp1(:,:,trial2l,2)=tmp2(:,:,trial2l);
        end
        if ntrial>2 & ~isempty(trial3l)
            tmp3 =Powers_100(:,:,1:2:njoint,3);
            tmptmp1(:,:,trial3l,3)=tmp3(:,:,trial3l);
        end
        if ~isempty(trial1r)
            tmp1 =Powers_100(:,:,2:2:njoint,1);
            tmptmp2(:,:,trial1r,1)=tmp1(:,:,trial1r);
        end
        if ~isempty(trial2r)
            tmp2 =Powers_100(:,:,2:2:njoint,2);
            tmptmp2(:,:,trial2r,2)=tmp2(:,:,trial2r);
        end
        if ntrial>2 & ~isempty(trial3r)
            tmp3 =Powers_100(:,:,2:2:njoint,3);
            tmptmp2(:,:,trial3r,3)=tmp3(:,:,trial3r);
        end
        
        %Moments
        
        njoint = size(Moments_100,3);
        
        trial1l = find(squeeze(sum(isnan(Moments_100(:,1,1:2:njoint,1))))==0); %trial 1
        trial2l = find(squeeze(sum(isnan(Moments_100(:,1,1:2:njoint,2))))==0); %trial 2
        if ntrial>2; trial3l = find(squeeze(sum(isnan(Moments_100(:,1,1:2:njoint,3))))==0);end %trial 3
        trial1r = find(squeeze(sum(isnan(Moments_100(:,1,2:2:njoint,1))))==0); %trial 1
        trial2r = find(squeeze(sum(isnan(Moments_100(:,1,2:2:njoint,2))))==0); %trial 2
        if ntrial>2;trial3r = find(squeeze(sum(isnan(Moments_100(:,1,2:2:njoint,3))))==0);end %trial 3
        tmptmp3=Moments_100(:,:,1:2:njoint,:)*nan;tmptmp4=Moments_100(:,:,2:2:njoint,:)*nan;
        if ~isempty(trial1l)
            tmp1 =Moments_100(:,:,1:2:njoint,1);
            tmptmp3(:,:,trial1l,1)=tmp1(:,:,trial1l);
        end
        if ~isempty(trial2l)
            tmp2 =Moments_100(:,:,1:2:njoint,2);
            tmptmp3(:,:,trial2l,2)=tmp2(:,:,trial2l);
        end
        if ntrial>2 & ~isempty(trial3l)
            tmp3 =Moments_100(:,:,1:2:njoint,3);
            tmptmp3(:,:,trial3l,3)=tmp3(:,:,trial3l);
        end
        if ~isempty(trial1r)
            tmp1 =Moments_100(:,:,2:2:njoint,1);
            tmptmp4(:,:,trial1r,1)=tmp1(:,:,trial1r);
        end
        if ~isempty(trial2r)
            tmp2 =Moments_100(:,:,2:2:njoint,2);
            tmptmp4(:,:,trial2r,2)=tmp2(:,:,trial2r);
        end
        if ntrial>2 & ~isempty(trial3r)
            tmp3 =Moments_100(:,:,2:2:njoint,3);
            tmptmp4(:,:,trial3r,3)=tmp3(:,:,trial3r);
        end
        
        if strcmp(answer,'2')
            Kinetic.Avg_trial_power100(:,:,:,subj) = nanmean(cat(4,tmptmp1, tmptmp2),4); %media sui trial
            Kinetic.Avg_trial_moments100(:,:,:,subj) = nanmean(cat(4,tmptmp3, tmptmp4),4);
            Kinetic.Avg_trial_totpower100(:,subj) = nanmean(squeeze(cat(3,TotPowers_100(:,1,:),TotPowers_100(:,2,:))),2);
        else
            if strcmp(side,'1')
                Kinetic.Avg_trial_power100(:,:,:,subj) =  nanmean(tmptmp1,4);
                Kinetic.Avg_trial_moments100(:,:,:,subj) =  nanmean(tmptmp3,4);
                Kinetic.Avg_trial_totpower100(:,subj) = nanmean(squeeze(TotPowers_100(:,str2num(side),:)),2);
            else
                Kinetic.Avg_trial_power100(:,:,:,subj) =  nanmean(tmptmp2,4);
                Kinetic.Avg_trial_moments100(:,:,:,subj) =  nanmean(tmptmp4,4);
                Kinetic.Avg_trial_totpower100(:,subj) = nanmean(squeeze(TotPowers_100(:,str2num(side),:)),2);
            end
        end
    
end



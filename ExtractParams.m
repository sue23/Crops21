function [Data,Data100] = ExtractParams(acqpar,AnglesUL,AnglesLL,emgBP,env,forces,CoM,Moments,Powers)
%EXTRACTPARAMS compute the GAIT paramaters
%   inputs: acqpar
%           footstrike1,footstrike2,footoff
%           Angles
%           labels
%   outputs:the struct SpatialData. this struct contains indicators for the left and the right foot.
%            - FootOff_perc
%            - StrideVelocity
%            - StrideLength
%            - StrideTime
%            - StrideWidth
%            - StepLength
%            - StanceTime
%            - SwingTime


Frame_rate = acqpar.Frame_rate;
Bodymass= acqpar.Bodymass;

footoff = acqpar.dfootoff;
footstrike1 = acqpar.dfootstrike1;
footstrike2 =acqpar.dfootstrike2;


analog_footoff = acqpar.afootoff;
analog_footstrike1 = acqpar.afootstrike1;
analog_footstrike2 =acqpar.afootstrike2;


nstride = size(footoff,1);
for s = 1:nstride
    %normalize at gait cycle
    nc = length(footstrike1(s):footstrike2(s));
    t100 = linspace(0,nc,100);
    %     Angles_ul_100 4-D 1-D: percent gait, 2-D: (x,y,z), 3-D: joints, 4-D:trials
    if ~isempty(AnglesUL)
        Angles_ul_100x= [];
        Angles_ul_100y= [];
        Angles_ul_100z= [];
        for i = 1:size(AnglesUL,3)
            Angles_ul_100x= [Angles_ul_100x interp1(1:nc,AnglesUL(footstrike1(s):footstrike2(s),1,i),t100,'linear')'];
            Angles_ul_100y= [Angles_ul_100y interp1(1:nc,AnglesUL(footstrike1(s):footstrike2(s),2,i),t100,'linear')'];
            Angles_ul_100z= [Angles_ul_100z interp1(1:nc,AnglesUL(footstrike1(s):footstrike2(s),3,i),t100,'linear')'];
        end
        Angles_ul_100(:,:,1,s)=Angles_ul_100x;
        Angles_ul_100(:,:,2,s)=Angles_ul_100y;
        Angles_ul_100(:,:,3,s)=Angles_ul_100z;
        
        %% Head parameters (first column = left, second column  = right; rows = trials)
%         % Tilt (x=1)
%         [Head.Tilt.Mean(s),Head.Tilt.Range(s), Head.Tilt.IC(s)] = get_parval(AnglesUL(footstrike1(s):footstrike2(s),1,5));
%         % Obliquity (y=2)
%         [Head.Obl.Mean(s),Head.Obl.Range(s), Head.Obl.IC(s)] = get_parval(AnglesUL(footstrike1(s):footstrike2(s),2,5));
%         % Rotation (z=3)
%         [Head.Rot.Mean(s),Head.Rot.Range(s), Head.Rot.IC(s)] = get_parval(AnglesUL(footstrike1(s):footstrike2(s),3,5));
        
        [Head.Mean(1,s),Head.Range(1,s), Head.IC(1,s)] = get_parval(AnglesUL(footstrike1(s):footstrike2(s),1,5));
        [Head.Mean(2,s),Head.Range(2,s), Head.IC(2,s)] = get_parval(AnglesUL(footstrike1(s):footstrike2(s),2,5));
        [Head.Mean(3,s),Head.Range(3,s), Head.IC(3,s)] = get_parval(AnglesUL(footstrike1(s):footstrike2(s),3,5));
        
        
        %% Neck parameters (first column = left, second column  = right; rows = trials)
        % Tilt (x)
        [Neck.Mean(1,s),Neck.Range(1,s), Neck.IC(1,s)] = get_parval(AnglesUL(footstrike1(s):footstrike2(s),1,1));
        [Neck.Mean(2,s),Neck.Range(2,s), Neck.IC(2,s)] = get_parval(AnglesUL(footstrike1(s):footstrike2(s),2,1));
        [Neck.Mean(3,s),Neck.Range(3,s), Neck.IC(3,s)] = get_parval(AnglesUL(footstrike1(s):footstrike2(s),3,1));
        
        %% Shoulder parameters (first column = left, second column  = right; rows = trials)
        % Tilt (x) FlexExt
        [Shoulder.Mean(1,s),Shoulder.Range(1,s), Shoulder.IC(1,s)] = get_parval(AnglesUL(footstrike1(s):footstrike2(s),1,2));
        % Obliquity (y) AbdAdd
        [Shoulder.Mean(2,s),Shoulder.Range(2,s), Shoulder.IC(2,s)] = get_parval(AnglesUL(footstrike1(s):footstrike2(s),2,2));
        % Rotation (z)
        [Shoulder.Mean(3,s),Shoulder.Range(3,s), Shoulder.IC(3,s)] = get_parval(AnglesUL(footstrike1(s):footstrike2(s),3,2));
        
        
        %% Elbow parameters (first column = left, second column  = right;
        
        % Tilt (x)
        [Elbow.Mean(1,s),Elbow.Range(1,s), Elbow.IC(1,s)] = get_parval(AnglesUL(footstrike1(s):footstrike2(s),1,3));
        
        
        %% Wrist parameters (first column = left, second column  = right; rows = trials)
        % Tilt (x)
        [Wrist.Mean(1,s),Wrist.Range(1,s), Wrist.IC(1,s)] = get_parval(AnglesUL(footstrike1(s):footstrike2(s),1,4));
        % Obliquity (y)
        [Wrist.Mean(2,s),Wrist.Range(2,s), Wrist.IC(2,s)] = get_parval(AnglesUL(footstrike1(s):footstrike2(s),2,4));
        % Rotation (z)
        [Wrist.Mean(3,s),Wrist.Range(3,s), Wrist.IC(3,s)] = get_parval(AnglesUL(footstrike1(s):footstrike2(s),3,4));
    end
    %% Import Angles lower limb and Thorax
    % Angles(VALUES,Plane(sagittal, frontal, rotation),SERIES(l-rpelvis, l-rhip, etc))%
    
    nc = length(footstrike1(s):footstrike2(s));
    oldtime =1:nc;
    newtime = linspace(0,nc,100);

    Angles_ll_100x= [];
    Angles_ll_100y= [];
    Angles_ll_100z= [];
    for i = 1:size(AnglesLL,3) %left - Angles_ll_100 (campioni,assi,giunto,trial)
        Angles_ll_100x= [Angles_ll_100x interp1(oldtime,AnglesLL(footstrike1(s):footstrike2(s),1,i),newtime,'linear')'];
        Angles_ll_100y= [Angles_ll_100y interp1(oldtime,AnglesLL(footstrike1(s):footstrike2(s),2,i),newtime,'linear')'];
        Angles_ll_100z= [Angles_ll_100z interp1(oldtime,AnglesLL(footstrike1(s):footstrike2(s),3,i),newtime,'linear')'];
    end
    Angles_ll_100(:,:,1,s)=Angles_ll_100x;
    Angles_ll_100(:,:,2,s)=Angles_ll_100y;
    Angles_ll_100(:,:,3,s)=Angles_ll_100z;
    
    
    %% Foot Progression angle footprogress (first column = left, second column  = right; rows = trials)
    % Rot(z) Per definizione
    [footprogress.Mean(s),footprogress.Range(s), footprogress.IC(s)] = get_parval(AnglesLL(footstrike1(s):footstrike2(s),3,6));
    % Max Rot, %
    [footprogress.RotMax(s), percind] = max((AnglesLL(footstrike1(s):footstrike2(s),3,6)));
    footprogress.RotMaxPerc(s) = percind/(footstrike2(s)-footstrike1(s))*100;
    
    % Min Rot, %
    [footprogress.RotMin(s), percind] = min((AnglesLL(footstrike1(s):footstrike2(s),3,6)));
    footprogress.RotMinPerc(s) = percind/(footstrike2(s)-footstrike1(s))*100;
    
    %% Thorax parameters (first column = left, second column  = right;rows = trials)
    % Tilt (x)
    [Thorax.Mean(1,s),Thorax.Range(1,s), Thorax.IC(1,s)] = get_parval(AnglesLL(footstrike1(s):footstrike2(s),1,5));
    % Obliquity (y)
    [Thorax.Mean(2,s),Thorax.Range(2,s), Thorax.IC(2,s)] = get_parval(AnglesLL(footstrike1(s):footstrike2(s),2,5));
    % Rotation (z)
    [Thorax.Mean(3,s),Thorax.Range(3,s), Thorax.IC(3,s)] = get_parval(AnglesLL(footstrike1(s):footstrike2(s),3,5));
    
    %% Pelvis parameters (first column = left, second column  = right; rows = trials)
    % Tilt (x)
    [Pelvis.Mean(1,s),Pelvis.Range(1,s), Pelvis.IC(1,s)] = get_parval(AnglesLL(footstrike1(s):footstrike2(s),1,1));
    % Obliquity (y)
    [Pelvis.Mean(2,s),Pelvis.Range(2,s), Pelvis.IC(2,s)] = get_parval(AnglesLL(footstrike1(s):footstrike2(s),2,1));
    % Rotation (z)
    [Pelvis.Mean(3,s),Pelvis.Range(3,s), Pelvis.IC(3,s)] = get_parval(AnglesLL(footstrike1(s):footstrike2(s),3,1));
    
    
    %% Hip parameters (first column = left, second column  = right; rows = trials)
    % Tilt (x)
    [Hip.Mean(1,s),Hip.Range(1,s), Hip.IC(1,s)] = get_parval(AnglesLL(footstrike1(s):footstrike2(s),1,2));
    % Obliquity (y)
    [Hip.Mean(2,s),Hip.Range(2,s), Hip.IC(2,s)] = get_parval(AnglesLL(footstrike1(s):footstrike2(s),2,2));
    
    % Max Flex, %
    [Hip.FlexMax(s), percind] = max((AnglesLL(footstrike1(s):footstrike2(s),1,2)));
    Hip.FlexMaxPerc(s) = percind/(footstrike2(s)-footstrike1(s))*100;
    
    % Max Ext, %
    [Hip.ExtMax(s), percind] = min((AnglesLL(footstrike1(s):footstrike2(s),1,2)));
    Hip.ExtMaxPerc(s) = percind/(footstrike2(s)-footstrike1(s))*100;
    
    % Max Abd, %
    [Hip.AddMax(s), percind] = max((AnglesLL(footstrike1(s):footstrike2(s),2,2)));
    Hip.AddMaxPerc(s) = percind/(footstrike2(s)-footstrike1(s))*100;
    
    % Min Abd, %
    [Hip.AbdMax(s), percind] = min((AnglesLL(footstrike1(s):footstrike2(s),2,2)));
    Hip.AbdMaxPerc(s) = percind/(footstrike2(s)-footstrike1(s))*100;
    
    
    %% Knee parameters (first column = left, second column  = right; rows = trials)
    % FlexExt (x)
    [Knee.Mean(1,s),Knee.Range(1,s), Knee.IC(1,s)] = get_parval(AnglesLL(footstrike1(s):footstrike2(s),1,3));
    
    ind25 = ceil((25*(footstrike2(s)-footstrike1(s)))/100);
    ind6 = ceil((6*(footstrike2(s)-footstrike1(s)))/100);
    [Knee.FlexMaxStance(s), percind] = max((AnglesLL(footstrike1(s)+ind6:footstrike1(s)+ind6+ind25,1,3)));
    Knee.FlexMaxStancePerc(s) = (ind6+percind)/(footstrike2(s)-footstrike1(s))*100;
    
    
    
    % Max Flex swing, %
    [Knee.FlexMaxSwing(s), percind] = max((AnglesLL(footoff(s):footstrike2(s),1,3)));
    Knee.FlexMaxSwingPerc(s) = (percind+footoff(s)-footstrike1(s))/(footstrike2(s)-footstrike1(s))*100; % modifica
    
    
    % Max Ext Stance, %
    [Knee.ExtMaxStance(s), percind] = min((AnglesLL(footstrike1(s):footoff(s),1,3)));
    Knee.ExtMaxStancePerc(s) = percind/(footstrike2(s)-footstrike1(s))*100;
    
%     figure
%     %             subplot(1,2,1)
%     plot(1:100,Angles_ll_100(:,3,1,s))%plot(1:100,AnglesLL(footstrike1(s,1):footstrike2(s,1),1,5))
%     hold on
%     plot(Knee.FlexMaxStancePerc(s),Knee.FlexMaxStance(s),'*')
%     plot(Knee.FlexMaxSwingPerc(s),Knee.FlexMaxSwing(s),'o')
%     plot(Knee.ExtMaxStancePerc(s),Knee.ExtMaxStance(s),'d')
    
    
    %% Ankle parameters (first column = left, second column  = right; rows = trials)
    % Flex-Extension (x)
    [Ankle.Mean(1,s),Ankle.Range(1,s), Ankle.IC(1,s)] = get_parval(AnglesLL(footstrike1(s):footstrike2(s),1,4));
    
    % Max DorsalFlex Stance, %
    [Ankle.DorsalFlexMaxStance(s), percind] = max((AnglesLL(footstrike1(s):footoff(s),1,4)));
    Ankle.DorsalFlexMaxStancePerc(s) = percind/(footstrike2(s)-footstrike1(s))*100;
    
    % Max DorsalFlex swing, %
    
    [peak_val,locs]=findpeaks((AnglesLL(footoff(s):footstrike2(s),1,4)));
    for ii = 1:numel(locs)
        perc_locs(ii) =  (locs(ii)+footoff(s)-footstrike1(s))/(footstrike2(s)-footstrike1(s))*100;
    end
    [~, tmpl] = min(perc_locs-80);
    Ankle.DorsalFlexMaxSwingPerc(s) = perc_locs(tmpl);
    Ankle.DorsalFlexMaxSwing(s) = peak_val(tmpl);
    perc_locs=[];
    peak_val = [];
    
    
    % Max PlantarFlex, %
    [Ankle.PlantarFlexMax(s), percind] = min((AnglesLL(footstrike1(s):footstrike2(s),1,4)));
    Ankle.PlantarFlexMaxPerc(s) = percind/(footstrike2(s)-footstrike1(s))*100;
    
    
%     %         TO DO: fare figura di verifica del picco
%     figure
%     plot(1:100,Angles_ll_100(:,4,1,s))%plot(1:100,AnglesLL(footstrike1(s,1):footstrike2(s,1),1,5))
%     hold on
%     plot(Ankle.DorsalFlexMaxStancePerc(s),Ankle.DorsalFlexMaxStance(s),'*')
%     plot(Ankle.DorsalFlexMaxSwingPerc(s),Ankle.DorsalFlexMaxSwing(s),'o')
%     plot(Ankle.PlantarFlexMaxPerc(s),Ankle.PlantarFlexMax(s),'d')
%     
    
    %% imput platform forces
%     
%     %%cerco ciclo sulla pedana di forza
%     figure
%     plot(forces(:,:,end))
%     hold on
%     plot(forces(:,:,end-1))
    
    % Moments(VALUES,Plane(sagittal, frontal, rotation),SERIES(l-rpelvis, l-rhip, etc))
    
    if ( abs(sum(forces(analog_footstrike1(s)+1,:,end)))>(Bodymass*0.1) & abs(sum(forces(analog_footoff(s),:,end)))>(Bodymass*0.1) ) | ...
            ( abs(sum(forces(analog_footstrike1(s)+1,:,end-1)))>(Bodymass*0.1) & abs(sum(forces(analog_footoff(s),:,end-1)))>(Bodymass*0.1) )
        on_platform_footstrike1=footstrike1(s);
        on_platform_footstrike2=footstrike2(s);
        on_platform_footoff=footoff(s);
        %normalize at gait cycle %
        nc = length(on_platform_footstrike1:on_platform_footstrike2);
        t100 = linspace(1,nc,100);
        Moments_100x= [];
        Moments_100y= [];
        Moments_100z= [];
        
        Powers_100z= [];
        %     Angles_ul_100 4-D 1-D: percent gait, 2-D: (x,y,z), 3-D: joints, 4-D:trials
        for i = 1:size(Moments,3)
            Moments_100x= [Moments_100x interp1(1:nc,Moments(on_platform_footstrike1:on_platform_footstrike2,1,i),t100,'linear')'];
            Moments_100y=[Moments_100y interp1(1:nc,Moments(on_platform_footstrike1:on_platform_footstrike2,2,i),t100,'linear')'];
            Moments_100z=[Moments_100z interp1(1:nc,Moments(on_platform_footstrike1:on_platform_footstrike2,3,i),t100,'linear')'];
            
            Powers_100z= [Powers_100z interp1(1:nc,Powers(on_platform_footstrike1:on_platform_footstrike2,3,i),t100,'linear')'];
        end
        Moments_100(:,:,1)=Moments_100x;
        Moments_100(:,:,2)=Moments_100y;
        Moments_100(:,:,3)=Moments_100z;
        Powers_100(:,:,1)=Powers_100z;
        %% Hip moments
        lenStride = on_platform_footstrike2 - on_platform_footstrike1;
        six_percent = round(lenStride/100*6);
        
        
        [Hip.Extmoment, percind] = min((Moments(on_platform_footstrike1+six_percent:on_platform_footoff,1,1))); % +six_percent in order to avoid artifact from foot strike on platform
        Hip.ExtMomperc = (percind+six_percent)/lenStride*100;
        % (Max) Left hip extension moment (x)
        [Hip.flexmoment, percind] = max((Moments(on_platform_footstrike1+six_percent:on_platform_footoff,1,1)));
        Hip.flexMomperc = (percind+six_percent)/lenStride*100;
        % (Max) Left hip Abd/Add moment (y)
        [Hip.Addmoment, percind] = max((Moments(on_platform_footstrike1+six_percent:on_platform_footoff,2,1))); % +six_percent in order to avoid artifact from foot strike on platform
        Hip.AddMomperc= (percind+six_percent)/lenStride*100;
        
        
        % Powers extraction
        workAnkleP=0; workAnkleN=0;
        workHipP=0; workHipN=0;
        workKneeP=0; workKneeN=0;
        
        %      hip generation power stance
        [Hip.GenPowerStance,percind] = max((Powers(on_platform_footstrike1+six_percent:on_platform_footoff,3,1)));
        Hip.GenPowerStanceperc = percind/lenStride*100;
        %     hip absorption power stance
        [Hip.AbsPowerStance, percind]=min((Powers(on_platform_footstrike1+six_percent:on_platform_footoff,3,1)));
        Hip.AbsPowerStanceperc = percind/lenStride*100;
        %   hip generation power swing
        [Hip.GenPowerSwing,percind]=max((Powers(on_platform_footoff:on_platform_footstrike2,3,1)));
        Hip.GenPowerSwingperc = percind/lenStride*100;
        
        %% Knee moments and power
        [Knee.Extmoment, percind] = min((Moments(on_platform_footstrike1+six_percent:on_platform_footoff,1,2)));%Left knee extension moment
        Knee.ExtMomperc = (percind+six_percent)/lenStride*100;
        
        [Knee.Flexmoment, percind] = max((Moments(on_platform_footstrike1+six_percent:on_platform_footoff,1,2)));
        Knee.FlexMomperc = (percind+six_percent)/lenStride*100;
        
        
        %      Knee generation power stance
        [Knee.GenPowerStance,percind] = max((Powers(on_platform_footstrike1+six_percent:on_platform_footoff,3,2)));
        Knee.GenPowerStanceperc = percind/lenStride*100;
        %     Knee absorption power stance
        [Knee.AbsPowerStance,percind]=min((Powers(on_platform_footstrike1+six_percent:on_platform_footoff,3,2)));
        Knee.AbsPowerStanceperc = percind/lenStride*100;
        
        %   Knee generation power swing
        [Knee.GenPowerSwing,percind]=max((Powers(on_platform_footoff:on_platform_footstrike2,3,2)));
        Knee.GenPowerSwingperc = percind/lenStride*100;
        
        %% ankle moments and power
        L10_percent = round(lenStride/100*10);
        L30_percent = round(lenStride/100*30);
        [Ankle.Plantarmoment, percind] = min((Moments(on_platform_footstrike1:on_platform_footoff-L30_percent,1,3)));%     Left ankle plantar moment
        Ankle.PlantarMomperc = percind/lenStride*100;
        
        [Ankle.dorsalmoment, percind] = max((Moments(on_platform_footstrike1:on_platform_footoff,1,3)));%    Left ankle dorsal moment
        Ankle.dorsalMomperc = percind/lenStride*100;
        
        %    ankle generation power stance
        [Ankle.GenPower, percind] =max((Powers(on_platform_footstrike1+six_percent:on_platform_footoff,3,3)));
        Ankle.GenPowerperc = percind/lenStride*100;
        %     ankle absorption power stance
        [Ankle.AbsPower, percind] =min((Powers(on_platform_footstrike1+six_percent:on_platform_footoff,3,3)));
        Ankle.AbsPowerperc = percind/lenStride*100;
        
        TotPowerl=Powers(on_platform_footstrike1:on_platform_footstrike2,3,3)+Powers(on_platform_footstrike1:on_platform_footstrike2,3,2)+Powers(on_platform_footstrike1:on_platform_footstrike2,3,1);
        
        nc = length(on_platform_footstrike1:on_platform_footstrike2);TotPowers_100(:,1)= interp1(1:nc,TotPowerl',t100,'linear');
        
        for i=on_platform_footstrike1+six_percent:on_platform_footoff
            if Powers(i,3,3)>0
                workAnkleP=workAnkleP+(Powers(i,3,3)*1/Frame_rate);
            else
                workAnkleN=workAnkleN+(abs(Powers(i,3,3))*1/Frame_rate);
            end
            
            if Powers(i,3,3)>0
                workKneeP=workKneeP+(Powers(i,3,2)*1/Frame_rate);
            else
                workKneeN=workKneeN+(abs(Powers(i,3,2))*1/Frame_rate);
            end
            
            if Powers(i,3,1)>0
                workHipP=workHipP+(Powers(i,3,1)*1/Frame_rate);
            else
                workHipN=workHipN+(abs(Powers(i,3,1))*1/Frame_rate);
            end
        end
        Ankle.workP=workAnkleP; Ankle.workN=workAnkleN; Knee.workP=workKneeP;
        Knee.workN=workKneeN; Hip.workP=workHipP; Hip.workN=workHipN;
        
    end
    
    %% CoM
    %% CoM
    CoM_100x= [];
    CoM_100y= [];
    CoM_100z= [];
    
    vel_CoM_100x= [];
    vel_CoM_100y= [];
    vel_CoM_100z= [];
    
    %         figure;plot3(CoM(:,1),CoM(:,2),CoM(:,3))
    % filter params plot(CoM(:,2),CoM(:,3))%
    polord=4;
    frame=19;
    der_ord = 1;
%     cutoffv=test_sav_golay(frame,polord,der_ord,Frame_rate);
    vel_CoM = sav_golay(CoM,frame,polord,der_ord,Frame_rate);
    
    
    CoM_100x= [CoM_100x interp1(1:nc,CoM(footstrike1(s):footstrike2(s),1),t100,'linear')'];
    CoM_100y= [CoM_100y interp1(1:nc,CoM(footstrike1(s):footstrike2(s),2),t100,'linear')'];
    CoM_100z= [CoM_100z interp1(1:nc,CoM(footstrike1(s):footstrike2(s),3),t100,'linear')'];
    
    vel_CoM_100x= [vel_CoM_100x interp1(1:nc,vel_CoM(footstrike1(s):footstrike2(s),1),t100,'linear')'];
    vel_CoM_100y= [vel_CoM_100y interp1(1:nc,vel_CoM(footstrike1(s):footstrike2(s),2),t100,'linear')'];
    vel_CoM_100z= [vel_CoM_100z interp1(1:nc,vel_CoM(footstrike1(s):footstrike2(s),3),t100,'linear')'];
    
    CoM_100(:,1,s)=CoM_100x;
    CoM_100(:,2,s)=CoM_100y;
    CoM_100(:,3,s)=CoM_100z;
    vel_CoM_100(:,1,s)=vel_CoM_100x;
    vel_CoM_100(:,2,s)=vel_CoM_100y;
    vel_CoM_100(:,3,s)=vel_CoM_100z;
    
  
    nmuscles = size(env,2);
    nc = length(analog_footstrike1(s):analog_footstrike2(s));
    t100 = linspace(1,nc,100);
    
    for m = 1:nmuscles
        EMG_filt_100(:,m,s)= interp1(1:nc,emgBP(analog_footstrike1(s):analog_footstrike2(s),m),t100,'linear');
        EMG_env_100(:,m,s)= interp1(1:nc,env(analog_footstrike1(s):analog_footstrike2(s),m),t100,'linear');
        
    end
    avgenv = nanmean(EMG_env_100(:,:,s),1);
    EMG_norm_env_100(:,:,s) = EMG_env_100(:,:,s)./avgenv;
    
    
end

%%output

if ~isempty(AnglesUL)
    Data.Head = Head; Data.Neck = Neck; Data.Shoulder = Shoulder; Data.Elbow = Elbow; Data.Wrist = Wrist;
    Data.Thorax = Thorax;
    Data100.Angles_ul_100 = Angles_ul_100;
end
Data.Pelvis = Pelvis; Data.Hip = Hip; Data.Knee = Knee; Data.Ankle = Ankle;
Data.footprogress = footprogress;

Data100.Angles_ll_100 = Angles_ll_100;
Data100.CoM_100 = CoM_100;
Data100.vel_CoM_100 = vel_CoM_100;
Data100.Powers_100 = Powers_100;
Data100.Moments_100 = Moments_100;
Data100.EMG_filt_100 = EMG_filt_100;
Data100.EMG_env_100 = EMG_env_100;
Data100.EMG_norm_env_100 = EMG_norm_env_100;
end


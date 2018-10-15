%Questo script calcola la curva media e tutti i parametri cinematici medi tra trial
%diversi per un subj potendo o no distinguere tra destra e sinistra e ti
%predispone le matrici per il plot degli andamenti cinematici e cinetici della curva media
% import patient

clear all
global Angles Kinetic AvgData
Oldpath = pwd;
addpath(Oldpath) %Susanna

Moment_100 = ones(100,3,6).*nan;
Power_100 = ones(100,3,6).*nan;
TotPower_100 = ones(100,3,1).*nan;

nside = str2num(input('1 line or 2 lines? [1/2] ','s'));

if nside == 1
    answer = input('do you want one side [1] or averaged sides [2]? [default: 2]','s');
    if strcmp(answer,'1')
        side = input('Which side do you want, left[1] or right[2]? [default: 1]','s');
    else
        side = [];
    end
else
    answer = [];
    side = [];
end

prompt = 'number of subjs: ';
nsubj = input(prompt,'s');
nsubj=str2num(nsubj);
TRJ_label={'lank', 'rank'};
AnglesUL_label={'lneckangles','rneckangles','lshoulderangles','rshoulderangles','lelbowangles','relbowangles','lwristangles','rwristangles','lheadangles','rheadangles'};
AnglesLL_label={'lpelvisangles', 'rpelvisangles', 'lhipangles', 'rhipangles','lkneeangles', 'rkneeangles', 'lankleangles', 'rankleangles', 'lthoraxangles', 'rthoraxangles','lfootprogressangles','rfootprogressangles'};

for subj = 1:nsubj
    subj
    Datapath = uigetdir;
    cd(Datapath)
    ntrial = str2num(input('number of trials: ','s'));
    Angles_ul_100 = []; Angles_ll_100 = []; Moments_100 = []; Powers_100 = [];
    if isempty(ntrial)
        keyboard
    end
    for j=1:ntrial
        if ispc
        [Name,PathName,tmp] = uigetfile('*c3d','Please select c3d file'); % Silvia ho aggiunto il . così mi visualizza .c3d
        else
        [Name,PathName,tmp] = uigetfile('.*c3d','Please select c3d file'); % Silvia ho aggiunto il . così mi visualizza .c3d            
        end
        FileName = [PathName,Name];
        if isempty(FileName)
            prompt = 'Invalid file name';
        end
        
        
        c3d=c3d2c3d(FileName);
        events=c3devents(c3d,'abs'); %events are expressed in absolute frame and time
        Frame_rate=c3d.c3dpar.point.rate;
        
%         matrici con eventi. sulle righe i trial sulle colonne left=1 right=2
        [ footoff(j,:), footstrike1(j,:), footstrike2(j,:) ] = get_gaitevents( events );
        
        % Import subjectname and measurements
        Subject_Name=char(c3d.c3dpar.subjects.names);
        
        %     Height=c3d.c3dpar.processing.height;
        %     Lleglenght=c3d.c3dpar.processing.lleglength;
        %     Rleglenght=c3d.c3dpar.processing.rleglength;
        
        % import spatial and temporal parameters
        TRJ=c3dget(c3d,Subject_Name,TRJ_label);%trajectory
        [ spatial_param ] = get_spatialparam( TRJ, Frame_rate, footoff(j,:), footstrike1(j,:), footstrike2(j,:) );
        SpatialData.FootOff_perc(j,:) = spatial_param(1,:); %[Percleft_footoff Percright_footoff];
        SpatialData.StrideVelocity(j,:) = spatial_param(2,:); % [Lstridelenght./1000./left_time Rstridelenght./1000./right_time]; %[m/s]
        SpatialData.StrideLength(j,:) = spatial_param(3,:); %[Lstridelenght./1000 Rstridelenght./1000]; %[m]
        SpatialData.StrideTime(j,:) = spatial_param(4,:); %[left_time right_time]; %[s]
        SpatialData.StrideWidth(j,:) = spatial_param(5,:); %[Lstridewidth/1000 Rstridewidth/1000]; %[m]
        SpatialData.StepLength(j,:) = spatial_param(6,:); %[Lsteplenght/1000 Rsteplenght/1000]; %[m]
        SpatialData.StanceTime(j,:) = spatial_param(7,:); %[LStance_time RStance_time]; %[s]
        SpatialData.SwingTime(j,:) = spatial_param(8,:); %[LSwing_time RSwing_time]; %[s]
        SpatialData.Double_support(j,:) = spatial_param(9,:); %[Ini_Double_support Fin_Double_support]; %[s]
        
                
        % Import Angles head and upper limb
        % Angles(VALUES,Plane(sagittal, frontal, rotation),SERIES(l-rpelvis, l-rhip, etc))
        AnglesUL=c3dget(c3d,Subject_Name,AnglesUL_label);
        %normalize at gait cycle %
        nc = length(footstrike1(j,1):footstrike2(j,1));
        t100 = linspace(1,nc,100);
        %     Angles_ul_100 4-D 1-D: percent gait, 2-D: (x,y,z), 3-D: joints, 4-D:trials
        if ~isempty(AnglesUL)
        for i = 1:2:length(AnglesUL_label) %left
            Angles_ul_100(:,1,i,j)= interp1(1:nc,AnglesUL(footstrike1(j,1):footstrike2(j,1),1,i),t100,'linear');
            Angles_ul_100(:,2,i,j)= interp1(1:nc,AnglesUL(footstrike1(j,1):footstrike2(j,1),2,i),t100,'linear');
            Angles_ul_100(:,3,i,j)= interp1(1:nc,AnglesUL(footstrike1(j,1):footstrike2(j,1),3,i),t100,'linear');
        end
        nc = length(footstrike1(j,2):footstrike2(j,2));
        t100 = linspace(1,nc,100);
        for i = 2:2:length(AnglesUL_label) %right
            Angles_ul_100(:,1,i,j)= interp1(1:nc,AnglesUL(footstrike1(j,2):footstrike2(j,2),1,i),t100,'linear');
            Angles_ul_100(:,2,i,j)= interp1(1:nc,AnglesUL(footstrike1(j,2):footstrike2(j,2),2,i),t100,'linear');
            Angles_ul_100(:,3,i,j)= interp1(1:nc,AnglesUL(footstrike1(j,2):footstrike2(j,2),3,i),t100,'linear');
        end
        
        %% Head parameters (first column = left, second column  = right; rows = trials)
        % Tilt (x)
        [Head.Tilt.Mean(j,1),Head.Tilt.Range(j,1), Head.Tilt.IC(j,1)] = get_parval(AnglesUL(footstrike1(j,1):footstrike2(j,1),1,9));
        [Head.Tilt.Mean(j,2),Head.Tilt.Range(j,2), Head.Tilt.IC(j,2)] = get_parval(AnglesUL(footstrike1(j,2):footstrike2(j,2),1,10));
        % Obliquity (y)
        [Head.Obl.Mean(j,1),Head.Obl.Range(j,1), Head.Obl.IC(j,1)] = get_parval(AnglesUL(footstrike1(j,1):footstrike2(j,1),2,9));
        [Head.Obl.Mean(j,2),Head.Obl.Range(j,2), Head.Obl.IC(j,2)] = get_parval(AnglesUL(footstrike1(j,2):footstrike2(j,2),2,10));
        % Rotation (z)
        [Head.Rot.Mean(j,1),Head.Rot.Range(j,1), Head.Rot.IC(j,1)] = get_parval(AnglesUL(footstrike1(j,1):footstrike2(j,1),3,9));
        [Head.Rot.Mean(j,2),Head.Rot.Range(j,2), Head.Rot.IC(j,2)] = get_parval(AnglesUL(footstrike1(j,2):footstrike2(j,2),3,10));
        
        
        %% Neck parameters (first column = left, second column  = right; rows = trials)
        % Tilt (x)
        [Neck.Tilt.Mean(j,1),Neck.Tilt.Range(j,1), Neck.Tilt.IC(j,1)] = get_parval(AnglesUL(footstrike1(j,1):footstrike2(j,1),1,1));
        [Neck.Tilt.Mean(j,2),Neck.Tilt.Range(j,2), Neck.Tilt.IC(j,2)] = get_parval(AnglesUL(footstrike1(j,2):footstrike2(j,2),1,2));
        % Obliquity (y)
        [Neck.Obl.Mean(j,1),Neck.Obl.Range(j,1), Neck.Obl.IC(j,1)] = get_parval(AnglesUL(footstrike1(j,1):footstrike2(j,1),2,1));
        [Neck.Obl.Mean(j,2),Neck.Obl.Range(j,2), Neck.Obl.IC(j,2)] = get_parval(AnglesUL(footstrike1(j,2):footstrike2(j,2),2,2));
        % Rotation (z)
        [Neck.Rot.Mean(j,1),Neck.Rot.Range(j,1), Neck.Rot.IC(j,1)] = get_parval(AnglesUL(footstrike1(j,1):footstrike2(j,1),3,1));
        [Neck.Rot.Mean(j,2),Neck.Rot.Range(j,2), Neck.Rot.IC(j,2)] = get_parval(AnglesUL(footstrike1(j,2):footstrike2(j,2),3,2));
        
        %% Shoulder parameters (first column = left, second column  = right; rows = trials)
        % Tilt (x)
        [Shoulder.FlexExt.Mean(j,1),Shoulder.FlexExt.Range(j,1), Shoulder.FlexExt.IC(j,1)] = get_parval(AnglesUL(footstrike1(j,1):footstrike2(j,1),1,3));
        [Shoulder.FlexExt.Mean(j,2),Shoulder.FlexExt.Range(j,2), Shoulder.FlexExt.IC(j,2)] = get_parval(AnglesUL(footstrike1(j,2):footstrike2(j,2),1,4));
        % Obliquity (y)
        [Shoulder.AbdAdd.Mean(j,1),Shoulder.AbdAdd.Range(j,1), Shoulder.AbdAdd.IC(j,1)] = get_parval(AnglesUL(footstrike1(j,1):footstrike2(j,1),2,3));
        [Shoulder.AbdAdd.Mean(j,2),Shoulder.AbdAdd.Range(j,2), Shoulder.AbdAdd.IC(j,2)] = get_parval(AnglesUL(footstrike1(j,2):footstrike2(j,2),2,4));
        % Rotation (z)
        [Shoulder.Rot.Mean(j,1),Shoulder.Rot.Range(j,1), Shoulder.Rot.IC(j,1)] = get_parval(AnglesUL(footstrike1(j,1):footstrike2(j,1),3,3));
        [Shoulder.Rot.Mean(j,2),Shoulder.Rot.Range(j,2), Shoulder.Rot.IC(j,2)] = get_parval(AnglesUL(footstrike1(j,2):footstrike2(j,2),3,4));
        % Max Flex, %
        [Shoulder.FlexMax(j,1), percind] = max((AnglesUL(footstrike1(j,1):footstrike2(j,1),1,3)));
        Shoulder.FlexMaxPerc(j,1) = percind/(footstrike2(j,1)-footstrike1(j,1))*100;
        [Shoulder.FlexMax(j,2), percind] = max((AnglesUL(footstrike1(j,2):footstrike2(j,2),1,4)));
        Shoulder.FlexMaxPerc(j,2) = percind/(footstrike2(j,2)-footstrike1(j,2))*100;
        % Max Ext, %
        [Shoulder.ExtMax(j,1), percind] = min((AnglesUL(footstrike1(j,1):footstrike2(j,1),1,3)));
        Shoulder.ExtMaxPerc(j,1) = percind/(footstrike2(j,1)-footstrike1(j,1))*100;
        [Shoulder.ExtMax(j,2), percind] = min((AnglesUL(footstrike1(j,2):footstrike2(j,2),1,4)));
        Shoulder.ExtMaxPerc(j,2) = percind/(footstrike2(j,2)-footstrike1(j,2))*100;

        %% Elbow parameters (first column = left, second column  = right;
        % rows = trials)
        % Tilt (x)
        [Elbow.FlexExt.Mean(j,1),Elbow.FlexExt.Range(j,1), Elbow.FlexExt.IC(j,1)] = get_parval(AnglesUL(footstrike1(j,1):footstrike2(j,1),1,5));
        [Elbow.FlexExt.Mean(j,2),Elbow.FlexExt.Range(j,2), Elbow.FlexExt.IC(j,2)] = get_parval(AnglesUL(footstrike1(j,2):footstrike2(j,2),1,6));
        % Max Flex, %
        [Elbow.FlexMax(j,1), percind] = max((AnglesUL(footstrike1(j,1):footstrike2(j,1),1,5)));
        Elbow.FlexMaxPerc(j,1) = percind/(footstrike2(1)-footstrike1(j,1))*100;
        [Elbow.FlexMax(j,2), percind] = max((AnglesUL(footstrike1(j,2):footstrike2(j,2),1,6)));
        Elbow.FlexMaxPerc(j,2) = percind/(footstrike2(j,2)-footstrike1(j,2))*100;
        % Max Ext, %
        [Elbow.ExtMax(j,1), percind] = min((AnglesUL(footstrike1(j,1):footstrike2(j,1),1,5)));
        Elbow.ExtMaxPerc(j,1) = percind/(footstrike2(j,1)-footstrike1(j,1))*100;
        [Elbow.ExtMax(j,2), percind] = min((AnglesUL(footstrike1(j,2):footstrike2(j,2),1,6)));
        Elbow.ExtMaxPerc(j,2) = percind/(footstrike2(j,2)-footstrike1(j,2))*100;
        
        %% Wrist parameters (first column = left, second column  = right; rows = trials)
        % Tilt (x)
        [Wrist.FlexExt.Mean(j,1),Wrist.FlexExt.Range(j,1), Wrist.FlexExt.IC(j,1)] = get_parval(AnglesUL(footstrike1(j,1):footstrike2(j,1),1,7));
        [Wrist.FlexExt.Mean(j,2),Wrist.FlexExt.Range(j,2), Wrist.FlexExt.IC(j,2)] = get_parval(AnglesUL(footstrike1(j,2):footstrike2(j,2),1,8));
        % Obliquity (y)
        [Wrist.AbdAdd.Mean(j,1),Wrist.AbdAdd.Range(j,1), Wrist.AbdAdd.IC(j,1)] = get_parval(AnglesUL(footstrike1(j,1):footstrike2(j,1),2,7));
        [Wrist.AbdAdd.Mean(j,2),Wrist.AbdAdd.Range(j,2), Wrist.AbdAdd.IC(j,2)] = get_parval(AnglesUL(footstrike1(j,2):footstrike2(j,2),2,8));
        % Rotation (z)
        [Wrist.Rot.Mean(j,1),Wrist.Rot.Range(j,1), Wrist.Rot.IC(j,1)] = get_parval(AnglesUL(footstrike1(j,1):footstrike2(j,1),3,7));
        [Wrist.Rot.Mean(j,2),Wrist.Rot.Range(j,2), Wrist.Rot.IC(j,2)] = get_parval(AnglesUL(footstrike1(j,2):footstrike2(j,2),3,8));
        end
        %% Import Angles lower limb and Thorax
        % Angles(VALUES,Plane(sagittal, frontal, rotation),SERIES(l-rpelvis, l-rhip, etc))%
        AnglesLL=c3dget(c3d,Subject_Name,AnglesLL_label);
        nc = length(footstrike1(j,1):footstrike2(j,1));
        oldtime =linspace(0,1/nc,nc);
        newtime = linspace(0,1/nc,100);
        Lanklemin(j)=min(AnglesLL(footstrike1(j,1):footstrike2(j,1),1,7));
        Lanklemean(j)=mean(AnglesLL(footstrike1(j,1):footstrike2(j,1),1,7));
        for i = 1:2:length(AnglesLL_label) %left - Angles_ll_100 (campioni,assi,giunto,trial)
            Angles_ll_100(:,1,i,j)= interp1(oldtime,AnglesLL(footstrike1(j,1):footstrike2(j,1),1,i)',newtime,'linear');
            Angles_ll_100(:,2,i,j)= interp1(oldtime,AnglesLL(footstrike1(j,1):footstrike2(j,1),2,i)',newtime,'linear');
            Angles_ll_100(:,3,i,j)= interp1(oldtime,AnglesLL(footstrike1(j,1):footstrike2(j,1),3,i)',newtime,'linear');
        end
        nc = length(footstrike1(j,2):footstrike2(j,2));
        oldtime =linspace(0,1/nc,nc);
        newtime = linspace(0,1/nc,100);
        for i = 2:2:length(AnglesLL_label) %right
            Angles_ll_100(:,1,i,j)= interp1(oldtime,AnglesLL(footstrike1(j,2):footstrike2(j,2),1,i)',newtime,'linear');
            Angles_ll_100(:,2,i,j)= interp1(oldtime,AnglesLL(footstrike1(j,2):footstrike2(j,2),2,i)',newtime,'linear');
            Angles_ll_100(:,3,i,j)= interp1(oldtime,AnglesLL(footstrike1(j,2):footstrike2(j,2),3,i)',newtime,'linear');
        end
        
        %% Foot Progression angle footprogress (first column = left, second column  = right; rows = trials)
        % Rot(z) Per definizione
        [footprogress.Rot.Mean(j,1),footprogress.Rot.Range(j,1), footprogress.Rot.IC(j,1)] = get_parval(AnglesLL(footstrike1(j,1):footstrike2(j,1),3,11));
        [footprogress.Rot.Mean(j,2),footprogress.Rot.Range(j,2), footprogress.Rot.IC(j,2)] = get_parval(AnglesLL(footstrike1(j,2):footstrike2(j,2),3,12));
        % Max Rot, %
        [footprogress.RotMax(j,1), percind] = max((AnglesLL(footstrike1(j,1):footstrike2(j,1),3,11)));
        footprogress.RotMaxPerc(j,1) = percind/(footstrike2(j,1)-footstrike1(j,1))*100;
        [footprogress.RotMax(j,2), percind] = max((AnglesLL(footstrike1(j,2):footstrike2(j,2),3,12)));
        footprogress.RotMaxPerc(j,2) = percind/(footstrike2(j,2)-footstrike1(j,2))*100;
        % Min Rot, %
        [footprogress.RotMin(j,1), percind] = min((AnglesLL(footstrike1(j,1):footstrike2(j,1),3,11)));
        footprogress.RotMinPerc(j,1) = percind/(footstrike2(j,1)-footstrike1(j,1))*100;
        [footprogress.RotMin(j,2), percind] = min((AnglesLL(footstrike1(j,2):footstrike2(j,2),3,12)));
        footprogress.RotMinPerc(j,2) = percind/(footstrike2(j,2)-footstrike1(j,2))*100;
        %% Thorax parameters (first column = left, second column  = right;
        % rows = trials)
        % Tilt (x)
        [Thorax.Tilt.Mean(j,1),Thorax.Tilt.Range(j,1), Thorax.Tilt.IC(j,1)] = get_parval(AnglesLL(footstrike1(j,1):footstrike2(j,1),1,9));
        [Thorax.Tilt.Mean(j,2),Thorax.Tilt.Range(j,2), Thorax.Tilt.IC(j,2)] = get_parval(AnglesLL(footstrike1(j,2):footstrike2(j,2),1,10));
        % Obliquity (y)
        [Thorax.Obl.Mean(j,1),Thorax.Obl.Range(j,1), Thorax.Obl.IC(j,1)] = get_parval(AnglesLL(footstrike1(j,1):footstrike2(j,1),2,9));
        [Thorax.Obl.Mean(j,2),Thorax.Obl.Range(j,2), Thorax.Obl.IC(j,2)] = get_parval(AnglesLL(footstrike1(j,2):footstrike2(j,2),2,10));
        % Rotation (z)
        [Thorax.Rot.Mean(j,1),Thorax.Rot.Range(j,1), Thorax.Rot.IC(j,1)] = get_parval(AnglesLL(footstrike1(j,1):footstrike2(j,1),3,9));
        [Thorax.Rot.Mean(j,2),Thorax.Rot.Range(j,2), Thorax.Rot.IC(j,2)] = get_parval(AnglesLL(footstrike1(j,2):footstrike2(j,2),3,10));
        
        %% Pelvis parameters (first column = left, second column  = right;
        % rows = trials)
        % Tilt (x)
        [Pelvis.Tilt.Mean(j,1),Pelvis.Tilt.Range(j,1), Pelvis.Tilt.IC(j,1)] = get_parval(AnglesLL(footstrike1(j,1):footstrike2(j,1),1,1));
        [Pelvis.Tilt.Mean(j,2),Pelvis.Tilt.Range(j,2), Pelvis.Tilt.IC(j,2)] = get_parval(AnglesLL(footstrike1(j,2):footstrike2(j,2),1,2));
        % Obliquity (y)
        [Pelvis.Obl.Mean(j,1),Pelvis.Obl.Range(j,1), Pelvis.Obl.IC(j,1)] = get_parval(AnglesLL(footstrike1(j,1):footstrike2(j,1),2,1));
        [Pelvis.Obl.Mean(j,2),Pelvis.Obl.Range(j,2), Pelvis.Obl.IC(j,2)] = get_parval(AnglesLL(footstrike1(j,2):footstrike2(j,2),2,2));
        % Rotation (z)
        [Pelvis.Rot.Mean(j,1),Pelvis.Rot.Range(j,1), Pelvis.Rot.IC(j,1)] = get_parval(AnglesLL(footstrike1(j,1):footstrike2(j,1),3,1));
        [Pelvis.Rot.Mean(j,2),Pelvis.Rot.Range(j,2), Pelvis.Rot.IC(j,2)] = get_parval(AnglesLL(footstrike1(j,2):footstrike2(j,2),3,2));
        
        
        %% Hip parameters (first column = left, second column  = right;
        % rows = trials)
        % Tilt (x)
        [Hip.FlexExt.Mean(j,1),Hip.FlexExt.Range(j,1), Hip.FlexExt.IC(j,1)] = get_parval(AnglesLL(footstrike1(j,1):footstrike2(j,1),1,3));
        [Hip.FlexExt.Mean(j,2),Hip.FlexExt.Range(j,2), Hip.FlexExt.IC(j,2)] = get_parval(AnglesLL(footstrike1(j,2):footstrike2(j,2),1,4));
        % Obliquity (y)
        [Hip.Obl.Mean(j,1),Hip.Obl.Range(j,1), Hip.Obl.IC(j,1)] = get_parval(AnglesLL(footstrike1(j,1):footstrike2(j,1),2,3));
        [Hip.Obl.Mean(j,2),Hip.Obl.Range(j,2), Hip.Obl.IC(j,2)] = get_parval(AnglesLL(footstrike1(j,2):footstrike2(j,2),2,4));

        % Max Flex, %
        [Hip.FlexMax(j,1), percind] = max((AnglesLL(footstrike1(j,1):footstrike2(j,1),1,3)));
        Hip.FlexMaxPerc(j,1) = percind/(footstrike2(j,1)-footstrike1(j,1))*100;
        [Hip.FlexMax(j,2), percind] = max((AnglesLL(footstrike1(j,2):footstrike2(j,2),1,4)));
        Hip.FlexMaxPerc(j,2) = percind/(footstrike2(j,2)-footstrike1(j,2))*100;
        % Max Ext, %
        [Hip.ExtMax(j,1), percind] = min((AnglesLL(footstrike1(j,1):footstrike2(j,1),1,3)));
        Hip.ExtMaxPerc(j,1) = percind/(footstrike2(j,1)-footstrike1(j,1))*100;
        [Hip.ExtMax(j,2), percind] = min((AnglesLL(footstrike1(j,2):footstrike2(j,2),1,4)));
        Hip.ExtMaxPerc(j,2) = percind/(footstrike2(j,2)-footstrike1(j,2))*100;
        % Max Abd, %
        [Hip.AddMax(j,1), percind] = max((AnglesLL(footstrike1(j,1):footstrike2(j,1),2,3)));
        Hip.AddMaxPerc(j,1) = percind/(footstrike2(j,1)-footstrike1(j,1))*100;
        [Hip.AddMax(j,2), percind] = max((AnglesLL(footstrike1(j,2):footstrike2(j,2),2,4)));
        Hip.AddMaxPerc(j,2) = percind/(footstrike2(j,2)-footstrike1(j,2))*100;
        % Min Abd, %
        [Hip.AbdMax(j,1), percind] = min((AnglesLL(footstrike1(j,1):footstrike2(j,1),2,3)));
        Hip.AbdMaxPerc(j,1) = percind/(footstrike2(j,1)-footstrike1(j,1))*100;
        [Hip.AbdMax(j,2), percind] = min((AnglesLL(footstrike1(j,2):footstrike2(j,2),2,4)));
        Hip.AbdMaxPerc(j,2) = percind/(footstrike2(j,2)-footstrike1(j,2))*100;
        
        %% Knee parameters (first column = left, second column  = right; rows = trials)
        % FlexExt (x)
        [Knee.FlexExt.Mean(j,1),Knee.FlexExt.Range(j,1), Knee.FlexExt.IC(j,1)] = get_parval(AnglesLL(footstrike1(j,1):footstrike2(j,1),1,5));
        [Knee.FlexExt.Mean(j,2),Knee.FlexExt.Range(j,2), Knee.FlexExt.IC(j,2)] = get_parval(AnglesLL(footstrike1(j,2):footstrike2(j,2),1,6));
        % Max Flex stance, %
        if footstrike1(j,1)<footstrike1(j,2)
            right_strike(j,1)=footstrike1(j,2);
        else
            right_strike(j,1)=footstrike2(j,2);
        end
        if footstrike1(j,2)<footstrike1(j,1)
            left_strike(j,1)=footstrike1(j,1);
        else
            left_strike(j,1)=footstrike2(j,1);
        end
        %left and right strike instead of footoff in order to avoid FP
        [Knee.FlexMaxStance(j,1), percind] = max((AnglesLL(footstrike1(j,1):right_strike(j,1),1,5)));
        Knee.FlexMaxStancePerc(j,1) = percind/(footstrike2(j,1)-footstrike1(j,1))*100;
        [Knee.FlexMaxStance(j,2), percind] = max((AnglesLL(footstrike1(j,2):left_strike(j,1),1,6)));
        Knee.FlexMaxStancePerc(j,2) = percind/(footstrike2(j,2)-footstrike1(j,2))*100;
        
        % Max Flex swing, %
        [Knee.FlexMaxSwing(j,1), percind] = max((AnglesLL(footoff(j,1):footstrike2(j,1),1,5)));
        Knee.FlexMaxSwingPerc(j,1) = (percind+footoff(j,1)-footstrike1(j,1))/(footstrike2(j,1)-footstrike1(j,1))*100; % modifica 
		%Knee.FlexMaxSwingPerc(j,1) = (percind+footoff(j,1))/(footstrike2(j,1)-footstrike1(j,1))*100;
        [Knee.FlexMaxSwing(j,2), percind] = max((AnglesLL(footoff(j,2):footstrike2(j,2),1,6)));
		Knee.FlexMaxSwingPerc(j,2) = (percind+footoff(j,2)-footstrike1(j,2))/(footstrike2(j,2)-footstrike1(j,2))*100; % modifica
        %Knee.FlexMaxSwingPerc(j,2) = (percind+footoff(j,2))/(footstrike2(j,2)-footstrike1(j,2))*100;
        
        % Max Ext Stance, %
        [Knee.ExtMaxStance(j,1), percind] = min((AnglesLL(footstrike1(j,1):footoff(j,1),1,5)));
        Knee.ExtMaxStancePerc(j,1) = percind/(footstrike2(j,1)-footstrike1(j,1))*100;
        [Knee.ExtMaxStance(j,2), percind] = min((AnglesLL(footstrike1(j,2):footoff(j,2),1,6)));
        Knee.ExtMaxStancePerc(j,2) = percind/(footstrike2(j,2)-footstrike1(j,2))*100;
        
        %% Ankle parameters (first column = left, second column  = right;
        % rows = trials)
        % Flex-Extension (x)
        [Ankle.FlexExt.Mean(j,1),Ankle.FlexExt.Range(j,1), Ankle.FlexExt.IC(j,1)] = get_parval(AnglesLL(footstrike1(j,1):footstrike2(j,1),1,7));
        [Ankle.FlexExt.Mean(j,2),Ankle.FlexExt.Range(j,2), Ankle.FlexExt.IC(j,2)] = get_parval(AnglesLL(footstrike1(j,2):footstrike2(j,2),1,8));
        
        % Max DorsalFlex Stance, %
        [Ankle.DorsalFlexMaxStance(j,1), percind] = max((AnglesLL(footstrike1(j,1):footoff(j,1),1,7)));
        Ankle.DorsalFlexMaxStancePerc(j,1) = percind/(footstrike2(j,1)-footstrike1(j,1))*100;
        [Ankle.DorsalFlexMaxStance(j,2), percind] = max((AnglesLL(footstrike1(j,2):footoff(j,2),1,8)));
        Ankle.DorsalFlexMaxStancePerc(j,2) = percind/(footstrike2(j,2)-footstrike1(j,2))*100;
        
        % Max DorsalFlex swing, %
        [Ankle.DorsalFlexMaxSwing(j,1), percind] = max((AnglesLL(footoff(j,1):footstrike2(j,1),1,7)));
		Ankle.DorsalFlexMaxSwingPerc(j,1) = (percind+footoff(j,1)-footstrike1(j,1))/(footstrike2(j,1)-footstrike1(j,1))*100; %modifica
        %Ankle.DorsalFlexMaxSwingPerc(j,1) = (percind+footoff(j,1))/(footstrike2(j,1)-footstrike1(j,1))*100;
        [Ankle.DorsalFlexMaxSwing(j,2), percind] = max((AnglesLL(footoff(j,2):footstrike2(j,2),1,8)));
		Ankle.DorsalFlexMaxSwingPerc(j,2) = (percind+footoff(j,2)-footstrike1(j,2))/(footstrike2(j,2)-footstrike1(j,2))*100;  %modifica
        %Ankle.DorsalFlexMaxSwingPerc(j,2) = (percind+footoff(j,2))/(footstrike2(j,2)-footstrike1(j,2))*100;
        
        % Max PlantarFlex, %
        [Ankle.PlantarFlexMax(j,1), percind] = min((AnglesLL(footstrike1(j,1):footstrike2(j,1),1,7)));
        Ankle.PlantarFlexMaxPerc(j,1) = percind/(footstrike2(j,1)-footstrike1(j,1))*100;
        [Ankle.PlantarFlexMax(j,2), percind] = min((AnglesLL(footstrike1(j,2):footstrike2(j,2),1,8)));
        Ankle.PlantarFlexMaxPerc(j,2) = percind/(footstrike2(j,2)-footstrike1(j,2))*100;
        
        
        kin = input('Kinetic: yes [1] No [2]? [default: 1]','s');
        if isempty(kin);kin='1';end
        if strcmp(kin,'1')
            [  Moment_100,Power_100,TotPower_100, output_kinetic ] = kinetic( c3d);
 Moments_100(:,:,:,j)=Moment_100.*1e-3;Powers_100(:,:,:,j)=Power_100;TotPowers_100(:,:,j)=TotPower_100; % Moment metri = mm/1000 % Silvia            TotPower_100 =[];
            for fn = fieldnames(output_kinetic)'
                for fnn = fieldnames(output_kinetic.(fn{1}))'
                    eval([(fn{1}) '.' (fnn{1}) '(' num2str(j) ',:)= output_kinetic.' (fn{1}) '.' (fnn{1}) ';']);
                    [r,c]=find(eval([(fn{1}) '.' (fnn{1})])==0);
                    for i =1:length(r)
                    eval([(fn{1}) '.' (fnn{1}) '(' num2str(r(i)) ',' num2str(c(i)) ')=nan;'])
                    end
                    
                end
            end
        else
            Moments_100(:,:,:,j)=Moment_100.*nan;Powers_100(:,:,:,j)=Power_100.*nan;TotPowers_100(:,:,j)=TotPower_100.*nan;
        end
            
    end
    if ~isempty(AnglesUL)
    Data.Head = Head; Data.Neck = Neck; Data.Shoulder = Shoulder; Data.Elbow = Elbow; Data.Wrist = Wrist;
    Data.Thorax = Thorax;
    end
    Data.Pelvis = Pelvis; Data.Hip = Hip; Data.Knee = Knee; Data.Ankle = Ankle;
    Data.footprogress = footprogress; 
    if exist('FZ')==1;Data.FZ =FZ; Data.FX = FX; Data.FY = FY;end
    
    [ AvgData,] = Get_Data_for_table( Data, SpatialData, AnglesUL_label, AnglesLL_label, Angles_ul_100, Angles_ll_100, subj, ntrial, nside, answer, side );
     [ Angles, Kinetic ] = Get_Curves( Angles_ul_100, Angles_ll_100, Powers_100, TotPowers_100, Moments_100, subj, ntrial, nside, answer, side );
  clear Head Neck Shoulder Elbow Wrist Thorax Pelvis Hip Knee Ankle TRJ 
end
cd(Oldpath)
T = NestedStruct2table(AvgData);

Respath = uigetdir([],'Select folder to save: ');
filename =input('Insert file name to save: ','s');
save([Respath,'\',filename,'.mat'],'Angles','Kinetic','AvgData','T')
writetable(T,[Respath,'\',filename,'.xlsx'],'sheet',1)
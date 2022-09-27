%Questo script calcola la curva media e tutti i parametri cinematici medi tra trial
%diversi per un subj potendo o no distinguere tra destra e sinistra e ti
%predispone le matrici per il plot degli andamenti cinematici e cinetici della curva media
% import patient

clear

% Oldpath = pwd;
% addpath(Oldpath) %Susanna
addpath("tools\")

% Moment_100 = ones(100,3,6).*nan;
% Power_100 = ones(100,3,6).*nan;
% TotPower_100 = ones(100,3,1).*nan;


prompt = 'number of subjs: ';
nsubj = input(prompt,'s');
nsubj=str2double(nsubj);
TRJ_label={'lank', 'rank'};
AnglesUL_label={'lneckangles','lshoulderangles','lelbowangles','lwristangles','lheadangles','rneckangles','rshoulderangles','relbowangles','rwristangles','rheadangles'};
AnglesLL_label={'lpelvisangles', 'lhipangles', 'lkneeangles',  'lankleangles',  'lthoraxangles', 'lfootprogressangles','rpelvisangles','rhipangles','rkneeangles','rankleangles','rthoraxangles', 'rfootprogressangles'};
Moments_label={'lhipmoment',  'lkneemoment',  'lanklemoment','rhipmoment','rkneemoment', 'ranklemoment'};
Powers_label={'lhippower','lkneepower','lanklepower','rhippower','rkneepower','ranklepower'};
CoM_label={'centreofmass'};
Forces_label={'fx1','fx2','fy1','fy2','fz1','fz2'};
labels.AnglesUL_label = AnglesUL_label;
labels.AnglesLL_label = AnglesLL_label;
labels.Moments_label = Moments_label;
labels.Powers_label = Powers_label;
labels.Forces_label = Forces_label;

for subj = 1:nsubj
    Datapath = uigetdir;  
    fileList = dir(fullfile(Datapath, '*.c3d'));
    nc3d = length(fileList);
    c3dPaths = {fileList.folder};
    c3dNames = {fileList.name};
%     Angles_ul_100 = []; Angles_ll_100 = []; Moments_100 = []; Powers_100 = [];
    if isempty(nc3d)
        keyboard
    end
    SpatialData.FootOff_perc_L = []; %[Perc_footoff];
    SpatialData.StrideVelocity_L = []; % [stridelenght./1000./stride_time]; %[m/s]
    SpatialData.StrideLength_L = []; %[stridelenght./1000]; %[m]
    SpatialData.StrideTime_L = []; %[stride_time]; %[s]
    SpatialData.StanceTime_L = []; %[Stance_time ]; %[s]
    SpatialData.SwingTime_L = [];
    SpatialData.StepLength_L = [];
    SpatialData.Ini_Double_support_L = [];
    SpatialData.StepLength_L = [];
    SpatialData.Fin_Double_support_L = [];



    SpatialData.FootOff_perc_R = []; %[Perc_footoff];
    SpatialData.StrideVelocity_R = []; % [stridelenght./1000./stride_time]; %[m/s]
    SpatialData.StrideLength_R = []; %[stridelenght./1000]; %[m]
    SpatialData.StrideTime_R = []; %[stride_time]; %[s]
    SpatialData.StanceTime_R = []; %[Stance_time ]; %[s]
    SpatialData.SwingTime_R = [];
    SpatialData.StrideWidth = [];
    SpatialData.StepLength_R = [];
    SpatialData.Ini_Double_support_R = [];
    SpatialData.StepLength_R = [];
    SpatialData.Fin_Double_support_R = [];
    
    Data_left=cell(1,nc3d);
    Data100_left=cell(1,nc3d);  
    Data_right=cell(1,nc3d);
    Data100_right=cell(1,nc3d);  
    for j=1:nc3d
       
        FileName = [c3dPaths{j},filesep,c3dNames{j}];
        if isempty(FileName)
            prompt = 'Invalid file name';
        end
        
        
        c3d=c3d2c3d(FileName);
        events=c3devents(c3d,'abs'); %events are expressed in absolute frame and time
        acqpar.Frame_rate=c3d.c3dpar.point.rate;
        Subject_Name=char(c3d.c3dpar.subjects.names);
        if size(Subject_Name,1)>1
            keyboard
            Subject_Name=char(c3d.c3dpar.subjects.names{1});
            Doris_Name=char(c3d.c3dpar.subjects.names{2});
        end
        if isfield(c3d.c3dpar,'processing')
            acqpar.Bodymass=c3d.c3dpar.processing.bodymass;
        else
            sub = input('please insert bodymass ','s');
            acqpar.Bodymass = str2double(sub);
        end
        TRJ=c3dget(c3d,Subject_Name,TRJ_label);%trajectory
        if isempty(TRJ)
            for i= 1:length(TRJ_label)
                TRJ_label{i} = [Subject_Name,':',TRJ_label{i}];
            end
            TRJ=c3dget(c3d,Subject_Name,TRJ_label);%trajectory
        end
        
        

        AnglesUL=c3dget(c3d,Subject_Name,AnglesUL_label);
        if isempty(AnglesUL)
            for i= 1:length(AnglesUL_label)
                AnglesUL_label{i} = [Subject_Name,':',AnglesUL_label{i}];
            end
            AnglesUL=c3dget(c3d,Subject_Name,AnglesUL_label);
        end
        

        AnglesLL=c3dget(c3d,Subject_Name,AnglesLL_label);
        if isempty(AnglesLL)
            for i= 1:length(AnglesLL_label)
                AnglesLL_label{i} = [Subject_Name,':',AnglesLL_label{i}];
            end
            AnglesLL=c3dget(c3d,Subject_Name,AnglesLL_label);
        end
        
        
        CoM=c3dget(c3d,Subject_Name,CoM_label);
        if isempty(CoM)
            for i= 1:length(CoM_label)
                CoM_label{i} = [Subject_Name,':',CoM_label{i}];
            end
            CoM=c3dget(c3d,Subject_Name,CoM_label);
        end
        
        forces=c3dget(c3d,Subject_Name,Forces_label);
        if isempty(forces)
            forces=c3dget(c3d,Subject_Name,{'force.fx1','force.fx2','force.fy1','force.fy2','force.fz1','force.fz2'});
        end
        
        % Import Kinetic data
        Moments=c3dget(c3d,Subject_Name,Moments_label);
        if isempty(Moments)
            for i= 1:length(Moments_label)
                Moments_label{i} = [Subject_Name,':',Moments_label{i}];
            end
            Moments=c3dget(c3d,Subject_Name,Moments_label);
        end
        
        % imput powers
        Powers=c3dget(c3d,Subject_Name,Powers_label);
        if isempty(Powers)
            for i= 1:length(Powers_label)
                Powers_label{i} = [Subject_Name,':',Powers_label{i}];
            end
            Powers=c3dget(c3d,Subject_Name,Powers_label);
        end
        
        
        %% EMg left
         EMG_struct=loadmuscles(c3d);
            
        %         matrici con eventi. sulle righe i trial sulle colonne left=1 right=2
        [ analog,digital] = get_gaitALLevents( events );

        Data.analog=analog;
        Data.digital=digital;
        
        [ SpatialData ] = Get_TemporalSpatialParam( TRJ, acqpar.Frame_rate, digital,SpatialData );
   
        acqpar.afootoff = analog.footoff(:,1);
        acqpar.afootstrike1 = analog.footstrike1(:,1);
        acqpar.afootstrike2 = analog.footstrike2(:,1);
        acqpar.dfootoff = digital.footoff(:,1);
        acqpar.dfootstrike1 = digital.footstrike1(:,1);
        acqpar.dfootstrike2 = digital.footstrike2(:,1);
        [Data_left{j},Data100_left{j}] = ExtractParams(acqpar,AnglesUL(:,:,1:5),AnglesLL(:,:,1:6),EMG_struct.emgBP(:,:,1),EMG_struct.env(:,:,1),forces,CoM,Moments(:,:,1:3),Powers(:,:,1:3));
        
        
        
        acqpar.afootoff = analog.footoff(:,2);
        acqpar.afootstrike1 = analog.footstrike1(:,2);
        acqpar.afootstrike2 = analog.footstrike2(:,2);
        acqpar.dfootoff = digital.footoff(:,2);
        acqpar.dfootstrike1 = digital.footstrike1(:,2);
        acqpar.dfootstrike2 = digital.footstrike2(:,2);
       [Data_right{j},Data100_right{j}] = ExtractParams(acqpar,AnglesUL(:,:,6:10),AnglesLL(:,:,7:12),EMG_struct.emgBP(:,:,2),EMG_struct.env(:,:,2),forces,CoM,Moments(:,:,4:6),Powers(:,:,4:6));
     
       close all
          
    end
   
   [output_res] = get_res(Data_left,Data_right);
   
    if exist('FZ','var')==1;Data.FZ =FZ; Data.FX = FX; Data.FY = FY;end
    
    save([Subject_Name, '.mat'],'output_res','Data100_left','Data100_right','SpatialData');
    clear Data_left Data_right Data100_left Data100_right SpatialData 
    
    
    
end
% cd(Oldpath)
% T = NestedStruct2table(AvgData);

% Respath = uigetdir([],'Select folder to save: ');
% filename =input('Insert file name to save: ','s');
% save([Respath,'\',filename,'.mat'],'Angles','Kinetic','EMG','AvgData','T')
% 
% writetable(T,[Respath,'\',filename,'.xlsx'],'sheet',1)

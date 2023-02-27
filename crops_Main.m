%Questo script calcola la curva media e tutti i parametri cinematici medi tra trial
%diversi per un subj potendo o no distinguere tra destra e sinistra e ti
%predispone le matrici per il plot degli andamenti cinematici e cinetici della curva media
% import patient

clear

% Oldpath = pwd;
% addpath(Oldpath) %Susanna
addpath(['tools',filesep])
addpath(['c3dimport',filesep])

% Moment_100 = ones(100,3,6).*nan;
% Power_100 = ones(100,3,6).*nan;
% TotPower_100 = ones(100,3,1).*nan;
bodymassLabel=true;

% prompt = 'number of subjs: ';
nsubj = 1;%input(prompt,'s');
nsubj=str2double(nsubj);
TRJ_label={'lank', 'rank'};
TRJ2_label={'lank','lasi', 'rank','rasi'};
AnglesUL_label={'lneckangles','lshoulderangles','lelbowangles','lwristangles','lheadangles','rneckangles','rshoulderangles','relbowangles','rwristangles','rheadangles'};
AnglesLL_label={'lpelvisangles', 'lhipangles', 'lkneeangles',  'lankleangles',  'lthoraxangles', 'lfootprogressangles','rpelvisangles','rhipangles','rkneeangles','rankleangles','rthoraxangles', 'rfootprogressangles'};
Moments_label={'lhipmoment',  'lkneemoment',  'lanklemoment','rhipmoment','rkneemoment', 'ranklemoment'};
Powers_label={'lhippower','lkneepower','lanklepower','rhippower','rkneepower','ranklepower'};
Head_labels = {'lbhd','lfhd','rbhd','rfhd'};
Hands_labels ={'lwra','lwrb','rwra','rwrb'};
Feet_labels ={'ltoe','lhee','rtoe','rhee'};
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
    c3dPaths = {fileList.folder};
    c3dNames = {fileList.name};
    c3dNames( startsWith(c3dNames, '.') ) = [];  %exclude hidden files, which is same as . files on MacOS
    nc3d = length(c3dNames);

    fileListmat = dir(fullfile(Datapath, '*.mat'));
    matpath = {fileListmat.folder};
    matNames = {fileListmat.name};
    PlatformDoris = load([matpath{1},filesep,matNames{2}]);
    LDorisF = PlatformDoris.feme(:,3);
    ts = PlatformDoris.timestamp(:,4)*3600+PlatformDoris.timestamp(:,5)*60+PlatformDoris.timestamp(:,6);
    ts2 = ts-ts(1);
    FDoris =1/nanmean(diff(ts2));
    [sp_l,f_l]=pmtm(LDorisF,4,1:0.1:FDoris/2,FDoris);


    plot(f_l,sp_l,'b')

    xlabel('Frequency')
    Fc= 3; %4;->de Luca
    N = 2; %4; 
    Wn = Fc/(FDoris/2);
    [B, A] = butter(N,Wn, 'low'); %filter's parameters
    forceZ=filtfilt(B, A, LDorisF); %in the case of Off-line treatment

    figure
    plot(forceZ,'b');hold on; plot(LDorisF,'g:')
    Foot_ON = find(forceZ>2);
    diffON = find([diff(Foot_ON);1]>1);
    foot_ON_ind = Foot_ON(sort([1;diffON;diffON+1;length(Foot_ON)]));
    figure
    plot(forceZ,'b');hold on;plot(Foot_ON,forceZ(Foot_ON),'r.')
    if isempty(nc3d)
        keyboard
    end
    
    Data_left=cell(1,nc3d);
    Data100_left=cell(1,nc3d);  
    Data_right=cell(1,nc3d);
    Data100_right=cell(1,nc3d); 
    DataDoris = cell(1,nc3d);
    ind = 1:2:nc3d*2;

    
    keyboard
    for j=15:nc3d
       
        FileName = [c3dPaths{j},filesep,c3dNames{j}];
%         if c3dNames{j}(1)=='.'
%             ind = 1:2:nc3d;
%             continue
%         end
        if isempty(FileName)
            prompt = 'Invalid file name';
        end
        
        
        c3d=c3d2c3d(FileName);
        acqpar.Frame_rate=c3d.c3dpar.point.rate;
        Subjects_Names=c3d.c3dpar.subjects.names;
        if size(Subjects_Names,1)>1

            Subject_Name = Subjects_Names{~contains(lower(Subjects_Names),'doris')};
            Doris_Name= Subjects_Names{~contains(lower(Subjects_Names),Subject_Name)};
            Doriscenter=c3dget(c3d,Doris_Name,{[Doris_Name,':centro']});%trajectory

        else
            Subject_Name =char(Subjects_Names);
            Doriscenter =[];
        end
        if bodymassLabel
        if isfield(c3d.c3dpar,'processing')
            acqpar.Bodymass=c3d.c3dpar.processing.bodymass;
        else
            sub = input('please insert bodymass ','s');
            acqpar.Bodymass = str2double(sub);
            bodymassLabel=false;
        end
        end
        events=c3devents(c3d,'abs'); %events are expressed in absolute frame and time


        if ~isfield(events,'events') || isempty(events.events.right.event.vframe) || isempty(events.events.left.event.vframe) || ~isfield(events.events.left,'footstrike')
            TRJ2=c3dget(c3d,Subject_Name,TRJ2_label);%trajectory
            if isempty(TRJ2)
                for i= 1:length(TRJ2_label)
                    TRJ2_label{i} = [Subject_Name,':',TRJ2_label{i}];
                end
                TRJ2=c3dget(c3d,Subject_Name,TRJ2_label);%trajectory
            end
        
            [ events]=extrapolate_events(events,TRJ2);
%                 keyboard
        end
% lank=TRJ2(:,:,1);
% rank=TRJ2(:,:,3);
% figure;plot(lank,'DisplayName','lank')
% hold on
% plot(Doriscenter(:,3)*100)
%         line([events.events.right.footstrike.vframe(1) events.events.right.footstrike.vframe(1)],[-2000 2000])
% line([events.events.right.footstrike.vframe(2) events.events.right.footstrike.vframe(2)],[-2000 2000])
% line([events.events.right.footstrike.vframe(3) events.events.right.footstrike.vframe(3)],[-2000 2000])
% line([events.events.right.footstrike.vframe(4) events.events.right.footstrike.vframe(4)],[-2000 2000])
% line([events.events.right.footoff.vframe(3) events.events.right.footoff.vframe(3)],[-2000 2000],'col',[ 1 0 0])
% line([events.events.right.footoff.vframe(2) events.events.right.footoff.vframe(2)],[-2000 2000],'col',[ 1 0 0])
% line([events.events.right.footoff.vframe(1) events.events.right.footoff.vframe(1)],[-2000 2000],'col',[ 1 0 0])

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

        markers_head = c3dget(c3d,Subject_Name,Head_labels );
        if isempty(markers_head)
            for i= 1:length(Head_labels)
                Head_labels{i} = [Subject_Name,':',Head_labels{i}];
            end
            markers_head=c3dget(c3d,Subject_Name,Head_labels);
        end

        markers_feet = c3dget(c3d,Subject_Name,Feet_labels );
        if isempty(markers_feet)
            for i= 1:length(Feet_labels)
                Feet_labels{i} = [Subject_Name,':',Feet_labels{i}];
            end
            markers_feet=c3dget(c3d,Subject_Name,Feet_labels);
        end
       
        markers_hands = c3dget(c3d,Subject_Name,Hands_labels);
        if isempty(markers_hands)
            for i= 1:length(Hands_labels)
                Hands_labels{i} = [Subject_Name,':',Hands_labels{i}];
            end
            markers_hands=c3dget(c3d,Subject_Name,Hands_labels);
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
        
        [ SpatialData{j} ] = Get_TemporalSpatialParam( TRJ, acqpar.Frame_rate, digital );
   
        acqpar.afootoff = analog.footoff(:,1);
        acqpar.afootstrike1 = analog.footstrike1(:,1);
        acqpar.afootstrike2 = analog.footstrike2(:,1);
        acqpar.dfootoff = digital.footoff(:,1);
        acqpar.dfootstrike1 = digital.footstrike1(:,1);
        acqpar.dfootstrike2 = digital.footstrike2(:,1);

        try
        [Data_left{j},Data100_left{j}] = ExtractParams(acqpar,AnglesUL(:,:,1:5),AnglesLL(:,:,1:6),EMG_struct.emgBP(:,:,1),EMG_struct.env(:,:,1),forces,CoM,Moments(:,:,1:3),Powers(:,:,1:3),Doriscenter,TRJ(:,:,1),markers_hands(:,:,1:2),markers_head(:,:,1:2),markers_feet(:,:,1:2));
        catch
            keyboard

        end
        
        
        acqpar.afootoff = analog.footoff(:,2);
        acqpar.afootstrike1 = analog.footstrike1(:,2);
        acqpar.afootstrike2 = analog.footstrike2(:,2);
        acqpar.dfootoff = digital.footoff(:,2);
        acqpar.dfootstrike1 = digital.footstrike1(:,2);
        acqpar.dfootstrike2 = digital.footstrike2(:,2);
       [Data_right{j},Data100_right{j}] = ExtractParams(acqpar,AnglesUL(:,:,6:10),AnglesLL(:,:,7:12),EMG_struct.emgBP(:,:,2),EMG_struct.env(:,:,2),forces,CoM,Moments(:,:,4:6),Powers(:,:,4:6),Doriscenter,TRJ(:,:,2),markers_hands(:,:,3:4),markers_head(:,:,3:4),markers_feet(:,:,3:4));
     
%        close all
       
       [output_c3dres] = get_c3dres(Data_left{j},Data_right{j});
       left_series = Data100_left{j};right_series=Data100_right{j};param_st=SpatialData{j};
       try
       PlatformDorisTrial.cop = PlatformDoris.cop(foot_ON_ind(ind(j)):foot_ON_ind(ind(j)+1),:);
       PlatformDorisTrial.feme = PlatformDoris.feme(foot_ON_ind(ind(j)):foot_ON_ind(ind(j)+1),:);
       PlatformDorisTrial.pose = PlatformDoris.pose(foot_ON_ind(ind(j)):foot_ON_ind(ind(j)+1),:);
       PlatformDorisTrial.timestamp = PlatformDoris.timestamp(foot_ON_ind(ind(j)):foot_ON_ind(ind(j)+1),:);
       catch
           keyboard
       end
       DataDoris{j} = PlatformDorisTrial;
 
       save([c3dNames{j}(1:end-4), '.mat'],'output_c3dres','left_series','right_series','param_st','digital','PlatformDorisTrial');  
       clear output_c3dres left_series right_series param_st markers_hands markers_head markers_feet 
    end

%    [output_res] = get_res(Data_left,Data_right);
   
%     if exist('FZ','var')==1;Data.FZ =FZ; Data.FX = FX; Data.FY = FY;end %TO DO
%     
%     save([Subject_Name, '.mat'],'output_res','Data100_left','Data100_right','SpatialData');
    clear Data_left Data_right Data100_left Data100_right SpatialData 
    
    
    
end
% cd(Oldpath)
% T = NestedStruct2table(AvgData);

% Respath = uigetdir([],'Select folder to save: ');
% filename =input('Insert file name to save: ','s');
% save([Respath,'\',filename,'.mat'],'Angles','Kinetic','EMG','AvgData','T')
% 
% writetable(T,[Respath,'\',filename,'.xlsx'],'sheet',1)

function [ Moments_100,Powers_100,TotPowers_100,output_kinetic ] = kinetic( c3d )
%KINETIC Import Kinetic data
%   Detailed explanation goes here

Moments_label={'lhipmoment', 'rhipmoment', 'lkneemoment', 'rkneemoment', 'lanklemoment', 'ranklemoment'};
Powers_label={'lhippower','rhippower','lkneepower','rkneepower','lanklepower','ranklepower'};
Forces_label={'fx1','fx2','fy1','fy2','fz1','fz2'};
Subject_Name=char(c3d.c3dpar.subjects.names);
if isfield(c3d.c3dpar,'processing')
Bodymass=c3d.c3dpar.processing.bodymass;
end
 j=1;
events=c3devents(c3d,'abs'); %events are expressed in absolute frame and time
% matrici con eventi. sulle righe i trial sulle colonne left=1 right=2
[ footoff(j,:), footstrike1(j,:), footstrike2(j,:) ] = get_gaitevents( events );
Frame_rate=c3d.c3dpar.point.rate;
left_footstrikea=events.events.left.footstrike.aframe;
left_footoffa=events.events.left.footoff.aframe;
right_footoffa=events.events.right.footoff.aframe;
right_footstrikea=events.events.right.footstrike.aframe;

% Import Kinetic data
Moments=c3dget(c3d,Subject_Name,Moments_label);
% Moments(VALUES,Plane(sagittal, frontal, rotation),SERIES(l-rpelvis, l-rhip, etc))

%normalize at gait cycle %
nc = length(footstrike1(j,1):footstrike2(j,1));
t100 = linspace(1,nc,100);
%     Angles_ul_100 4-D 1-D: percent gait, 2-D: (x,y,z), 3-D: joints, 4-D:trials
for i = 1:2:length(Moments_label) %left
    Moments_100(:,1,i,j)= interp1(1:nc,Moments(footstrike1(j,1):footstrike2(j,1),1,i),t100,'linear');
    Moments_100(:,2,i,j)= interp1(1:nc,Moments(footstrike1(j,1):footstrike2(j,1),2,i),t100,'linear');
    Moments_100(:,3,i,j)= interp1(1:nc,Moments(footstrike1(j,1):footstrike2(j,1),3,i),t100,'linear');
end
nc = length(footstrike1(j,2):footstrike2(j,2));
for i = 2:2:length(Moments_label) %right
    Moments_100(:,1,i,j)= interp1(1:nc,Moments(footstrike1(j,2):footstrike2(j,2),1,i),t100,'linear');
    Moments_100(:,2,i,j)= interp1(1:nc,Moments(footstrike1(j,2):footstrike2(j,2),2,i),t100,'linear');
    Moments_100(:,3,i,j)= interp1(1:nc,Moments(footstrike1(j,2):footstrike2(j,2),3,i),t100,'linear');
end

%% Hip moments
LlenStride = footstrike2(j,1) - footstrike1(j,1);
RlenStride = footstrike2(j,2) - footstrike1(j,2);
Lsix_percent = round(LlenStride/100*6);
Rsix_percent = round(RlenStride/100*6);

[Hip.Extmoment(j,1), percind] = min((Moments(footstrike1(j,1)+Lsix_percent:footoff(j,1),1,1))); % +six_percent in order to avoid artifact from foot strike on platform
Hip.ExtMomperc(j,1) = (percind+Lsix_percent)/LlenStride*100; % Silvia
% (Max) Left hip extension moment (x)
[Hip.flexmoment(j,1), percind] = max((Moments(footstrike1(j,1)+Lsix_percent:footoff(j,1),1,1)));
Hip.flexMomperc(j,1) = (percind+Lsix_percent)/LlenStride*100; % Silvia
%     (Min) Right hip extension moment (x)
[Hip.Extmoment(j,2), percind] = min((Moments(footstrike1(j,2)+Rsix_percent:footoff(j,2),1,2)));
Hip.ExtMomperc(j,2) = (percind+Rsix_percent)/RlenStride*100; % Silvia
% (Max) Right hip flexion moment (x)
[Hip.flexmoment(j,2), percind] = max((Moments(footstrike1(j,2)+Rsix_percent:footoff(j,2),1,2)));
Hip.flexMomperc(j,2) = (percind+Rsix_percent)/RlenStride*100; % Silvia
% (Max) Left hip Abd/Add moment (y)
[Hip.Addmoment(j,1), percind] = max((Moments(footstrike1(j,1)+Lsix_percent:footoff(j,1),2,1))); % +six_percent in order to avoid artifact from foot strike on platform
Hip.AddMomperc(j,1)= (percind+Lsix_percent)/LlenStride*100; % Silvia
% (Max) Right hip Abd/Add moment (y)
[Hip.Addmoment(j,2), percind] = max((Moments(footstrike1(j,2)+Rsix_percent:footoff(j,2),2,2))); % +six_percent in order to avoid artifact from foot strike on platform
Hip.AddMomperc(j,2)= (percind+Rsix_percent)/RlenStride*100; % Silvia

%% Knee moments
[Knee.Extmoment(j,1), percind] = min((Moments(footstrike1(j,1)+Lsix_percent:footoff(j,1),1,3)));%Left knee extension moment
Knee.ExtMomperc(j,1) = (percind+Lsix_percent)/LlenStride*100; % Silvia
[Knee.Extmoment(j,2), percind] = min((Moments(footstrike1(j,2)+Rsix_percent:footoff(j,2),1,4)));%Right knee extension moment
Knee.ExtMomperc(j,2) = (percind+Rsix_percent)/RlenStride*100; % Silvia
[Knee.Flexmoment(j,1), percind] = max((Moments(footstrike1(j,1)+Lsix_percent:footoff(j,1),1,3)));
Knee.FlexMomperc(j,1) = (percind+Lsix_percent)/LlenStride*100; % Silvia
[Knee.Flexmoment(j,2), percind] = max((Moments(footstrike1(j,2)+Rsix_percent:footoff(j,2),1,4)));
Knee.FlexMomperc(j,2) = (percind+Rsix_percent)/RlenStride*100; % Silvia

%% ankle moments
L10_percent = round(LlenStride/100*10); R10_percent = round(RlenStride/100*10);
L30_percent = round(LlenStride/100*30); R30_percent = round(RlenStride/100*30);
[Ankle.Plantarmoment(j,1), percind] = min((Moments(footstrike1(j,1):footoff(j,1)-L30_percent,1,5)));%     Left ankle plantar moment
Ankle.PlantarMomperc(j,1) = percind/LlenStride*100;
[Ankle.Plantarmoment(j,2) percind] = min((Moments(footstrike1(j,2):footoff(j,2)-R30_percent,1,6))); %     Right ankle plantar moment
Ankle.PlantarMomperc(j,2) = percind/RlenStride*100;
[Ankle.dorsalmoment(j,1) percind] = max((Moments(footstrike1(j,1):footoff(j,1),1,5)));%    Left ankle dorsal moment
Ankle.dorsalMomperc(j,1) = percind/LlenStride*100;
[Ankle.dorsalmoment(j,2) percind] = max((Moments(footstrike1(j,2):footoff(j,2),1,6)));
Ankle.dorsalMomperc(j,2) = percind/RlenStride*100;

% imput powers
Powers=c3dget(c3d,Subject_Name,Powers_label);
%normalize at gait cycle %
nc = length(footstrike1(j,1):footstrike2(j,1));
t100 = linspace(1,nc,100);
%     Angles_ul_100 4-D 1-D: percent gait, 2-D: (x,y,z), 3-D: joints, 4-D:trials
for i = 1:2:length(Powers_label) %left
    Powers_100(:,1,i,j)= interp1(1:nc,Powers(footstrike1(j,1):footstrike2(j,1),1,i),t100,'linear');
    Powers_100(:,2,i,j)= interp1(1:nc,Powers(footstrike1(j,1):footstrike2(j,1),2,i),t100,'linear');
    Powers_100(:,3,i,j)= interp1(1:nc,Powers(footstrike1(j,1):footstrike2(j,1),3,i),t100,'linear');
end
nc = length(footstrike1(j,2):footstrike2(j,2));
for i = 2:2:length(Powers_label) %right
    Powers_100(:,1,i,j)= interp1(1:nc,Powers(footstrike1(j,2):footstrike2(j,2),1,i),t100,'linear');
    Powers_100(:,2,i,j)= interp1(1:nc,Powers(footstrike1(j,2):footstrike2(j,2),2,i),t100,'linear');
    Powers_100(:,3,i,j)= interp1(1:nc,Powers(footstrike1(j,2):footstrike2(j,2),3,i),t100,'linear');
end

% Powers extraction
LworkAnkleP=0; LworkAnkleN=0;
LworkHipP=0; LworkHipN=0;
LworkKneeP=0; LworkKneeN=0;

RworkAnkleP=0; RworkAnkleN=0;
RworkHipP=0; RworkHipN=0;
RworkKneeP=0; RworkKneeN=0;

%      hip generation power stance
Hip.GenPowerStance(j,1) = max((Powers(footstrike1(j,1)+Lsix_percent:footoff(j,1),3,1)));
Hip.GenPowerStance(j,2) = max((Powers(footstrike1(j,2)+Rsix_percent:footoff(j,2),3,2)));
%     hip absorption power stance
Hip.AbsPowerStance(j,1)=min((Powers(footstrike1(j,1)+Lsix_percent:footoff(j,1),3,1)));
Hip.AbsPowerStance(j,2)=min((Powers(footstrike1(j,2)+Rsix_percent:footoff(j,2),3,2)));
%   hip generation power swing
Hip.GenPowerSwing(j,1)=max((Powers(footoff(j,1):footstrike2(j,1),3,1)));
Hip.GenPowerSwing(j,2)=max((Powers(footoff(j,2):footstrike2(j,2),3,2)));

%      Knee generation power stance
Knee.GenPowerStance(j,1) = max((Powers(footstrike1(j,1)+Lsix_percent:footoff(j,1),3,3)));
Knee.GenPowerStance(j,2) = max((Powers(footstrike1(j,2)+Rsix_percent:footoff(j,2),3,4)));
%     Knee absorption power stance
Knee.AbsPowerStance(j,1)=min((Powers(footstrike1(j,1)+Lsix_percent:footoff(j,1),3,3)));
Knee.AbsPowerStance(j,2)=min((Powers(footstrike1(j,2)+Rsix_percent:footoff(j,2),3,4)));
%   Knee generation power swing
Knee.GenPowerSwing(j,1)=max((Powers(footoff(j,1):footstrike2(j,1),3,3)));
Knee.GenPowerSwing(j,2)=max((Powers(footoff(j,2):footstrike2(j,2),3,4)));

%    ankle generation power stance
Ankle.GenPower(j,1)=max((Powers(footstrike1(j,1)+Lsix_percent:footoff(j,1),3,5)));
Ankle.GenPower(j,2)=max((Powers(footstrike1(j,2)+Rsix_percent:footoff(j,2),3,6)));
%     ankle absorption power stance
Ankle.AbsPower(j,1)=min((Powers(footstrike1(j,1)+Lsix_percent:footoff(j,1),3,5)));
Ankle.AbsPower(j,2)=min((Powers(footstrike1(j,2)+Rsix_percent:footoff(j,2),3,6)));

TotPowerl=Powers(footstrike1(j,1):footstrike2(j,1),3,5)+Powers(footstrike1(j,1):footstrike2(j,1),3,3)+Powers(footstrike1(j,1):footstrike2(j,1),3,1);%left
TotPowerr=Powers(footstrike1(j,2):footstrike2(j,2),3,6)+Powers(footstrike1(j,2):footstrike2(j,2),3,4)+Powers(footstrike1(j,2):footstrike2(j,2),3,2);%right
nc = length(footstrike1(j,1):footstrike2(j,1));TotPowers_100(:,1)= interp1(1:nc,TotPowerl',t100,'linear');
nc = length(footstrike1(j,2):footstrike2(j,2));TotPowers_100(:,2)= interp1(1:nc,TotPowerr',t100,'linear');
for i=footstrike1(j,1)+Lsix_percent:footoff(j,1)
    if Powers(i,3,5)>0
        LworkAnkleP=LworkAnkleP+(Powers(i,3,5)*1/Frame_rate);
    else
        LworkAnkleN=LworkAnkleN+(abs(Powers(i,3,5))*1/Frame_rate);
    end
    
    if Powers(i,3,3)>0
        LworkKneeP=LworkKneeP+(Powers(i,3,3)*1/Frame_rate);
    else
        LworkKneeN=LworkKneeN+(abs(Powers(i,3,3))*1/Frame_rate);
    end
    
    if Powers(i,3,1)>0
        LworkHipP=LworkHipP+(Powers(i,3,1)*1/Frame_rate);
    else
        LworkHipN=LworkHipN+(abs(Powers(i,3,1))*1/Frame_rate);
    end
end
Ankle.workP(j,1)=LworkAnkleP; Ankle.workN(j,1)=LworkAnkleN; Knee.workP(j,1)=LworkKneeP;
Knee.workN(j,1)=LworkKneeN; Hip.workP(j,1)=LworkHipP; Hip.workN(j,1)=LworkHipN;

for i=footstrike1(j,2)+Rsix_percent:footoff(j,2)
    if Powers(i,3,6)>0
        RworkAnkleP=RworkAnkleP+(Powers(i,3,6)*1/Frame_rate);
    else
        RworkAnkleN=RworkAnkleN+(abs(Powers(i,3,6))*1/Frame_rate);
    end
    if Powers(i,3,4)>0
        RworkKneeP=RworkKneeP+(Powers(i,3,4)*1/Frame_rate);
    else
        RworkKneeN=RworkKneeN+(abs(Powers(i,3,4))*1/Frame_rate);
    end
    
    if Powers(i,3,2)>0
        RworkHipP=RworkHipP+(Powers(i,3,2)*1/Frame_rate);
    else
        RworkHipN=RworkHipN+(abs(Powers(i,3,2))*1/Frame_rate);
    end
end
Ankle.workP(j,2)=RworkAnkleP; Ankle.workN(j,2)=RworkAnkleN; Knee.workP(j,2)=RworkKneeP;
Knee.workN(j,2)=RworkKneeN; Hip.workP(j,2)=RworkHipP; Hip.workN(j,2)=RworkHipN;


%% imput platform forces
if isfield(c3d.c3dpar,'processing')
forces=c3dget(c3d,Subject_Name,Forces_label);
if isempty(forces)
    forces=c3dget(c3d,Subject_Name,{'force.fx1','force.fx2','force.fy1','force.fy2','force.fz1','force.fz2'});
end
% Forces extraction
LlenStridea = left_footstrikea(2)-left_footstrikea(1);
RlenStridea = right_footstrikea(2)-right_footstrikea(1);
L35_percent = round(LlenStridea/100*35);
R35_percent = round(RlenStridea/100*35);
m35_percent = mean(L35_percent,R35_percent);


if right_footstrikea(1)<left_footstrikea(1) % first strike right
    if forces(right_footstrikea(1)+30,1,6)==0 % first platform 1
        [RFirstmaxforce, RFirstpercind] = min((forces(right_footstrikea(1):right_footstrikea(1)+m35_percent,1,5)));
        [RSecondmaxforce, RSecondpercind]=min((forces(right_footstrikea(1)+m35_percent:right_footstrikea(2),1,5)));
        RSecondpercind = RSecondpercind+right_footstrikea(1)+m35_percent;
        [LFirstmaxforce, LFirstpercind]=min((forces(left_footstrikea(1):left_footstrikea(1)+m35_percent,1,6)));
        [LSecondmaxforce, LSecondpercind]=min((forces(left_footstrikea(1)+m35_percent:left_footstrikea(2),1,6)));
        LSecondpercind = LSecondpercind+left_footstrikea(1)+m35_percent;
        l=6; l1=2; l2=4;
        r=5; r1=1; r2=3;
        first=1;
    else % first platform 2
        [RFirstmaxforce, RFirstpercind] = min((forces(right_footstrikea(1):right_footstrikea(1)+m35_percent,1,6)));
        [RSecondmaxforce, RSecondpercind] = min((forces(right_footstrikea(1)+m35_percent:right_footstrikea(2),1,6)));
        RSecondpercind = RSecondpercind+right_footstrikea(1)+m35_percent;
        [LFirstmaxforce, LFirstpercind] = min((forces(left_footstrikea(1):left_footstrikea(1)+m35_percent,1,5)));
        [LSecondmaxforce, LSecondpercind] = min((forces(left_footstrikea(1)+m35_percent:left_footstrikea(2),1,5)));
        LSecondpercind = LSecondpercind+left_footstrikea(1)+m35_percent;
        l=5; l1=1; l2=3;
        r=6; r1=2; r2=4;
        first=2;
    end
else   % first strike left
    if forces(left_footstrikea(1)+30,1,6)==0 % first platform 1
        [LFirstmaxforce, LFirstpercind]=min((forces(left_footstrikea(1):left_footstrikea(1)+m35_percent,1,5)));
        [LSecondmaxforce, LSecondpercind]=min((forces(left_footstrikea(1)+m35_percent:left_footstrikea(2),1,5)));
        LSecondpercind = LSecondpercind+left_footstrikea(1)+m35_percent;
        [RFirstmaxforce, RFirstpercind]=min((forces(right_footstrikea(1):right_footstrikea(1)+m35_percent,1,6)));
        [RSecondmaxforce, RSecondpercind]=min((forces(right_footstrikea(1)+m35_percent:right_footstrikea(2),1,6)));
        RSecondpercind = RSecondpercind+right_footstrikea(1)+m35_percent;
        l=5; l1=1; l2=3;
        r=6; r1=2; r2=4;
        first=1;
    else % first platform 2
        [LFirstmaxforce, LFirstpercind ] = min((forces(left_footstrikea(1):left_footstrikea(1)+m35_percent,1,6)));
        [LSecondmaxforce, LSecondpercind ]=min((forces(left_footstrikea(1)+m35_percent:left_footstrikea(2),1,6)));
        LSecondpercind = LSecondpercind+left_footstrikea(1)+m35_percent;
        [RFirstmaxforce, RFirstpercind]=min((forces(right_footstrikea(1):right_footstrikea(1)+m35_percent,1,5)));
        [RSecondmaxforce, RSecondpercind ]=min((forces(right_footstrikea(1)+m35_percent:right_footstrikea(2),1,5)));
        RSecondpercind = RSecondpercind+right_footstrikea(1)+m35_percent;
        l=6; l1=2; l2=4;
        r=5; r1=1; r2=3;
        first=2;
        
    end
end

FZ.Firstmaxforceperc(j,2)=RFirstpercind/RlenStridea*100;%     Right first FZ max
FZ.Firstmaxforce(j,2)=abs(RFirstmaxforce/(Bodymass/.98)*10);

FZ.Secondmaxforceperc(j,2) = RSecondpercind/RlenStridea*100;%     Right second FZ max
FZ.Secondmaxforce(j,2)=abs(RSecondmaxforce/(Bodymass/.98)*10);

FZ.Firstmaxforceperc(j,1) = LFirstpercind/LlenStridea*100;%     Left first FZ max
FZ.Firstmaxforce(j,1)=abs(LFirstmaxforce/(Bodymass/.98)*10);

FZ.Secondmaxforceperc(j,1)=LSecondpercind/RlenStridea*100;%     Left second FZ max
FZ.Secondmaxforce(j,1)=abs(LSecondmaxforce/(Bodymass/.98)*10);


Rminforce=max((forces(RFirstpercind:RSecondpercind,1,r)));%     Right FZ min
FZ.minforce(j,2)=abs(Rminforce/(Bodymass/.98)*10);

Lminforce=max((forces(LFirstpercind:LSecondpercind,1,l)));%     Left FZ min
FZ.minforce(j,1)=abs(Lminforce/(Bodymass/.98)*10);

if first==1
    Rintforce=min((forces(right_footstrikea(1):right_footstrikea(2),1,r1)));
    Lintforce=min((forces(left_footstrikea(1):left_footstrikea(2),1,l1)));
    Rextforce=max((forces(right_footstrikea(1):right_footstrikea(2),1,r1)));
    Lextforce=max((forces(left_footstrikea(1):left_footstrikea(2),1,l1)));
else
    Rintforce=max((forces(right_footstrikea(1):right_footstrikea(2),1,r1)));
    Lintforce=max((forces(left_footstrikea(1):left_footstrikea(2),1,l1)));
    Rextforce=min((forces(right_footstrikea(1):right_footstrikea(2),1,r1)));
    Lextforce=min((forces(left_footstrikea(1):left_footstrikea(2),1,l1)));
end

FX.intforce(j,2)=abs(Rintforce/(Bodymass/.98)*10); %     Right internal Fx max
FX.intforce(j,1)=abs(Lintforce/(Bodymass/.98)*10);  %     Left internal Fx max
FX.extforce(j,2)=abs(Rextforce/(Bodymass/.98)*10); %     Right external Fx max
FX.extforce(j,1)=abs(Lextforce/(Bodymass/.98)*10); %     Left external Fx max

if first==1
    RpushYforce=max((forces(right_footstrikea(1):right_footstrikea(2),1,r2)));
    LpushYforce=max((forces(left_footstrikea(1):left_footstrikea(2),1,l2)));
    RbreakYforce=min((forces(right_footstrikea(1):right_footstrikea(2),1,r2)));
    LbreakYforce=min((forces(left_footstrikea(1):left_footstrikea(2),1,l2)));
else
    RpushYforce=min((forces(right_footstrikea(1):right_footstrikea(2),1,r2)));
    LpushYforce=min((forces(left_footstrikea(1):left_footstrikea(2),1,l2)));
    RbreakYforce=max((forces(right_footstrikea(1):right_footstrikea(2),1,r2)));
    LbreakYforce=max((forces(left_footstrikea(1):left_footstrikea(2),1,l2)));
end

FY.pushYforce(j,2)=abs(RpushYforce/(Bodymass/.98)*10); %     Right push Fy max
FY.pushYforce(j,1)=abs(LpushYforce/(Bodymass/.98)*10);%     Left push Fy max
FY.breakYforce(j,2)=abs(RbreakYforce/(Bodymass/.98)*10);%     Right break Fy max
FY.breakYforce(j,1)=abs(LbreakYforce/(Bodymass/.98)*10);%     Left break Fy max
output_kinetic.FZ =FZ; output_kinetic.FX = FX; output_kinetic.FY = FY;
end
 output_kinetic.Hip = Hip; output_kinetic.Knee = Knee; output_kinetic.Ankle = Ankle;
 

end


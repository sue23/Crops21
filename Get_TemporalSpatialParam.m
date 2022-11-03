function [ SpatialData ] = Get_TemporalSpatialParam( TRJ, Frame_rate, digital_events )
%GET_TEMPORALSPATIALPARAM compute the spatial paramaters
%   inputs: TRJ - the ankles trajecory
%           Frame_rate
%           digital_events - a struct containing gait events in digital
%           framerate
%   outputs:the struct SpatialData. this struct contains indicators for the left and the right foot.
%            - FootOff_perc
%            - StrideVelocity
%            - StrideLength
%            - StrideTime
%            - StrideWidth
%            - StepLength
%            - StanceTime
%            - SwingTime

footoff_L = digital_events.footoff(:,1);
footstrike1_L = digital_events.footstrike1(:,1);
footstrike2_L =digital_events.footstrike2(:,1);
footoff_R = digital_events.footoff(:,2);
footstrike1_R = digital_events.footstrike1(:,2);
footstrike2_R =digital_events.footstrike2(:,2);

 nstride_L = size(footoff_L,1);
 nstride_R = size(footoff_R,1);
        
[ spatial_param ] = get_spatialparam_v3( TRJ(:,:,1), Frame_rate, footoff_L, footstrike1_L, footstrike2_L );
SpatialData.FootOff_perc_L = [spatial_param(:,1)]; %[Perc_footoff];
SpatialData.StrideVelocity_L = [spatial_param(:,2)]; % [stridelenght./1000./stride_time]; %[m/s]
SpatialData.StrideLength_L = [spatial_param(:,3)]; %[stridelenght./1000]; %[m]
SpatialData.StrideTime_L = [spatial_param(:,4)]; %[stride_time]; %[s]
SpatialData.StanceTime_L = [spatial_param(:,5)]; %[Stance_time ]; %[s]
SpatialData.SwingTime_L = [spatial_param(:,6)]; %[Swing_time ]; %[s]


[ spatial_param ] = get_spatialparam_v3( TRJ(:,:,2), Frame_rate, footoff_R, footstrike1_R, footstrike2_R );
SpatialData.FootOff_perc_R = [spatial_param(:,1)]; %[Perc_footoff];
SpatialData.StrideVelocity_R = [spatial_param(:,2)]; % [stridelenght./1000./stride_time]; %[m/s]
SpatialData.StrideLength_R = [ spatial_param(:,3)]; %[stridelenght./1000]; %[m]
SpatialData.StrideTime_R = [spatial_param(:,4)]; %[stride_time]; %[s]
SpatialData.StanceTime_R = [spatial_param(:,5)]; %[Stance_time ]; %[s]
SpatialData.SwingTime_R = [spatial_param(:,6)]; %[Swing_time ]; %[s]

SpatialData.StrideWidth= [abs(TRJ(footstrike1_L(1:min([nstride_L,nstride_R])),1,1)-TRJ(footstrike1_R(1:min([nstride_L,nstride_R])),1,2))/1000];  %[Lstridewidth/1000 Rstridewidth/1000]; %[m]


if footstrike1_R(1:min([nstride_L,nstride_R]))>footstrike1_L(1:min([nstride_L,nstride_R])) %inizio con il sinistro
    SpatialData.StepLength_L= [ (abs(TRJ(footstrike2_L(1:min([nstride_L,nstride_R])),2,1)-TRJ(footstrike1_R(1:min([nstride_L,nstride_R])),2,2)))/1000];
    SpatialData.StepLength_R= [ (abs(TRJ(footstrike1_R(1:min([nstride_L,nstride_R])),2,2)-TRJ(footstrike1_L(1:min([nstride_L,nstride_R])),2,1)))/1000];
else
    SpatialData.StepLength_L= [(abs(TRJ(footstrike1_L(1:min([nstride_L,nstride_R])),2,1)-TRJ(footstrike1_R(1:min([nstride_L,nstride_R])),2,2)))/1000];
    SpatialData.StepLength_R= [ (abs(TRJ(footstrike2_R(1:min([nstride_L,nstride_R])),2,2)-TRJ(footstrike1_L(1:min([nstride_L,nstride_R])),2,1)))/1000];
end

if footstrike1_R(1)<footstrike1_L(1) %inizio con il ciclo destri quindi posso per la destra prendere solo i DS finali mentre sulla sinistra prendo i DS iniziali
    SpatialData.Fin_Double_support_R= [(footoff_R(1:min([nstride_L,nstride_R]))-footstrike1_L(1:min([nstride_L,nstride_R])))/Frame_rate];
    SpatialData.Ini_Double_support_L= [( footoff_L(1:min([nstride_L,nstride_R]))-footstrike2_R(1:min([nstride_L,nstride_R])))/Frame_rate];
else
    SpatialData.Fin_Double_support_L= [(footoff_L(1:min([nstride_L,nstride_R]))-footstrike1_R(1:min([nstride_L,nstride_R])))/Frame_rate];
    SpatialData.Ini_Double_support_R= [( footoff_R(1:min([nstride_L,nstride_R]))-footstrike2_L(1:min([nstride_L,nstride_R])))/Frame_rate];
end
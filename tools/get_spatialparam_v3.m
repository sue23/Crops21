function [ spatial_param ] = get_spatialparam_v3( TRJ, Frame_rate, footoff, footstrike1, footstrike2 )
%GET_SPATIALPARAM compute the spatial paramaters 
%   inputs: TRJ - the ankle trajecory 
%           Frame_rate
%           footoff - vector 1x2. First column left, second column right
%           footstrike1 - vector 1x2. First column left, second column right
%           footstrike2 - vector 1x2. First column left, second column right
%   outputs:the matrix spatialparam. this matrix contains indicators for the left and the right foot. 
%            - FootOff_perc
%            - StrideVelocity                
%            - StrideLength
%            - StrideTime
%            - StrideWidth->no
%            - StepLength->no
%            - StanceTime
%            - SwingTime

Stride_time=(footstrike2-footstrike1)/Frame_rate;

Perc_footoff=((footoff-footstrike1)/Frame_rate)./Stride_time*100;


stridelenght=abs(TRJ(footstrike2,2)-TRJ(footstrike1,2));


% Lstepwidth=abs(TRJ(footstrike1(1),1,1)-TRJ(footstrike1(2),1,2)); %questo è lo step!


% if footstrike1(1)<footstrike1(2)
%     Lsteplenght=abs(TRJ(footstrike2(1),2,1)-TRJ(footstrike1(2),2,2));
%     Rsteplenght=abs(TRJ(footstrike1(2),2,2)-TRJ(footstrike1(1),2,1));
% else
%     Lsteplenght=abs(TRJ(footstrike1(1),2,1)-TRJ(footstrike1(2),2,2));
%     Rsteplenght=abs(TRJ(footstrike2(2),2,2)-TRJ(footstrike1(1),2,1));
% end
Stance_time=(footoff-footstrike1)/Frame_rate;


Swing_time=(footstrike2-footoff)/Frame_rate;


% if footstrike1(1)<footstrike1(2) 
%     %ciclo sinistro
%     Ini_Double_support= (footoff(2)-footstrike1(1))/Frame_rate;
%     Fin_Double_support= (footoff(1)-footstrike1(2))/Frame_rate;
% else 
%     %ciclo destro
%     Ini_Double_support= (footoff(1)-footstrike1(2))/Frame_rate;
%     Fin_Double_support= (footoff(2)-footstrike1(1))/Frame_rate;
% end


% spatial_param.FootOff_perc = [Percleft_footoff Percright_footoff];
% spatial_param.StrideVelocity = [Lstridelenght./1000./left_time Rstridelenght./1000./right_time]; %[m/s]
% spatial_param.StrideLength = [Lstridelenght./1000 Rstridelenght./1000]; %[m]
% spatial_param.StrideTime = [left_time right_time]; %[s]
% spatial_param.StrideWidth = [Lstridewidth/1000 Rstridewidth/1000]; %[m]
% spatial_param.StepLength = [Lsteplenght/1000 Rsteplenght/1000]; %[m]
% spatial_param.StanceTime = [LStance_time RStance_time]; %[s]
% spatial_param.SwingTime = [LSwing_time RSwing_time]; %[s]

spatial_param = [Perc_footoff ,stridelenght./1000./Stride_time ,stridelenght./1000 ,...
    Stride_time ,Stance_time ,    Swing_time   ];

end


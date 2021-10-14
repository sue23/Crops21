function [ spatial_param ] = get_spatialparam( TRJ, Frame_rate, footoff, footstrike1, footstrike2 )
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
%            - StrideWidth
%            - StepLength
%            - StanceTime
%            - SwingTime

left_time=(footstrike2(1)-footstrike1(1))/Frame_rate;
right_time=(footstrike2(2)-footstrike1(2))/Frame_rate;

Percleft_footoff=((footoff(1)-footstrike1(1))/Frame_rate)/left_time*100;
Percright_footoff=((footoff(2)-footstrike1(2))/Frame_rate)/right_time*100;

Lstridelenght=abs(TRJ(footstrike2(1),2,1)-TRJ(footstrike1(1),2,1));
Rstridelenght=abs(TRJ(footstrike2(2),2,2)-TRJ(footstrike1(2),2,2));

Lstepwidth=abs(TRJ(footstrike1(1),1,1)-TRJ(footstrike1(2),1,2)); %questo è lo step!
Rstepwidth=abs(TRJ(footstrike2(2),1,2)-TRJ(footstrike2(1),1,1));

if footstrike1(1)<footstrike1(2)
    Lsteplenght=abs(TRJ(footstrike2(1),2,1)-TRJ(footstrike1(2),2,2));
    Rsteplenght=abs(TRJ(footstrike1(2),2,2)-TRJ(footstrike1(1),2,1));
else
    Lsteplenght=abs(TRJ(footstrike1(1),2,1)-TRJ(footstrike1(2),2,2));
    Rsteplenght=abs(TRJ(footstrike2(2),2,2)-TRJ(footstrike1(1),2,1));
end

LStance_time=(footoff(1)-footstrike1(1))/Frame_rate;
RStance_time=(footoff(2)-footstrike1(2))/Frame_rate;

LSwing_time=(footstrike2(1)-footoff(1))/Frame_rate;
RSwing_time=(footstrike2(2)-footoff(2))/Frame_rate;

if footstrike1(1)<footstrike1(2) 
    %ciclo sinistro
    Ini_Double_support= (footoff(2)-footstrike1(1))/Frame_rate;
    Fin_Double_support= (footoff(1)-footstrike1(2))/Frame_rate;
else 
    %ciclo destro
    Ini_Double_support= (footoff(1)-footstrike1(2))/Frame_rate;
    Fin_Double_support= (footoff(2)-footstrike1(1))/Frame_rate;
end


% spatial_param.FootOff_perc = [Percleft_footoff Percright_footoff];
% spatial_param.StrideVelocity = [Lstridelenght./1000./left_time Rstridelenght./1000./right_time]; %[m/s]
% spatial_param.StrideLength = [Lstridelenght./1000 Rstridelenght./1000]; %[m]
% spatial_param.StrideTime = [left_time right_time]; %[s]
% spatial_param.StrideWidth = [Lstridewidth/1000 Rstridewidth/1000]; %[m]
% spatial_param.StepLength = [Lsteplenght/1000 Rsteplenght/1000]; %[m]
% spatial_param.StanceTime = [LStance_time RStance_time]; %[s]
% spatial_param.SwingTime = [LSwing_time RSwing_time]; %[s]

spatial_param = [[Percleft_footoff Percright_footoff];[Lstridelenght./1000./left_time Rstridelenght./1000./right_time];[Lstridelenght./1000 Rstridelenght./1000];...
    [left_time right_time];[Lstepwidth/1000 Rstepwidth/1000];[Lsteplenght/1000 Rsteplenght/1000];[LStance_time RStance_time];...
    [LSwing_time RSwing_time]; [Ini_Double_support Fin_Double_support] ];

end


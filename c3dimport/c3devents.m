

function param=c3devents(c3d,varargin)
%C3DEVENTS convert the event field in a more usable event struct  
%
%   PAR=C3DEVENTS(C3D,OPT) 
%
%   INPUTS:
%       C3D - c3d structure (field c3d.c3dpar must be present
%       OPT - 'abs' -> events are expressed in absolute frame and time
%             'rel' -> events are expressed in relative frame and time
%
%   OUTPUTS
%       PAR - structure defined as follows:
%           .events, structure:
%               .context.event.when
%                   context - 'right', 'left', 'general'
%                   event - 'footoff', 'footstrike', 'general'
%                   when  - 'time' 'aframe' 'vframe'
%                   time - time in seconds
%                   aframe - analog frame
%                   vframe - video frame
%           DT - [1x2] time interval  
%           DF - [1x2] frame interval
%           video_fs  - video frame rate
%           analog_fs - analog frame rate
%
%   See also c3dimport, c3dget.

%   Copyright None!
%   $Revision: 2.0 $  $Date: 2006/10/5
%   $Author: F. Patanè, 2006%
% $Revision: 2.0 $  $Date: 2017/07/10

c3dpar=c3d.c3dpar;

param.DF=[1,c3dpar.point.frames]+c3dpar.trial.actual_start_field(1)-1;
param.Dt=(param.DF-1)/c3dpar.point.rate;
param.video_fs=c3dpar.trial.camera_rate/c3dpar.trial.video_rate_divider;
param.analog_fs=c3dpar.analog.rate;
%inizializations
rfo=[];
rfs=[];
lfo=[];
lfs=[];
contextlabel=c3dpar.event_context.labels;
eventlabel=c3d.c3dpar.event.labels;
VFs=param.video_fs;
AFs=param.analog_fs;

absF=0;
absT=0;
if nargin==2
    switch varargin{1}
        case 'abs'
absF=param.DF(1)+1;
absT=param.Dt(1);
        case 'rel'           
        otherwise
            error('option not allowed');
    end
end

if isempty(c3dpar.event.times), return; end
time=c3dpar.event.times(2,:)'-absT+c3dpar.event.times(1,:)'*60;
% round time events to the near video Frame
frame=round(time*VFs);%/VFs; modificato da susanna summa 10/07/2017

% create the structure of stepcycle
stepevent={};
for cl=1:length(contextlabel)
   context={};
   for el=1:length(eventlabel)
      t=  sort( (strcmp(c3dpar.event.contexts,contextlabel{cl}) & strcmp(c3dpar.event.labels,eventlabel{el})).*time);
      t=t(t>0);
      event=struct('time',t,'vframe',round(t*VFs),'aframe',round(t*AFs));%modificato da susanna summa 10/07/2017
%       event=struct('time',t,'vframe',round(t*VFs+1),'aframe',round(t*AFs+AFs/AFs));%ho dovuto mettere round altrimenti mi toppa
      eltemp=eventlabel{el};
      context=setfield(context,eltemp(eltemp~=' '),event);
   end
   param=setfield(param,'events',contextlabel{cl},context);
end

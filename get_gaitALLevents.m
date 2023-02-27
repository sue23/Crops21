function [ analog, digital ]= get_gaitALLevents( events)
%GET_GAITEVENTS finds the fundamental events of the gait such as first and
%second heelstrike and toe-off
%  inputs: struct events obtained by c3devents function
%  outputs:
%     footoff - vector 1x2. First column left, second column right
%     footstrike1 - vector 1x2. First column left, second column right
%     footstrike2 - vector 1x2. First column left, second column right
% keyboard
left_footstrike=events.events.left.footstrike.vframe;
left_footoff=events.events.left.footoff.vframe;
right_footstrike=events.events.right.footstrike.vframe;
right_footoff=events.events.right.footoff.vframe;
%% check gait cycles events number
% order events
len(1)=size(left_footstrike,1);
len(2)=size(left_footoff,1);
len(3)=size(right_footstrike,1);
len(4)=size(right_footoff,1);
mlen=max(len);

if len(2)~=(len(1)-1) | len(4)~=(len(3)-1)
    msg = 'ERROR: number of footstrike and footoff are not coherent. Please check the c3d on nexus';
    error(msg)
end


n_leftfootoff=len(2);
if n_leftfootoff~=0

left_footstrike1=left_footstrike(1:end-1,1); %n_leftfootoff
left_footstrike2=left_footstrike(2:end,1);

else 
    left_footstrike1=nan;
    left_footstrike2=nan;
end
n_rightfootoff=len(4);
if n_rightfootoff~=0

right_footstrike1=right_footstrike(1:end-1,1);
right_footstrike2=right_footstrike(2:end,1);
else 
    right_footstrike1=nan;
    right_footstrike2=nan;
end




%% Same thing for analog (EMG)

aleft_footstrike=events.events.left.footstrike.aframe;
aleft_footoff=events.events.left.footoff.aframe;
aright_footstrike=events.events.right.footstrike.aframe;
aright_footoff=events.events.right.footoff.aframe;
% order events
len(1)=size(aleft_footstrike,1);
len(2)=size(aleft_footoff,1);
len(3)=size(aright_footstrike,1);
len(4)=size(aright_footoff,1);
mlen=max(len);




an_leftfootoff=len(2);
if an_leftfootoff~=0
% left_footstrike(1:n_leftfootoff,1);
aleft_footstrike1=aleft_footstrike(1:end-1,1); %n_leftfootoff
aleft_footstrike2=aleft_footstrike(2:end,1);

else 
    aleft_footstrike1=nan;
    aleft_footstrike2=nan;
end
an_rightfootoff=len(4);
if an_rightfootoff~=0

aright_footstrike1=aright_footstrike(1:end-1,1);
aright_footstrike2=aright_footstrike(2:end,1);
else 
    aright_footstrike1=nan;
    aright_footstrike2=nan;
end


analog.footoff=[aleft_footoff aright_footoff];
analog.footstrike1=[aleft_footstrike1 aright_footstrike1];
analog.footstrike2=[aleft_footstrike2 aright_footstrike2];


digital.footoff=[left_footoff right_footoff];
digital.footstrike1=[left_footstrike1 right_footstrike1];
digital.footstrike2=[left_footstrike2 right_footstrike2];





end


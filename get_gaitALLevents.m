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
% % put all events array to the same length adding zeroes to the shortest ones
% % add a second column with 1 for left and 2 for right side
% % add a third column with type(1 strike, 0 off)
% left_footstrike(:,2:3)=1;
% 
% 
% if len(1)~=mlen
% %     left_footstrike(mlen,:)=nan; % modifica 24/11
%     left_footstrike=[left_footstrike; nan*ones(mlen-len(1),size(left_footstrike,2))]; 
% end
% 
% left_footoff(:,2)=1;
% left_footoff(:,3)=0;
% 
% 
% if len(2)~=mlen
% %     left_footoff(mlen,:)=nan; 
%     left_footoff=[left_footoff; nan*ones(mlen-len(2),size(left_footoff,2))]; 
% end
% 
% right_footstrike(:,2)=2;
% right_footstrike(:,3)=1;
% 
% if len(3)~=mlen
% %     right_footstrike(mlen,:)=nan; 
%     right_footstrike=[right_footstrike; nan*ones(mlen-len(3),size(right_footstrike,2))]; 
% end
% 
% right_footoff(:,2)=2;
% right_footoff(:,3)=0;
% 
% if len(4)~=mlen
% %     right_footoff(mlen,:)=nan; 
%     right_footoff=[right_footoff; nan*ones(mlen-len(4),size(right_footoff,2))];
% end
% put Foot strike and off events in Cronological order %
%Now events are in a matrix (frame, side(1 left, 2 right), type(1 strike, 0 off)
% events_order = sortrows([left_footstrike;right_footstrike;left_footoff;right_footoff]);

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

% if n_rightfootoff==0
%     footoff = [ left_footoff(:,1) nan*ones(size(left_footoff(:,1)))];
%     footstrike1 = [left_footstrike1 nan*ones(size(left_footstrike1))];
%     footstrike2 = [left_footstrike2 nan*ones(size(left_footstrike2))];
% 
%     
% elseif n_leftfootoff==0
%     footoff = [ nan*ones(size (right_footoff(:,1))) right_footoff(:,1)];
%     footstrike1 = [nan*ones(size(right_footstrike1)) right_footstrike1];
%     footstrike2 = [nan*ones(size(right_footstrike2)) right_footstrike2];
%     
% % elseif n_rightfootoff~=n_leftfootoff
% %     Dn = n_rightfootoff-n_leftfootoff;
% %     if Dn>0 %left ha meno cicli
% %         [left_footoff(:,1);
% %         
% 
% else
%    
%    
%     footoff = [left_footoff(:,1) right_footoff(:,1)];
%     footstrike1 = [left_footstrike1 right_footstrike1];
%     
%     footstrike2 = [left_footstrike2 right_footstrike2];
% 
% end


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
% % put all events array to the same length adding zeroes to the shortest ones
% % add a second column with 1 for left and 2 for right side
% % add a third column with type(1 strike, 0 off)
% aleft_footstrike(:,2:3)=1;
% 
% 
% if len(1)~=mlen
%     aleft_footstrike(mlen,:)=nan; % modifica 24/11
% end
% 
% 
% aleft_footoff(:,2)=1;
% aleft_footoff(:,3)=0;
% 
% if mlen-len(2)>1%len(2)~=mlen
%     aleft_footoff(mlen,:)=nan; % modifica 22/11
%     
% end
% 
% aright_footstrike(:,2)=2;
% aright_footstrike(:,3)=1;
% 
% if len(3)~=mlen
%     aright_footstrike(mlen,:)=nan; % modifica 24/11
% end
% 
% aright_footoff(:,2)=2;
% aright_footoff(:,3)=0;
% 
% if mlen-len(4)>1%len(4)~=mlen
%     aright_footoff(mlen,:)=nan; % modifica 22/11
% end
% 
% % put Foot strike and off events in Cronological order %
% %Now events are in a matrix (frame, side(1 left, 2 right), type(1 strike, 0 off)
% % events_order = sortrows([left_footstrike;right_footstrike;left_footoff;right_footoff]);



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

% if an_rightfootoff==0
%     afootoff = [ aleft_footoff(:,1) nan*ones(size(aleft_footoff(:,1)))];
%     afootstrike1 = [aleft_footstrike1 nan*ones(size(aleft_footstrike1))];
%     afootstrike2 = [aleft_footstrike2 nan*ones(size(aleft_footstrike2))];
% 
%     
% elseif an_leftfootoff==0
%     afootoff = [ nan*ones(size (aright_footoff(:,1))) aright_footoff(:,1)];
%     afootstrike1 = [nan*ones(size(aright_footstrike1)) aright_footstrike1];
%     afootstrike2 = [nan*ones(size(aright_footstrike2)) aright_footstrike2];
% 
% else
%    
%    
%     afootoff = [aleft_footoff(:,1) aright_footoff(:,1)];
%     afootstrike1 = [aleft_footstrike1 aright_footstrike1];
%     
%     afootstrike2 = [aleft_footstrike2 aright_footstrike2];
% 
% end
% 


analog.footoff=[aleft_footoff aright_footoff];
analog.footstrike1=[aleft_footstrike1 aright_footstrike1];
analog.footstrike2=[aleft_footstrike2 aright_footstrike2];


digital.footoff=[left_footoff right_footoff];
digital.footstrike1=[left_footstrike1 right_footstrike1];
digital.footstrike2=[left_footstrike2 right_footstrike2];





end


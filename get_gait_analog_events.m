function [ footoff, footstrike1, footstrike2 ] = get_gait_analog_events( events )
%GET_GAITEVENTS finds the fundamental events of the gait such as first and
%second heelstrike and toe-off
%  inputs: struct events obtained by c3devents function
%  outputs:
%     footoff - vector 1x2. First column left, second column right
%     footstrike1 - vector 1x2. First column left, second column right
%     footstrike2 - vector 1x2. First column left, second column right

left_footstrike=events.events.left.footstrike.aframe;
left_footoff=events.events.left.footoff.aframe;
right_footoff=events.events.right.footoff.aframe;
right_footstrike=events.events.right.footstrike.aframe;

% order events
len(1)=size(left_footstrike,1);
len(2)=size(left_footoff,1);
len(3)=size(right_footstrike,1);
len(4)=size(right_footoff,1);
mlen=max(len);
% put all events array to the same length adding zeroes to the shortest ones
% add a second column with 1 for left and 2 for right side
% add a third column with type(1 strike, 0 off)
left_footstrike(:,2:3)=1;
if len(1)~=mlen
    left_footstrike(mlen,:)=nan;
end

left_footoff(:,2)=1;
left_footoff(:,3)=0;
if len(2)~=mlen
    left_footoff(mlen,:)=nan;
end

right_footstrike(:,2)=2;
right_footstrike(:,3)=1;
if len(3)~=mlen
    right_footstrike(mlen,:)=nan;
end

right_footoff(:,2)=2;
right_footoff(:,3)=0;
if len(4)~=mlen
    right_footoff(mlen,:)=nan;
end

% put Foot strike and off events in Cronological order %
%Now events are in a matrix (frame, side(1 left, 2 right), type(1 strike, 0 off)
events_order = sortrows([left_footstrike;right_footstrike;left_footoff;right_footoff]);

% put ordered foot envents into variables
ind_strike = find(events_order(:,2)==1 & events_order(:,3)==1);
left_footstrike1 = [events_order(ind_strike(1),1) ind_strike(1)];
left_footstrike2 = [events_order(ind_strike(2),1) ind_strike(2)];

ind_strike = find(events_order(:,2)==2 & events_order(:,3)==1);
right_footstrike1 = [events_order(ind_strike(1),1) ind_strike(1)];
right_footstrike2 = [events_order(ind_strike(2),1) ind_strike(2)];

ind_strike = find(events_order(:,2)==1 & events_order(:,3)==0);
ind_strike = ind_strike(find(ind_strike > left_footstrike1(2),1,'first'));
left_footoff = events_order(ind_strike,1);

ind_strike = find(events_order(:,2)==2 & events_order(:,3)==0);
ind_strike = ind_strike(find(ind_strike > right_footstrike1(2),1,'first'));
right_footoff = events_order(ind_strike,1);

footoff = [left_footoff right_footoff];
footstrike1 = [left_footstrike1(1) right_footstrike1(1)];
footstrike2 = [left_footstrike2(1) right_footstrike2(1)];
end


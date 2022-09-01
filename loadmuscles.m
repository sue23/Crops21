function [prematfilec3d]=loadmuscles(c3d)




% Muscle label: left and right side

Emg_label_right={'voltage.rrectus','voltage.rvastuslat','voltage.rmgluteus','voltage.rmedialham','voltage.rbiceps','voltage.rtibialeant','voltage.rsoleus','voltage.rmgastrocnemius'};
Emg_label_left={'voltage.lrectus','voltage.lvastuslat','voltage.lmgluteus','voltage.lmedialham','voltage.lbiceps','voltage.ltibialeant','voltage.lsoleus','voltage.lmgastrocnemius'};

labels=c3d.c3dpar.analog.labels; %  labels in c3d
index1 = find(contains(labels,'voltage.r')); 
index2=find(contains(labels,'voltage.l'));



% if ~isempty(index1)
%     labels_r=labels(index1(:,1));
% else
%     labels_r = cell(1,1);
%     for i =1:numel(labels)
%         if labels{i}(1)=='r'
%             labels_r = [labels_r; labels{i}];
%         end
%     end
%     labels_r = labels_r(2:end);
% end
% if ~isempty(index2)
%     labels_l=labels(index2(:,1));
% else
%     labels_l = cell(1,1);
%     for i =1:numel(labels)
%         if labels{i}(1)=='l'
%             labels_l = [labels_l; labels{i}];
%         end
%     end
%     labels_l = labels_l(2:end);
% end

muscle_right=c3dget(c3d,Emg_label_right); 
muscle_left=c3dget(c3d,Emg_label_left);

if isempty(muscle_right)
    keyboard
end
if isempty(muscle_left)
    keyboard
end

% Frame rate analog and point
Frame_rate_point=c3d.c3dpar.point.rate;
Frame_rate_analog=c3d.c3dpar.analog.rate;



%% Filtro il segnale e ne estraggo l'inviluppo

[prematfilec3d]=emgroutine(muscle_right,muscle_left,Frame_rate_analog);


 


end
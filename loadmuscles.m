function [prematfilec3d]=loadmuscles(c3d)




% Muscle label: left and right side

Emg_label_right={'voltage.rrectus','voltage.rvastuslat','voltage.rmgluteus','voltage.rmedialham','voltage.rbiceps','voltage.rtibialeant','voltage.rsoleus','voltage.rmgastrocnemius'};
Emg_label_left={'voltage.lrectus','voltage.lvastuslat','voltage.lmgluteus','voltage.lmedialham','voltage.lbiceps','voltage.ltibialeant','voltage.lsoleus','voltage.lmgastrocnemius'};

labels=c3d.c3dpar.analog.labels(13:28); %  labels in c3d
index1 = find(contains(labels,'voltage.r')); 
index2=find(contains(labels,'voltage.l'));



if ~isempty(index1)
    labels_r=labels(index1(:,1));
else
    labels_r = cell(1,1);
    for i =1:numel(labels)
        if labels{i}(1)=='r'
            labels_r = [labels_r; labels{i}];
        end
    end
    labels_r = labels_r(2:end);
end
if ~isempty(index2)
    labels_l=labels(index2(:,1));
else
    labels_l = cell(1,1);
    for i =1:numel(labels)
        if labels{i}(1)=='l'
            labels_l = [labels_l; labels{i}];
        end
    end
    labels_l = labels_l(2:end);
end

muscle_right=c3dget(c3d,labels_r); 
muscle_left=c3dget(c3d,labels_l);

% labels_right= erase(labels_r,"voltage.r");
% labels_right= erase(labels_right,"m");
% 
% Emg_label_r=erase(Emg_label_right,"voltage.r");
% Emg_label_r= erase(Emg_label_r,"m");

% 
% %%%%%NON CAPISCO QUESTO A CHE SERVE
% for i=1:length(Emg_label_r)
%     for j=1:length(labels_right)
%         if strdist(labels_right{j}, Emg_label_r{i})<=4
%             
%             if ismember(Emg_label_r{i},labels_right{j})
%                 muscle_r(:,i)= muscle_right(:,j);
%                 
%             end
%             
%         end
%            if isempty(labels_right{j})
%                 muscle_r(:,3)=muscle_right(:,j);
%             end
%     end
% end
% 
% 
% % a=sort(labels_r);
% % b=sort(Emg_label_right);
% % Control: difference my label - c3d labels
% for i=1:length(labels_r)
%     if strcmpi(labels_r{i},Emg_label_right{i})==0
%         labels_r{i}=Emg_label_right{i};
%     end
% end
% 
% 
% muscle_lab_right=labels_r;
% 
% 
% 
% labels_left= erase(labels_l,"voltage.l");
% labels_left= erase(labels_left,"m");
% Emg_label_l=erase(Emg_label_left,"voltage.l");
% Emg_label_l= erase(Emg_label_l,"m");
% 
% for i=1:length(Emg_label_l)
%     for j=1:length(labels_left)
%         if strdist(labels_left{j}, Emg_label_l{i})<=4
%             
%             if ismember(Emg_label_l{i},labels_left{j})
%                 muscle_l(:,i)= muscle_left(:,j);
%                 
%             end
%         end
%     end
% end
% 
% 
% 
% for i=1:length(labels_l)
%     if strcmpi(labels_l{i},Emg_label_left{i})==0
%         labels_l{i}=Emg_label_left{i};
%     end
% end
% 
% muscle_lab_left=labels_l;
% 
% 
% 
% 
% 
% 
% % Muscle matrix left and right side
% muscle_right=muscle_r;                           %c3dget(c3d,muscle_lab_right); 
% muscle_left=muscle_l;                            %c3dget(c3d,muscle_lab_left);
% 
% 
% % Delete voltage from muscle label
% r_right = erase(muscle_lab_right,"voltage.r"); %tolgo voltage
% r=string('Right ');
% right_right=append(r,r_right);
% muscle_lab_right=right_right;
% 
% l_left = erase(muscle_lab_left,"voltage.l"); %tolgo voltage
% l=string('Left ');
% left_left=append(l,l_left);
% muscle_lab_left=left_left;


% Frame rate analog and point
Frame_rate_point=c3d.c3dpar.point.rate;
Frame_rate_analog=c3d.c3dpar.analog.rate;



%% Filtro il segnale e ne estraggo l'inviluppo

[prematfilec3d]=emgroutine(muscle_right,muscle_left,Frame_rate_analog);


 


end
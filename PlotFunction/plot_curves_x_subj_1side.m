close all

Datapath = uigetdir;
ResPath = 'C:\Users\Utente\Documents\MATLAB\obesi\Last_Res\Curve\';

%% plot normality curves
load([Datapath '\GH.mat']);
mean_anglesGH = nanmean(Angles.Avg_trial_angles100,4);
std_anglesGH = nanstd(Angles.Avg_trial_angles100,0,4);
angles_name = Angles.Joint_angles_names;
moments_name = Kinetic.moments_joints_names;
power_name = Kinetic.power_joints_names;

njoint = size(mean_anglesGH,3);
%standar limits
limits(:,:,1) = [-15 15;-35 15;25 50;-16 5;-15 20;4 18;-20 50;-10 80;-30 20;-6 2;-120 0]; %sagital
limits(:,:,2) = [-7 8;-2 18;-0.1 0.1;0 18;-5 6;-10 10;-15 15;-10 25;-2 8;-5 5;-0.5 4.5]; %frontal
limits(:,:,3) = [-10 10;-35 15;-0.1 0.1;95 150;-8 8;-8 10;-20 25;-15 25;-40 20;-8 8;-12 4]; %transverse

Mlimits(:,:,1) = [-1000 1500;-600 1000;-1000 2000]; %sagital moment
Mlimits(:,:,2) = [-500 1000;-200 600;-150 150]; %frontalmoment
Mlimits(:,:,3) = [-200 200;-100 200;-100 300]; %transversemoment
Plimits = [-1 2;-1.5 1;-2 6]; %power

Pre = load([Datapath '\GO_Pre.mat']);
Post = load([Datapath '\GO_Post.mat']);
nsubj = size(Pre.Angles.Avg_trial_angles100,4);
for subj = 1:nsubj
for j = 1:njoint 
   %check for limits 
   for i=1:3
   lowlim(i) = min([limits(j,1,i) min(Pre.Angles.Avg_trial_angles100(:,i,j,subj)) min(Post.Angles.Avg_trial_angles100(:,i,j,subj))]);
   highlim(i) = max([limits(j,2,i) max(Pre.Angles.Avg_trial_angles100(:,i,j,subj)) max(Post.Angles.Avg_trial_angles100(:,i,j,subj))]);
   end
   
   h(j)=figure;
   subplot(1,3,1)
   ebpatch(1:100,mean_anglesGH(:,1,j),std_anglesGH(:,1,j),[0.8 0.8 0.8]);
   hold on
   plot(Pre.Angles.Avg_trial_angles100(:,1,j,subj),'r','linewidth',1.5)
   line([Pre.AvgData.FootOff_perc(subj) Pre.AvgData.FootOff_perc(subj)],[lowlim(1) highlim(1)],'col',[1 0 0])
   plot(Post.Angles.Avg_trial_angles100(:,1,j,subj),'g','linewidth',1.5)
   line([Post.AvgData.FootOff_perc(subj) Post.AvgData.FootOff_perc(subj)],[lowlim(1) highlim(1)],'col',[0 1 0])
   ylim([lowlim(1) highlim(1)])
    xlabel('% Gait')
   ylabel('[deg]')
   title('Sagital')
   subplot(1,3,2)
   ebpatch(1:100,mean_anglesGH(:,2,j),std_anglesGH(:,2,j),[0.8 0.8 0.8]);
   hold on
   plot(Pre.Angles.Avg_trial_angles100(:,2,j,subj),'r','linewidth',1.5)
   line([Pre.AvgData.FootOff_perc(subj) Pre.AvgData.FootOff_perc(subj)],[lowlim(2) highlim(2)],'col',[1 0 0])
   plot(Post.Angles.Avg_trial_angles100(:,2,j,subj),'g','linewidth',1.5)
   line([Post.AvgData.FootOff_perc(subj) Post.AvgData.FootOff_perc(subj)],[lowlim(2) highlim(2)],'col',[0 1 0])
   ylim([lowlim(2) highlim(2)])
    xlabel('% Gait')
%    ylabel('[deg]')
   title('Frontal')
   subplot(1,3,3)
   ebpatch(1:100,mean_anglesGH(:,3,j),std_anglesGH(:,3,j),[0.8 0.8 0.8]);
   hold on
   plot(Pre.Angles.Avg_trial_angles100(:,3,j,subj),'r','linewidth',1.5)
   line([Pre.AvgData.FootOff_perc(subj) Pre.AvgData.FootOff_perc(subj)],[lowlim(3) highlim(3)],'col',[1 0 0])
   plot(Post.Angles.Avg_trial_angles100(:,3,j,subj),'g','linewidth',1.5)
   line([Post.AvgData.FootOff_perc(subj) Post.AvgData.FootOff_perc(subj)],[lowlim(3) highlim(3)],'col',[0 1 0])
   ylim([lowlim(3) highlim(3)])
    xlabel('% Gait')
%    ylabel('[deg]')
   title('Transveral')
   suptitle(Pre.Angles.Joint_angles_names{j})
  

   saveas(gcf,[ResPath, 'subj', num2str(subj),'GO',Pre.Angles.Joint_angles_names{j},'1side'],'fig')
    saveas(gcf,[ResPath, 'subj', num2str(subj),'GO',Pre.Angles.Joint_angles_names{j},'1side'],'emf')
end



close all
end

% %%Kinetic
mean_powerGH = nanmean(Kinetic.Avg_trial_power100,4);
std_powerGH = nanstd(Kinetic.Avg_trial_power100,0,4);
mean_momentsGH = nanmean(Kinetic.Avg_trial_moments100,4);
std_momentsGH = nanstd(Kinetic.Avg_trial_moments100,0,4);

nvar = size(Pre.Kinetic.power_joints_names,2);
tmpvar = Kinetic.power_joints_names;

for subj = 1:nsubj
for j = 1:nvar 
    var = tmpvar{j}(1:end-6);
    indvar = find(~cellfun(@isempty,regexp(Angles.Joint_angles_names, var)));
   
   
   h(j)=figure;
   subplot(3,1,1)
   %check for limits
   lowlim = min([limits(indvar,1,1) min(Pre.Angles.Avg_trial_angles100(:,1,indvar,subj)) min(Post.Angles.Avg_trial_angles100(:,1,indvar,subj))]);
   highlim = max([limits(indvar,2,1) max(Pre.Angles.Avg_trial_angles100(:,1,indvar,subj)) max(Post.Angles.Avg_trial_angles100(:,1,indvar,subj))]);
   
                
   ebpatch(1:100,mean_anglesGH(:,1,indvar),std_anglesGH(:,1,indvar),[0.8 0.8 0.8]);
   hold on
   plot(Pre.Angles.Avg_trial_angles100(:,1,indvar,subj),'r','linewidth',1.5)
   line([Pre.AvgData.FootOff_perc(subj) Pre.AvgData.FootOff_perc(subj)],[lowlim highlim],'col',[1 0 0])
   plot(Post.Angles.Avg_trial_angles100(:,1,indvar,subj),'g','linewidth',1.5)
   line([Post.AvgData.FootOff_perc(subj) Post.AvgData.FootOff_perc(subj)],[lowlim highlim],'col',[0 1 0])
   ylim([lowlim highlim])
   xlabel('% Gait')
   ylabel('[deg]')
   title(angles_name{indvar})
   
   subplot(3,1,2)
   %check for limits 
   lowlim = min([Mlimits(j,1,i) min(Pre.Kinetic.Avg_trial_moments100(:,1,j,subj)) min(Post.Kinetic.Avg_trial_moments100(:,1,j,subj))].*10e-3);
   highlim = max([Mlimits(j,2,i) max(Pre.Kinetic.Avg_trial_moments100(:,1,j,subj)) max(Post.Kinetic.Avg_trial_moments100(:,1,j,subj))].*10e-3);
 
  
   ebpatch(1:100,mean_momentsGH(:,1,j).*10e-3,std_momentsGH(:,1,j).*10e-3,[0.8 0.8 0.8]);
   hold on
   plot(Pre.Kinetic.Avg_trial_moments100(:,1,j,subj).*10e-3,'r','linewidth',1.5)
   line([Pre.AvgData.FootOff_perc(subj) Pre.AvgData.FootOff_perc(subj)],[lowlim highlim],'col',[1 0 0])
   plot(Post.Kinetic.Avg_trial_moments100(:,1,j,subj).*10e-3,'g','linewidth',1.5)
   line([Post.AvgData.FootOff_perc(subj) Post.AvgData.FootOff_perc(subj)],[lowlim highlim],'col',[0 1 0])
   ylim([lowlim highlim])
   xlabel('% Gait')
   ylabel('[Nm/kg]')
   title(moments_name{j})
   
   subplot(3,1,3)
   %check for limits 
   lowlim = min([Plimits(j,1) min(Pre.Kinetic.Avg_trial_power100(:,3,j,subj)) min(Post.Kinetic.Avg_trial_power100(:,3,j,subj))]);
   highlim = max([Plimits(j,2) max(Pre.Kinetic.Avg_trial_power100(:,3,j,subj)) max(Post.Kinetic.Avg_trial_power100(:,3,j,subj))]);

   ebpatch(1:100,mean_powerGH(:,3,j),std_powerGH(:,3,j),[0.8 0.8 0.8]);
   hold on
   plot(Pre.Kinetic.Avg_trial_power100(:,3,j,subj),'r','linewidth',1.5)
   line([Pre.AvgData.FootOff_perc(subj) Pre.AvgData.FootOff_perc(subj)],[lowlim highlim],'col',[1 0 0])
   plot(Post.Kinetic.Avg_trial_power100(:,3,j,subj),'g','linewidth',1.5)
   line([Post.AvgData.FootOff_perc(subj) Post.AvgData.FootOff_perc(subj)],[lowlim highlim],'col',[0 1 0])
   ylim([lowlim highlim])
   xlabel('% Gait')
   ylabel('[W/kg]')
   title(power_name{j})
   set(gcf,'pos',[476   266   360   636])

   saveas(gcf,[ResPath, 'subj', num2str(subj),'GO',var,'Kinematic'],'fig')
   saveas(gcf,[ResPath, 'subj', num2str(subj),'GO',var,'Kinematic'],'emf')
end



close all
end
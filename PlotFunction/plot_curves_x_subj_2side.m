close all

Datapath = uigetdir;

%% plot normality curves
load([Datapath '\GH_Data.mat']);
mean_anglesGH = nanmean(Angles.Avg_trial_angles100,4);
std_anglesGH = nanstd(Angles.Avg_trial_angles100,0,4);
clear Angles

njoint = size(mean_anglesGH,3);
%standar limits
limits(:,:,1) = [-15 15;-35 15;25 50;-16 5;-15 20;4 18;-20 50;-10 80;-30 20;-6 2]; %sagital
limits(:,:,2) = [-7 8;-2 18;-0.1 0.1;0 18;-5 6;-10 10;-15 15;-10 25;-2 8;-5 5]; %frontal
limits(:,:,3) = [-10 10;-35 15;-0.1 0.1;95 150;-8 8;-8 10;-20 25;-15 25;-40 20;-8 8]; %transverse
Pre = load([Datapath '\GOPre_Data.mat']);
Post = load([Datapath '\GOPost_Data.mat']);
nsubj = size(Pre.Angles.Avg_trial_angles100,4);
for subj = 1:nsubj
k = 1;
for j = 1:2:njoint %lefts
   %check for limits 
   for i=1:3
   lowlim(i) = min([limits(k,1,i) min(Pre.Angles.Avg_trial_angles100(:,i,j,subj)) min(Post.Angles.Avg_trial_angles100(:,i,j,subj))]);
   highlim(i) = max([limits(k,2,i) max(Pre.Angles.Avg_trial_angles100(:,i,j,subj)) max(Post.Angles.Avg_trial_angles100(:,i,j,subj))]);
   end
   
   h(k)=figure;
   subplot(1,3,1)
   ebpatch(1:100,mean_anglesGH(:,1,j),std_anglesGH(:,1,j),[0.8 0.8 0.8]);
   hold on
   plot(Pre.Angles.Avg_trial_angles100(:,1,j,subj),'r','linewidth',1.5)
   plot(Post.Angles.Avg_trial_angles100(:,1,j,subj),'g','linewidth',1.5)
   ylim([lowlim(1) highlim(1)])
   title('Sagital')
   subplot(1,3,2)
   ebpatch(1:100,mean_anglesGH(:,2,j),std_anglesGH(:,2,j),[0.8 0.8 0.8]);
   hold on
   plot(Pre.Angles.Avg_trial_angles100(:,2,j,subj),'r','linewidth',1.5)
   plot(Post.Angles.Avg_trial_angles100(:,2,j,subj),'g','linewidth',1.5)
   ylim([lowlim(2) highlim(2)])
   title('Frontal')
   subplot(1,3,3)
   ebpatch(1:100,mean_anglesGH(:,3,j),std_anglesGH(:,3,j),[0.8 0.8 0.8]);
   hold on
   plot(Pre.Angles.Avg_trial_angles100(:,3,j,subj),'r','linewidth',1.5)
   plot(Post.Angles.Avg_trial_angles100(:,3,j,subj),'g','linewidth',1.5)
   ylim([lowlim(3) highlim(3)])
   title('Transveral')
   suptitle(Pre.Angles.Joint_angles_names{j})
   k = k + 1;
   print([Datapath, '\Fig\subj', num2str(subj),Pre.Angles.Joint_angles_names{j}],'-depsc')
%    saveas(gcf,[Datapath, '\Fig\subj', num2str(subj),Pre.Angles.Joint_angles_names{j}],'epsc2')
   saveas(gcf,[Datapath, '\Fig\subj', num2str(subj),Pre.Angles.Joint_angles_names{j}],'fig')
   saveas(gcf,[Datapath, '\Fig\subj', num2str(subj),Pre.Angles.Joint_angles_names{j}],'png')
end

k = 1;
for j = 2:2:njoint %right
    %check for limits 
   for i=1:3
   lowlim(i) = min([limits(k,1,i) min(Pre.Angles.Avg_trial_angles100(:,i,j,subj)) min(Post.Angles.Avg_trial_angles100(:,i,j,subj))]);
   highlim(i) = max([limits(k,2,i) max(Pre.Angles.Avg_trial_angles100(:,i,j,subj)) max(Post.Angles.Avg_trial_angles100(:,i,j,subj))]);
   end
   
   h(k+njoint/2)=figure;
   subplot(1,3,1)
   ebpatch(1:100,mean_anglesGH(:,1,j),std_anglesGH(:,1,j),[0.8 0.8 0.8]);
   hold on
   plot(Pre.Angles.Avg_trial_angles100(:,1,j,subj),'r','linewidth',1.5)
   plot(Post.Angles.Avg_trial_angles100(:,1,j,subj),'g','linewidth',1.5)
   ylim([lowlim(1) highlim(1)])
   title('Sagital')
   subplot(1,3,2)
   ebpatch(1:100,mean_anglesGH(:,2,j),std_anglesGH(:,2,j),[0.8 0.8 0.8]);
   hold on
   plot(Pre.Angles.Avg_trial_angles100(:,2,j,subj),'r','linewidth',1.5)
   plot(Post.Angles.Avg_trial_angles100(:,2,j,subj),'g','linewidth',1.5)
   ylim([lowlim(2) highlim(2)])
   title('Frontal')
   subplot(1,3,3)
   ebpatch(1:100,mean_anglesGH(:,3,j),std_anglesGH(:,3,j),[0.8 0.8 0.8]);
   hold on
   plot(Pre.Angles.Avg_trial_angles100(:,3,j,subj),'r','linewidth',1.5)
   plot(Post.Angles.Avg_trial_angles100(:,3,j,subj),'g','linewidth',1.5)
   ylim([lowlim(3) highlim(3)])
   title('Transveral')
   suptitle(Pre.Angles.Joint_angles_names{j})
   k = k + 1;
   saveas(gcf,[Datapath, '\Fig\subj', num2str(subj),Pre.Angles.Joint_angles_names{j}],'epsc2')
   saveas(gcf,[Datapath, '\Fig\subj', num2str(subj),Pre.Angles.Joint_angles_names{j}],'fig')
   saveas(gcf,[Datapath, '\Fig\subj', num2str(subj),Pre.Angles.Joint_angles_names{j}],'png')
end

close all
end
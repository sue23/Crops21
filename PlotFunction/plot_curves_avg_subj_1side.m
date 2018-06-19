close all
clear

Datapath = uigetdir;
ResPath = 'I:\Susanna\Documents\MATLAB\obesi\Res\Curve\CurveMediate\';
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
Pre = load([Datapath '\GO_Pre.mat']);
Post = load([Datapath '\GO_Post.mat']);
mean_anglesGOPre = nanmean(Pre.Angles.Avg_trial_angles100,4);
std_anglesGOPre = nanstd(Pre.Angles.Avg_trial_angles100,0,4);
mean_anglesGOPost = nanmean(Post.Angles.Avg_trial_angles100,4);
std_anglesGOPost = nanstd(Post.Angles.Avg_trial_angles100,0,4);

nsubj = size(Pre.Angles.Avg_trial_angles100,4);

for j = 1:njoint 
   %check for limits 
   for i=1:3
       lowlim(i) = min([limits(j,1,i) min([mean_anglesGOPre(:,i,j)-std_anglesGOPre(:,i,j);mean_anglesGOPre(:,i,j)+std_anglesGOPre(:,i,j)]) min([mean_anglesGOPost(:,i,j)-std_anglesGOPost(:,i,j);mean_anglesGOPost(:,i,j)+std_anglesGOPost(:,i,j)])]);
       highlim(i) = max([limits(j,2,i) max([mean_anglesGOPre(:,i,j)-std_anglesGOPre(:,i,j);mean_anglesGOPre(:,i,j)+std_anglesGOPre(:,i,j)]) max([mean_anglesGOPost(:,i,j)-std_anglesGOPost(:,i,j);mean_anglesGOPost(:,i,j)+std_anglesGOPost(:,i,j)])]);
   end
   
   h(j)=figure;
   subplot(1,3,1)
   ebpatch(1:100,mean_anglesGH(:,1,j),std_anglesGH(:,1,j),[0 0 0]);
   hold on
   ebpatch(1:100,mean_anglesGOPre(:,1,j),std_anglesGOPre(:,1,j),[1 0 0]);
   hold on
   ebpatch(1:100,mean_anglesGOPost(:,1,j),std_anglesGOPost(:,1,j),[0 1 0]);
   ylim([lowlim(1) highlim(1)])
   xlabel('% Gait')
   ylabel('[deg]')
   title('Sagital')
   subplot(1,3,2)
   ebpatch(1:100,mean_anglesGH(:,2,j),std_anglesGH(:,2,j),[0 0 0]);
   hold on
   ebpatch(1:100,mean_anglesGOPre(:,2,j),std_anglesGOPre(:,2,j),[1 0 0]);
   hold on
   ebpatch(1:100,mean_anglesGOPost(:,2,j),std_anglesGOPost(:,2,j),[0 1 0]);
   hold on
   ylim([lowlim(2) highlim(2)])
   xlabel('% Gait')
   title('Frontal')
   subplot(1,3,3)
   ebpatch(1:100,mean_anglesGH(:,3,j),std_anglesGH(:,3,j),[0 0 0]);
   hold on
   ebpatch(1:100,mean_anglesGOPre(:,3,j),std_anglesGOPre(:,3,j),[1 0 0]);
   hold on
   ebpatch(1:100,mean_anglesGOPost(:,3,j),std_anglesGOPost(:,3,j),[0 1 0]);
   hold on
   ylim([lowlim(3) highlim(3)])
   xlabel('% Gait')
   title('Transveral')
   suptitle(Pre.Angles.Joint_angles_names{j})
  
    saveas(gcf,[ResPath,Angles.Joint_angles_names{j}],'fig')
    saveas(gcf,[ResPath,Angles.Joint_angles_names{j}],'emf')
end
close all
% %%Kinetic
mean_powerGH = nanmean(Kinetic.Avg_trial_power100,4);
std_powerGH = nanstd(Kinetic.Avg_trial_power100,0,4);
mean_momentsGH = nanmean(Kinetic.Avg_trial_moments100,4);
std_momentsGH = nanstd(Kinetic.Avg_trial_moments100,0,4);

mean_powerGOPre = nanmean(Pre.Kinetic.Avg_trial_power100,4);
std_powerGOPre = nanstd(Pre.Kinetic.Avg_trial_power100,0,4);
mean_momentsGOPre = nanmean(Pre.Kinetic.Avg_trial_moments100,4);
std_momentsGOPre = nanstd(Pre.Kinetic.Avg_trial_moments100,0,4);

mean_powerGOPost = nanmean(Post.Kinetic.Avg_trial_power100,4);
std_powerGOPost = nanstd(Post.Kinetic.Avg_trial_power100,0,4);
mean_momentsGOPost = nanmean(Post.Kinetic.Avg_trial_moments100,4);
std_momentsGOPost = nanstd(Post.Kinetic.Avg_trial_moments100,0,4);

nvar = size(Pre.Kinetic.power_joints_names,2);
indtmp = find(contains(Angles.Joint_angles_names, {'Ankle','Knee','Hip'})==1);
tmpvar = Kinetic.power_joints_names;
for j = 1:nvar 
    
    var = tmpvar{j}(1:end-6);
   %check for limits 
    h(j)=figure;
    subplot(3,1,1)
    i=1; %ax 1
   lowlim = min([limits(indtmp(j),1,1) min([mean_anglesGOPre(:,1,indtmp(j))-std_anglesGOPre(:,1,indtmp(j));mean_anglesGOPre(:,1,indtmp(j))+std_anglesGOPre(:,1,indtmp(j))]) min([mean_anglesGOPost(:,1,indtmp(j))-std_anglesGOPost(:,1,indtmp(j));mean_anglesGOPost(:,1,indtmp(j))+std_anglesGOPost(:,1,indtmp(j))])]);
   highlim = max([limits(indtmp(j),2,1) max([mean_anglesGOPre(:,1,indtmp(j))-std_anglesGOPre(:,1,indtmp(j));mean_anglesGOPre(:,1,indtmp(j))+std_anglesGOPre(:,1,indtmp(j))]) max([mean_anglesGOPost(:,1,indtmp(j))-std_anglesGOPost(:,1,indtmp(j));mean_anglesGOPost(:,1,indtmp(j))+std_anglesGOPost(:,1,indtmp(j))])]);


   
   ebpatch(1:100,mean_anglesGH(:,1,indtmp(j)),std_anglesGH(:,1,indtmp(j)),[0 0 0]);
   hold on
   ebpatch(1:100,mean_anglesGOPre(:,1,indtmp(j)),std_anglesGOPre(:,1,indtmp(j)),[1 0 0]);
   hold on
   ebpatch(1:100,mean_anglesGOPost(:,1,indtmp(j)),std_anglesGOPost(:,1,indtmp(j)),[0 1 0]);
   ylim([lowlim highlim])
    xlabel('% Gait')
   ylabel('[deg]')
   title(angles_name{indtmp(j)})
   
   subplot(3,1,2) %moments
   %check for limits 
   lowlim = min([ min([mean_momentsGH(:,1,j)-std_momentsGH(:,1,j) ;mean_momentsGH(:,1,j)+std_momentsGH(:,1,j)]) min([mean_momentsGOPre(:,1,j)-std_momentsGOPre(:,1,j);mean_momentsGOPre(:,1,j)+std_momentsGOPre(:,1,j)]) min([mean_momentsGOPost(:,1,j)-std_momentsGOPost(:,1,j);mean_momentsGOPost(:,1,j)+std_momentsGOPost(:,1,j)])].*10e-3);
   highlim = max([ max([mean_momentsGH(:,1,j)-std_momentsGH(:,1,j) ;mean_momentsGH(:,1,j)+std_momentsGH(:,1,j)]) max([mean_momentsGOPre(:,1,j)-std_momentsGOPre(:,1,j);mean_momentsGOPre(:,1,j)+std_momentsGOPre(:,1,j)]) max([mean_momentsGOPost(:,1,j)-std_momentsGOPost(:,1,j);mean_momentsGOPost(:,1,j)+std_momentsGOPost(:,1,j)])].*10e-3);
   ebpatch(1:100,mean_momentsGH(:,1,j).*10e-3,std_momentsGH(:,1,j).*10e-3,[0 0 0]);
   hold on
   ebpatch(1:100,mean_momentsGOPre(:,1,j).*10e-3,std_momentsGOPre(:,1,j).*10e-3,[1 0 0]);
   hold on
   ebpatch(1:100,mean_momentsGOPost(:,1,j).*10e-3,std_momentsGOPost(:,1,j).*10e-3,[0 1 0]);
   hold on
   ylim([lowlim highlim])
   xlabel('% Gait')
   ylabel('[Nm/kg]')
   title(moments_name{j})
   
   subplot(3,1,3)
  lowlim = min([ min([mean_powerGH(:,3,j)-std_powerGH(:,3,j) ;mean_powerGH(:,3,j)+std_powerGH(:,3,j)]) min([mean_powerGOPre(:,3,j)-std_powerGOPre(:,3,j);mean_powerGOPre(:,3,j)+std_powerGOPre(:,3,j)]) min([mean_powerGOPost(:,3,j)-std_powerGOPost(:,3,j);mean_powerGOPost(:,3,j)+std_powerGOPost(:,3,j)])]);
   highlim = max([ max([mean_powerGH(:,3,j)-std_powerGH(:,3,j) ;mean_powerGH(:,3,j)+std_powerGH(:,3,j)]) max([mean_powerGOPre(:,3,j)-std_powerGOPre(:,3,j);mean_powerGOPre(:,3,j)+std_powerGOPre(:,3,j)]) max([mean_powerGOPost(:,3,j)-std_powerGOPost(:,3,j);mean_powerGOPost(:,3,j)+std_powerGOPost(:,3,j)])]);
   
   ebpatch(1:100,mean_powerGH(:,3,j),std_powerGH(:,3,j),[0 0 0]);
   hold on
   ebpatch(1:100,mean_powerGOPre(:,3,j),std_powerGOPre(:,3,j),[1 0 0]);
   hold on
   ebpatch(1:100,mean_powerGOPost(:,3,j),std_powerGOPost(:,3,j),[0 1 0]);
   hold on
   ylim([lowlim highlim])
   xlabel('% Gait')
   ylabel('[W/kg]')
   title(power_name{j})
   set(gcf,'pos',[476   166   360   636])
  
    saveas(gcf,[ResPath,'avgsubj_',var,'_Kinematic'],'emf')
   saveas(gcf,[ResPath,'avgsubj_',var,'_Kinematic'],'fig')
end



close all


for j = 1:nvar 
    
    var = tmpvar{j}(1:end-6);
   %check for limits 
    h(j)=figure;
 
    subplot(3,1,1)
%     i=1; %ax 1
%check for limits 
   lowlim = min([ min([mean_momentsGH(:,1,j)-std_momentsGH(:,1,j) ;mean_momentsGH(:,1,j)+std_momentsGH(:,1,j)]) min([mean_momentsGOPre(:,1,j)-std_momentsGOPre(:,1,j);mean_momentsGOPre(:,1,j)+std_momentsGOPre(:,1,j)]) min([mean_momentsGOPost(:,1,j)-std_momentsGOPost(:,1,j);mean_momentsGOPost(:,1,j)+std_momentsGOPost(:,1,j)])].*10e-3);
   highlim = max([ max([mean_momentsGH(:,1,j)-std_momentsGH(:,1,j) ;mean_momentsGH(:,1,j)+std_momentsGH(:,1,j)]) max([mean_momentsGOPre(:,1,j)-std_momentsGOPre(:,1,j);mean_momentsGOPre(:,1,j)+std_momentsGOPre(:,1,j)]) max([mean_momentsGOPost(:,1,j)-std_momentsGOPost(:,1,j);mean_momentsGOPost(:,1,j)+std_momentsGOPost(:,1,j)])].*10e-3);
   ebpatch(1:100,mean_momentsGH(:,1,j).*10e-3,std_momentsGH(:,1,j).*10e-3,[0 0 0]);
   hold on
   ebpatch(1:100,mean_momentsGOPre(:,1,j).*10e-3,std_momentsGOPre(:,1,j).*10e-3,[1 0 0]);
   hold on
   ebpatch(1:100,mean_momentsGOPost(:,1,j).*10e-3,std_momentsGOPost(:,1,j).*10e-3,[0 1 0]);
   hold on
   ylim([lowlim highlim])
   xlabel('% Gait')
   ylabel('[Nm/kg]')
   title([moments_name{j} 'Sagital'])
   
   subplot(3,1,2) %moments
   %check for limits 
   lowlim = min([ min([mean_momentsGH(:,2,j)-std_momentsGH(:,2,j) ;mean_momentsGH(:,2,j)+std_momentsGH(:,2,j)]) min([mean_momentsGOPre(:,2,j)-std_momentsGOPre(:,2,j);mean_momentsGOPre(:,2,j)+std_momentsGOPre(:,2,j)]) min([mean_momentsGOPost(:,2,j)-std_momentsGOPost(:,2,j);mean_momentsGOPost(:,2,j)+std_momentsGOPost(:,2,j)])].*10e-3);
   highlim = max([ max([mean_momentsGH(:,2,j)-std_momentsGH(:,2,j) ;mean_momentsGH(:,2,j)+std_momentsGH(:,2,j)]) max([mean_momentsGOPre(:,2,j)-std_momentsGOPre(:,2,j);mean_momentsGOPre(:,2,j)+std_momentsGOPre(:,2,j)]) max([mean_momentsGOPost(:,2,j)-std_momentsGOPost(:,2,j);mean_momentsGOPost(:,2,j)+std_momentsGOPost(:,2,j)])].*10e-3);
   ebpatch(1:100,mean_momentsGH(:,2,j).*10e-3,std_momentsGH(:,2,j).*10e-3,[0 0 0]);
   hold on
   ebpatch(1:100,mean_momentsGOPre(:,2,j).*10e-3,std_momentsGOPre(:,2,j).*10e-3,[1 0 0]);
   hold on
   ebpatch(1:100,mean_momentsGOPost(:,2,j).*10e-3,std_momentsGOPost(:,2,j).*10e-3,[0 1 0]);
   hold on
   ylim([lowlim highlim])
   xlabel('% Gait')
   ylabel('[Nm/kg]')
   title([moments_name{j} 'Frontal'])
   
   subplot(3,1,3)
 %check for limits 
   lowlim = min([ min([mean_momentsGH(:,3,j)-std_momentsGH(:,3,j) ;mean_momentsGH(:,3,j)+std_momentsGH(:,3,j)]) min([mean_momentsGOPre(:,3,j)-std_momentsGOPre(:,3,j);mean_momentsGOPre(:,3,j)+std_momentsGOPre(:,3,j)]) min([mean_momentsGOPost(:,3,j)-std_momentsGOPost(:,3,j);mean_momentsGOPost(:,3,j)+std_momentsGOPost(:,3,j)])].*10e-3);
   highlim = max([ max([mean_momentsGH(:,3,j)-std_momentsGH(:,3,j) ;mean_momentsGH(:,3,j)+std_momentsGH(:,3,j)]) max([mean_momentsGOPre(:,3,j)-std_momentsGOPre(:,3,j);mean_momentsGOPre(:,3,j)+std_momentsGOPre(:,3,j)]) max([mean_momentsGOPost(:,3,j)-std_momentsGOPost(:,3,j);mean_momentsGOPost(:,3,j)+std_momentsGOPost(:,3,j)])].*10e-3);
   ebpatch(1:100,mean_momentsGH(:,3,j).*10e-3,std_momentsGH(:,3,j).*10e-3,[0 0 0]);
   hold on
   ebpatch(1:100,mean_momentsGOPre(:,3,j).*10e-3,std_momentsGOPre(:,3,j).*10e-3,[1 0 0]);
   hold on
   ebpatch(1:100,mean_momentsGOPost(:,3,j).*10e-3,std_momentsGOPost(:,3,j).*10e-3,[0 1 0]);
   hold on
   ylim([lowlim highlim])
   xlabel('% Gait')
   ylabel('[Nm/kg]')
   title([moments_name{j} 'Trasversal'])
   set(gcf,'pos',[476   166   360   636])
  
  
   saveas(gcf,[ResPath,'avgsubj_',var,'_moment'],'fig')
end
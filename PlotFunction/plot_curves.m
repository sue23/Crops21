close all
clear
[FileName,PathName] = uigetfile('*.mat','Select the MATLAB data file');
ResPath = 'C:\Users\Utente\Documents\MATLAB\obesi\Last_Res\Curve';
%standar limits - ogni riga è un giunto diverso. In totale sono 11 quindi è
%perfetto per dx/sx mediati oppure solo un lato
% TODO creare limiti per quando ho entrambi lati
% {'Neck' 'Shoulder' 'Elbow' 'Wrist' 'Head' 'Pelvis' 'Hip' 'Knee' 'Ankle' 'Thorax' 'FPA'}
Alimits(:,:,1) = [-15 15;-35 15;25 50;-16 5;-15 20;4 18;-20 50;-10 80;-30 20;-6 2;-120 0]; %sagital
Alimits(:,:,2) = [-7 8;-2 18;-0.1 0.1;0 18;-5 6;-10 10;-15 15;-10 25;-2 12;-5 5;-0.5 4.5]; %frontal
Alimits(:,:,3) = [-10 10;-35 15;-0.1 0.1;95 150;-8 8;-8 10;-20 25;-15 25;-40 20;-8 8;-12 4]; %transverse

% {'Hip Moment' 'Knee Moment' 'Ankle Moment'}
Mlimits(:,:,1) = [-1000 1500;-600 1000;-1000 2000]; %sagital moment
Mlimits(:,:,2) = [-500 1000;-200 600;-150 150]; %frontalmoment
Mlimits(:,:,3) = [-200 200;-100 200;-100 300]; %transversemoment
Plimits = [-1 2;-1.5 1;-2 6]; %power
planes = {'Sagital','Frontal','Transveral'};
load([PathName FileName]);

Angles.Joint_angles_names
Kinetic.moments_joints_names
Kinetic.power_joints_names
indtmp = find(contains(Angles.Joint_angles_names, {'Ankle','Knee','Hip'})==1);

%%plot kinematic
[nc,nplane,njoint,nsubj]=size(Angles.Avg_trial_angles100);
for subj = 1:nsubj
    for j = 1:njoint
         h(j)=figure;
        %check for limits
        for i=1:nplane
            
             Alowlim(i) = min([Alimits(j,1,i) min(Angles.Avg_trial_angles100(:,i,j,subj)) ]);
             Ahighlim(i) = max([Alimits(j,2,i) max(Angles.Avg_trial_angles100(:,i,j,subj))]);
              
            if sum(j==indtmp)==0
                subplot(1,3,i)
               
                hold on
                plot(Angles.Avg_trial_angles100(:,i,j,subj),'r','linewidth',1.5)
                line([AvgData.FootOff_perc(subj) AvgData.FootOff_perc(subj)],[Alowlim(i) Ahighlim(i)],'col',[1 0 0])
                ylim([Alowlim(i) Ahighlim(i)])
                xlabel('% Gait')
                if (i==1);ylabel('[deg]');end
                title(planes{i})
            end
            if sum(j==indtmp)>0     
                subplot(2,4,i+nplane+1)%plotto i momenti
                Mlowlim(i) = min([Mlimits(find(indtmp==j),1,i) min(Kinetic.Avg_trial_moments100(:,i,find(indtmp==j),subj)) ].*10e-3);
                Mhighlim(i) = max([Mlimits(find(indtmp==j),2,i) max(Kinetic.Avg_trial_moments100(:,i,find(indtmp==j),subj))].*10e-3);
                plot(Kinetic.Avg_trial_moments100(:,i,find(indtmp==j),subj).*10e-3,'r','linewidth',1.5)
                line([AvgData.FootOff_perc(subj) AvgData.FootOff_perc(subj)],[Mlowlim(i) Mhighlim(i)],'col',[1 0 0])
                ylim([Mlowlim(i) Mhighlim(i)])
                xlabel('% Gait')
                if (i==1);ylabel('[Nm/kg]');end
                
                
                
                subplot(2,4,i)
                plot(Angles.Avg_trial_angles100(:,i,j,subj),'r','linewidth',1.5)
                line([AvgData.FootOff_perc(subj) AvgData.FootOff_perc(subj)],[Alowlim(i) Ahighlim(i)],'col',[1 0 0])
                ylim([Alowlim(i) Ahighlim(i)])
                xlabel('% Gait')
                if (i==1);ylabel('[deg]');end
                title(planes{i})
            end
            
            
        end
        if sum(j==indtmp)>0
            subplot(2,4,8) %plot potenza
            Plowlim(i) = min([Plimits(find(indtmp==j),1) min(Kinetic.Avg_trial_power100(:,3,find(indtmp==j),subj)) ]);
            Phighlim(i) = max([Plimits(find(indtmp==j),2) max(Kinetic.Avg_trial_power100(:,3,find(indtmp==j),subj))]);
            plot(Kinetic.Avg_trial_power100(:,3,find(indtmp==j),subj),'r','linewidth',1.5)
            line([AvgData.FootOff_perc(subj) AvgData.FootOff_perc(subj)],[Plowlim(i) Phighlim(i)],'col',[1 0 0])
            ylim([Plowlim(i) Phighlim(i)])
            xlabel('% Gait')
            ylabel('[W/kg]')
        end
        suptitle(Angles.Joint_angles_names{j})
            
            %    print([Datapath, '\Fig\subj', num2str(subj),Pre.Angles.Joint_angles_names{j}],'-depsc')
            %    saveas(gcf,[Datapath, '\Fig\subj', num2str(subj),Pre.Angles.Joint_angles_names{j}],'epsc2')
            saveas(gcf,[ResPath, '\subj', num2str(subj),FileName(1:end-4),Angles.Joint_angles_names{j}],'fig')
%             saveas(gcf,[ResPath, '\subj', num2str(subj),FileName(1:end-4),Angles.Joint_angles_names{j}],'png')
    end
close all
end



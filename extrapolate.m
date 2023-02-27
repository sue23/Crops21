function [ Dyl, Dyr,l_hs,r_hs,l_fo,r_fo]=extrapolate(markers)
        %ylasi-ylank
        Dyl = markers(:,5) - markers(:,2);
        % strikel = events_matrix(sum(events_matrix(:,2:3),2)==2,1);
        
        Dyr = markers(:,11) - markers(:,8);
        % striker = events_matrix(sum(events_matrix(:,2:3),2)==3,1);

        fillNaN_L=1:size(Dyl,1);
        Dyl(isnan(Dyl)) = interp1(fillNaN_L(~isnan(Dyl)),Dyl(~isnan(Dyl)),fillNaN_L(isnan(Dyl))) ;
        fillNaN_R=1:size(Dyr,1);
        Dyr(isnan(Dyr)) = interp1(fillNaN_R(~isnan(Dyr)),Dyr(~isnan(Dyr)),fillNaN_R(isnan(Dyr))) ;
      
        delta = markers(end,2)-markers(1,2);  %%orientazione gait: Yank(1)-Yank(end)  
        if delta>0     %%decrescente
        [~,l_hs]=findpeaks(-Dyl);
        [~,r_hs]=findpeaks(-Dyr);
        [~,l_fo]=findpeaks(Dyl);
        [~,r_fo]=findpeaks(Dyr);
        else 
        [~,l_hs]=findpeaks(Dyl);
        [~,r_hs]=findpeaks(Dyr);
        [~,l_fo]=findpeaks(-Dyl);
        [~,r_fo]=findpeaks(-Dyr);
        end



%         
% %         if size(l_hs,1)~=size(r_hs,1)
% %              [v,ind]= min([size(l_hs,1),size(r_hs,1)]);
% %              if ind==1
% %                  r_hs=r_hs(1:v,:);
% %              else
% %                  l_hs=l_hs(1:v,:);
% %              end
% %         end
% %              
%                
%          if size(l_fo,1)~=size(r_fo,1)
%              [v,ind]= min([size(l_fo,1),size(r_fo,1)]);
%              if ind==1
%                  r_fo=r_fo(1:v,:);
%              else
%                  l_fo=l_fo(1:v,:);
%              end
%         end
%         
%            for i=1:size(l_hs,1)-1
%             footstrike1(i,1)=l_hs(i);
%             footstrike2(i,1)=l_hs(i+1);
%            end
%             for i=1:size(r_hs,1)-1
%             footstrike1(i,2)=r_hs(i);
%             footstrike2(i,2)=r_hs(i+1);
%            end
%            
%            
%            
% 
%          foot_off=[l_fo,r_fo];
         if l_fo(1)<l_hs(1)
             l_fo(1)=[];
         end
         if l_fo(end)>l_hs(end)
             l_fo(end)=[];
         end
         
           if r_fo(1)<r_hs(1)
             r_fo(1)=[];
         end
         if r_fo(end)>r_hs(end)
             r_fo(end)=[];
         end
         
%          figure
%         subplot(1,2,1)
%         sample=1:1:size(Dyl,1);
%          plot(sample,Dyl)
%          hold on
%           for i=1:size(l_hs,1)
%              
%              plot(sample(l_hs(i)),Dyl(l_hs(i)),'dr')
%              
%          end
%          for j=1:size(l_fo,1)
%              plot(sample(l_fo(j)),Dyl(l_fo(j)),'*r')
%          end
%          
%          subplot(1,2,2)
%         sample=1:1:size(Dyr,1);
%          plot(sample,Dyr)
%          hold on
%           for i=1:size(r_hs,1)
%              
%              plot(sample(r_hs(i)),Dyr(r_hs(i)),'dr')
%              
%          end
%          for j=1:size(r_fo,1)
%              plot(sample(r_fo(j)),Dyr(r_fo(j)),'*r')
%          end
               
        
        
end
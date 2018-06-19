function [ AvgData, Angles, Kinetic ] = Get_Data_for_table( Data, SpatialData, AnglesUL_label, AnglesLL_label, Angles_ul_100, Angles_ll_100, subj, ntrial, nside, answer, side )
 global AvgData

%sinistro e destro separati

if nside == 2
    
    Angles.Joint_angles_names = {'lneckangles','rneckangles','lshoulderangles',...
        'rshoulderangles','lelbowangles','relbowangles',...
        'lwristangles','rwristangles','lheadangles','rheadangles',...
        'lpelvisangles', 'rpelvisangles', 'lhipangles', 'rhipangles',...
        'lkneeangles', 'rkneeangles', 'lankleangles',...
        'rankleangles', 'lthoraxangles', 'rthoraxangles'...
        'lfootprogressangles','rfootprogressangles'};
   
    AvgData.FootOff_perc.l(subj) = nanmean(SpatialData.FootOff_perc(:,1));
    AvgData.FootOff_perc.r(subj) = nanmean(SpatialData.FootOff_perc(:,2));
    
    AvgData.StrideVelocity.l(subj) = nanmean(SpatialData.StrideVelocity(:,1));
    AvgData.StrideVelocity.r(subj) = nanmean(SpatialData.StrideVelocity(:,2));
    
    AvgData.StrideLength.l(subj) = nanmean(SpatialData.StrideLength(:,1));
    AvgData.StrideLength.r(subj) = nanmean(SpatialData.StrideLength(:,2));
    
    AvgData.StrideTime.l(subj) = nanmean(SpatialData.StrideTime(:,1));
    AvgData.StrideTime.r(subj) = nanmean(SpatialData.StrideTime(:,2));
    
    AvgData.StrideWidth.l(subj) = nanmean(SpatialData.StrideWidth(:,1));
    AvgData.StrideWidth.r(subj) = nanmean(SpatialData.StrideWidth(:,2));
    
    AvgData.StepLength.l(subj) = nanmean(SpatialData.StepLength(:,1));
    AvgData.StepLength.r(subj) = nanmean(SpatialData.StepLength(:,2));
    
    AvgData.StanceTime.l(subj) = nanmean(SpatialData.StanceTime(:,1));
    AvgData.StanceTime.r(subj) = nanmean(SpatialData.StanceTime(:,2));
    
    AvgData.SwingTime.l(subj) = nanmean(SpatialData.SwingTime(:,1));
    AvgData.SwingTime.r(subj) = nanmean(SpatialData.SwingTime(:,2));
    
    AvgData.Double_support.Pre(subj) = nanmean(SpatialData.Double_support(:,1));
    AvgData.Double_support.Terminal(subj) = nanmean(SpatialData.Double_support(:,2));
    
    for joint = fieldnames(Data)'
        for par = fieldnames(Data.(joint{1}))'
            if strcmp((par{1}),'Tilt') | strcmp((par{1}),'FlexExt')
                ax=1;
            elseif strcmp((par{1}),'Obl') | strcmp((par{1}),'AbdAdd')
                ax=2;
            else
                ax=3;
            end
            if isstruct(Data.(joint{1}).(par{1}))
                for subpar = fieldnames(Data.(joint{1}).(par{1}))'
                    if strcmp(subpar{1},'Means')
                        if sum(~cellfun(@isempty,regexp(AnglesUL_label, lower((joint{1})))))>0 | ~isempty(Angles_ul_100)%sum(contains(AnglesUL_label, lower((joint{1}))))>0
                            
                            AvgData.(joint{1}).(par{1}).(subpar{1}).l(subj) = nanmean(reshape(Angles_ul_100(:,ax,find(~cellfun(@isempty,regexp(AnglesUL_label,['l',lower((joint{1}))]))),:),100*ntrial,1));
                            AvgData.(joint{1}).(par{1}).(subpar{1}).r(subj) = nanmean(reshape(Angles_ul_100(:,ax,find(~cellfun(@isempty,regexp(AnglesUL_label,['r',lower((joint{1}))]))),:),100*ntrial,1));
                        else
                            AvgData.(joint{1}).(par{1}).(subpar{1}).l(subj) = nanmean(reshape(Angles_ll_100(:,ax,find(~cellfun(@isempty,regexp(AnglesLL_label,['l',lower((joint{1}))]))),:),100*ntrial,1));
                            AvgData.(joint{1}).(par{1}).(subpar{1}).r(subj) = nanmean(reshape(Angles_ll_100(:,ax,find(~cellfun(@isempty,regexp(AnglesLL_label,['r',lower((joint{1}))]))),:),100*ntrial,1));
                        end
                    else
                        AvgData.(joint{1}).(par{1}).(subpar{1}).l(subj) = nanmean(Data.(joint{1}).(par{1}).(subpar{1})(:,1));
                        AvgData.(joint{1}).(par{1}).(subpar{1}).r(subj) = nanmean(Data.(joint{1}).(par{1}).(subpar{1})(:,2));
                    end
                end
            else
                AvgData.(joint{1}).(par{1}).l(subj) = nanmean(Data.(joint{1}).(par{1})(:,1));
                AvgData.(joint{1}).(par{1}).r(subj) = nanmean(Data.(joint{1}).(par{1})(:,2));
            end
        end
    end
    
    
else
    
    %salvo una sola linea
    Angles.Joint_angles_names = {'Neck','Shoulder','Elbow',...
        'Wrist','Head','Pelvis','Hip','Knee',...
        'Ankle', 'Thorax','FPA'};
 
    if strcmp(answer,'2')
        %salvo dati destra e sinistra mediati
        
        AvgData.FootOff_perc(subj) = nanmean(SpatialData.FootOff_perc(:));
        AvgData.StrideVelocity(subj) = nanmean(SpatialData.StrideVelocity(:));
        AvgData.StrideLength(subj) = nanmean(SpatialData.StrideLength(:));
        AvgData.StrideTime(subj) = nanmean(SpatialData.StrideTime(:));
        AvgData.StrideWidth(subj) = nanmean(SpatialData.StrideWidth(:));
        AvgData.StepLength(subj) = nanmean(SpatialData.StepLength(:));
        AvgData.StanceTime(subj) = nanmean(SpatialData.StanceTime(:));
        AvgData.SwingTime(subj) = nanmean(SpatialData.SwingTime(:));
        AvgData.Double_support.Pre(subj) = nanmean(SpatialData.Double_support(:,1));
        AvgData.Double_support.Terminal(subj) = nanmean(SpatialData.Double_support(:,2));
    
    else
        %salvo solo un lato
        if strcmp(side,'1')
            AvgData.FootOff_perc.l(subj) = nanmean(SpatialData.FootOff_perc(:,1));
            AvgData.StrideVelocity.l(subj) = nanmean(SpatialData.StrideVelocity(:,1));
            AvgData.StrideLength.l(subj) = nanmean(SpatialData.StrideLength(:,1));
            AvgData.StrideTime.l(subj) = nanmean(SpatialData.StrideTime(:,1));
            AvgData.StrideWidth.l(subj) = nanmean(SpatialData.StrideWidth(:,1));
            AvgData.StepLength.l(subj) = nanmean(SpatialData.StepLength(:,1));
            AvgData.StanceTime.l(subj) = nanmean(SpatialData.StanceTime(:,1));
            AvgData.SwingTime.l(subj) = nanmean(SpatialData.SwingTime(:,1));
            AvgData.Double_support.Pre(subj) = nanmean(SpatialData.Double_support(:,1));
            AvgData.Double_support.Terminal(subj) = nanmean(SpatialData.Double_support(:,2));
        else
            AvgData.FootOff_perc.r(subj) = nanmean(SpatialData.FootOff_perc(:,2));
            AvgData.StrideVelocity.r(subj) = nanmean(SpatialData.StrideVelocity(:,2));
            AvgData.StrideLength.r(subj) = nanmean(SpatialData.StrideLength(:,2));
            AvgData.StrideTime.r(subj) = nanmean(SpatialData.StrideTime(:,2));
            AvgData.StrideWidth.r(subj) = nanmean(SpatialData.StrideWidth(:,2));
            AvgData.StepLength.r(subj) = nanmean(SpatialData.StepLength(:,2));
            AvgData.StanceTime.r(subj) = nanmean(SpatialData.StanceTime(:,2));
            AvgData.SwingTime.r(subj) = nanmean(SpatialData.SwingTime(:,2));
            AvgData.Double_support.Pre(subj) = nanmean(SpatialData.Double_support(:,1));
            AvgData.Double_support.Terminal(subj) = nanmean(SpatialData.Double_support(:,2));
        end
    end
    
    for joint = fieldnames(Data)'
        for par = fieldnames(Data.(joint{1}))'
            if strcmp((par{1}),'Tilt') | strcmp((par{1}),'FlexExt')
                ax=1;
            elseif strcmp((par{1}),'Obl') | strcmp((par{1}),'AbdAdd')
                ax=2;
            else
                ax=3;
            end
            if isstruct(Data.(joint{1}).(par{1}))
                for subpar = fieldnames(Data.(joint{1}).(par{1}))'
                    if strcmp(subpar{1},'Means')
                        if sum(~cellfun(@isempty,regexp(AnglesUL_label, lower((joint{1})))))>0 | ~isempty(Angles_ul_100)%sum(contains(AnglesUL_label, lower((joint{1}))))>0
                            if strcmp(answer,'2')
                                AvgData.(joint{1}).(par{1}).(subpar{1}).l(subj) = nanmean([reshape(Angles_ul_100(:,ax,find(~cellfun(@isempty,regexp(AnglesUL_label,['l',lower((joint{1}))]))),:),100*ntrial,1);...
                                    reshape(Angles_ul_100(:,ax,find(~cellfun(@isempty,regexp(AnglesUL_label,['r',lower((joint{1}))]))),:),100*ntrial,1)]);
                            else
                                if strcmp(side,'1')
                                    AvgData.(joint{1}).(par{1}).(subpar{1}).l(subj) = nanmean(reshape(Angles_ul_100(:,ax,find(~cellfun(@isempty,regexp(AnglesUL_label,['l',lower((joint{1}))]))),:),100*ntrial,1));
                                else
                                    AvgData.(joint{1}).(par{1}).(subpar{1}).r(subj) = nanmean(reshape(Angles_ul_100(:,ax,find(~cellfun(@isempty,regexp(AnglesUL_label,['r',lower((joint{1}))]))),:),100*ntrial,1));
                                end
                            end
                        else
                            if strcmp(answer,'2')
                                AvgData.(joint{1}).(par{1}).(subpar{1}).l(subj) = nanmean([reshape(Angles_ll_100(:,ax,find(~cellfun(@isempty,regexp(AnglesLL_label,['l',lower((joint{1}))]))),:),100*ntrial,1);...
                                    reshape(Angles_ll_100(:,ax,find(~cellfun(@isempty,regexp(AnglesLL_label,['r',lower((joint{1}))]))),:),100*ntrial,1)]);
                            else
                                if strcmp(side,'1')
                                    AvgData.(joint{1}).(par{1}).(subpar{1}).l(subj) = nanmean(reshape(Angles_ll_100(:,ax,find(~cellfun(@isempty,regexp(AnglesLL_label,['l',lower((joint{1}))]))),:),100*ntrial,1));
                                else
                                    AvgData.(joint{1}).(par{1}).(subpar{1}).r(subj) = nanmean(reshape(Angles_ll_100(:,ax,find(~cellfun(@isempty,regexp(AnglesLL_label,['r',lower((joint{1}))]))),:),100*ntrial,1));
                                end
                            end
                        end
                    else
                        if strcmp(answer,'2')
                            AvgData.(joint{1}).(par{1}).(subpar{1})(subj) = nanmean(Data.(joint{1}).(par{1}).(subpar{1})(:));
                        else
                            if strcmp(side,'1')
                                AvgData.(joint{1}).(par{1}).(subpar{1}).l(subj) = nanmean(Data.(joint{1}).(par{1}).(subpar{1})(:,1));
                            else
                                AvgData.(joint{1}).(par{1}).(subpar{1}).r(subj) = nanmean(Data.(joint{1}).(par{1}).(subpar{1})(:,2));
                            end
                        end
                    end
                end
            else
                if strcmp(answer,'2')
                    AvgData.(joint{1}).(par{1})(subj) = nanmean(Data.(joint{1}).(par{1})(:));
                else
                    if strcmp(side,'1')
                        AvgData.(joint{1}).(par{1}).l(subj) = nanmean(Data.(joint{1}).(par{1})(:,1));
                    else
                        AvgData.(joint{1}).(par{1}).r(subj) = nanmean(Data.(joint{1}).(par{1})(:,2));
                    end
                end
            end
        end
    end
  
  
end



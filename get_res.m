function [output_res] = get_res(dataL,dataR)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

joints = {'Head','Neck','Shoulder','Wrist','Thorax','Pelvis'};
particular_joints = {'Elbow','footprogress','Hip','Knee','Ankle'};
planes={'Tilt','Obl','Rot'}
indicators = {'Mean','Range','IC'};

%initialize vectors
for j=1:length(joints)
    for p=1:length(planes)
        for i=1:length(indicators)
            eval(['loutput_res.',joints{j},'.',planes{p},'.',indicators{i},'=[];'])
            eval(['routput_res.',joints{j},'.',planes{p},'.',indicators{i},'=[];'])
        end
    end
end



for j=1:length(joints)
    for p=1:length(planes)
        for i=1:length(indicators)
            for d=1:length(dataL)
                eval(['loutput_res.',joints{j},'.',planes{p},'.',indicators{i},'=[','loutput_res.',joints{j},'.',planes{p},'.',indicators{i},...
                    ',','dataL{',num2str(d),'}.',joints{j},'.',indicators{i},'(',num2str(p),',:)];'])
            end
            
            for d=1:length(dataR)
                eval(['routput_res.',joints{j},'.',planes{p},'.',indicators{i},'=[','routput_res.',joints{j},'.',planes{p},'.',indicators{i},...
                    ',','dataR{',num2str(d),'}.',joints{j},'.',indicators{i},'(',num2str(p),',:)];'])
            end
        end
    end
end


for j=1:length(joints)
    for p=1:length(planes)
        for i=1:length(indicators)
            eval(['output_res.',joints{j},'.',planes{p},'.',indicators{i},'=[',...
                'loutput_res.',joints{j},'.',planes{p},'.',indicators{i},''',','routput_res.',joints{j},'.',planes{p},'.',indicators{i},'''' ,'];'])
            
        end
    end
end

%% Elbow
%initialize elbow vectors
for p=1
    for i=1:length(indicators)
        eval(['loutput_res.Elbow.',planes{p},'.',indicators{i},'=[];'])
        eval(['routput_res.Elbow.',planes{p},'.',indicators{i},'=[];'])
    end
end



for p=1
    for i=1:length(indicators)
        for d=1:length(dataL)
            eval(['loutput_res.Elbow.',planes{p},'.',indicators{i},'=[','loutput_res.Elbow.',planes{p},'.',indicators{i},...
                ',','dataL{',num2str(d),'}.Elbow.',indicators{i},'(',num2str(p),',:)];'])
        end
        
        for d=1:length(dataR)
            eval(['routput_res.Elbow.',planes{p},'.',indicators{i},'=[','routput_res.Elbow.',planes{p},'.',indicators{i},...
                ',','dataR{',num2str(d),'}.Elbow.',indicators{i},'(',num2str(p),',:)];'])
        end
    end
end

for p=1
    for i=1:length(indicators)
        eval(['output_res.Elbow.',planes{p},'.',indicators{i},'=[',...
            'loutput_res.Elbow.',planes{p},'.',indicators{i},''',','routput_res.Elbow.',planes{p},'.',indicators{i},'''' ,'];'])
        
    end
end

%% FPA
indicators = {'Mean','Range','IC','RotMax','RotMaxPerc','RotMin','RotMinPerc'};
for p=3
    for i=1:length(indicators)
        eval(['loutput_res.footprogress.',planes{p},'.',indicators{i},'=[];'])
        eval(['routput_res.footprogress.',planes{p},'.',indicators{i},'=[];'])
    end
end

for p=3
    for i=1:length(indicators)
        for d=1:length(dataL)
            eval(['loutput_res.footprogress.',planes{p},'.',indicators{i},'=[','loutput_res.footprogress.',planes{p},'.',indicators{i},...
                ',','dataL{',num2str(d),'}.footprogress.',indicators{i},'(',num2str(1),',:)];'])
        end
        
        for d=1:length(dataR)
            eval(['routput_res.footprogress.',planes{p},'.',indicators{i},'=[','routput_res.footprogress.',planes{p},'.',indicators{i},...
                ',','dataR{',num2str(d),'}.footprogress.',indicators{i},'(',num2str(1),',:)];'])
        end
    end
end

for p=3
    for i=1:length(indicators)
        eval(['output_res.footprogress.',planes{p},'.',indicators{i},'=[',...
            'loutput_res.footprogress.',planes{p},'.',indicators{i},''',','routput_res.footprogress.',planes{p},'.',indicators{i},'''' ,'];'])
        
    end
end

%% Hip
indicators = {'Mean','Range','IC','FlexMax','FlexMaxPerc','ExtMax','ExtMaxPerc','AddMax','AddMaxPerc','AbdMax','AbdMaxPerc',...
    'Extmoment','ExtMomperc','flexmoment','flexMomperc','Addmoment','AddMomperc','GenPowerStance','GenPowerStanceperc','AbsPowerStance',...
    'AbsPowerStanceperc','GenPowerSwing','GenPowerSwingperc'};
for p=1:2
    for i=1:length(indicators)
        if i<4
            eval(['loutput_res.Hip.',planes{p},'.',indicators{i},'=[];'])
            eval(['routput_res.Hip.',planes{p},'.',indicators{i},'=[];'])
        end
        if i>3 & p==1
            eval(['loutput_res.Hip.',planes{p},'.',indicators{i},'=[];'])
            eval(['routput_res.Hip.',planes{p},'.',indicators{i},'=[];'])
        end
    end
end

for p=1:2
    for i=1:length(indicators)
        for d=1:length(dataL)
            if i<4
                eval(['loutput_res.Hip.',planes{p},'.',indicators{i},'=[','loutput_res.Hip.',planes{p},'.',indicators{i},...
                    ',','dataL{',num2str(d),'}.Hip.',indicators{i},'(',num2str(p),',:)];'])
            end
            if i>3 & p==1
                eval(['loutput_res.Hip.',planes{p},'.',indicators{i},'=[','loutput_res.Hip.',planes{p},'.',indicators{i},...
                    ',','dataL{',num2str(d),'}.Hip.',indicators{i},'(',num2str(1),',:)];'])
            end
        end
        
        for d=1:length(dataR)
            if i<4
                eval(['routput_res.Hip.',planes{p},'.',indicators{i},'=[','routput_res.Hip.',planes{p},'.',indicators{i},...
                    ',','dataR{',num2str(d),'}.Hip.',indicators{i},'(',num2str(p),',:)];'])
            end
            if i>3 & p==1
                eval(['routput_res.Hip.',planes{p},'.',indicators{i},'=[','routput_res.Hip.',planes{p},'.',indicators{i},...
                    ',','dataR{',num2str(d),'}.Hip.',indicators{i},'(',num2str(1),',:)];'])
            end
        end
    end
end

for p=1:2
    for i=1:length(indicators)
        if i<4
            eval(['output_res.Hip.',planes{p},'.',indicators{i},'=[',...
                'loutput_res.Hip.',planes{p},'.',indicators{i},''',','routput_res.Hip.',planes{p},'.',indicators{i},'''' ,'];'])
        end
        if i>3 & p==1
            eval(['output_res.Hip.',planes{p},'.',indicators{i},'=[',...
                'loutput_res.Hip.',planes{p},'.',indicators{i},''',','routput_res.Hip.',planes{p},'.',indicators{i},'''' ,'];'])
        end
    end
end

%% Knee
indicators = {'Mean','Range','IC','FlexMaxStance','FlexMaxStancePerc','FlexMaxSwing','FlexMaxSwingPerc','ExtMaxStance','ExtMaxStancePerc',...
    'Extmoment','ExtMomperc','Flexmoment','FlexMomperc','GenPowerStance','GenPowerStanceperc','AbsPowerStance','AbsPowerStanceperc','GenPowerSwing','GenPowerSwingperc'};
%initialize  vectors
for p=1
    for i=1:length(indicators)
        eval(['loutput_res.Knee.',planes{p},'.',indicators{i},'=[];'])
        eval(['routput_res.Knee.',planes{p},'.',indicators{i},'=[];'])
    end
end



for p=1
    for i=1:length(indicators)
        for d=1:length(dataL)
            eval(['loutput_res.Knee.',planes{p},'.',indicators{i},'=[','loutput_res.Knee.',planes{p},'.',indicators{i},...
                ',','dataL{',num2str(d),'}.Knee.',indicators{i},'(',num2str(p),',:)];'])
        end
        
        for d=1:length(dataR)
            eval(['routput_res.Knee.',planes{p},'.',indicators{i},'=[','routput_res.Knee.',planes{p},'.',indicators{i},...
                ',','dataR{',num2str(d),'}.Knee.',indicators{i},'(',num2str(p),',:)];'])
        end
    end
end

for p=1
    for i=1:length(indicators)
        eval(['output_res.Knee.',planes{p},'.',indicators{i},'=[',...
            'loutput_res.Knee.',planes{p},'.',indicators{i},''',','routput_res.Knee.',planes{p},'.',indicators{i},'''' ,'];'])
        
    end
end

%% Ankle
indicators = {'Mean','Range','IC','DorsalFlexMaxStance','DorsalFlexMaxStancePerc','DorsalFlexMaxSwing','DorsalFlexMaxSwingPerc','PlantarFlexMax','PlantarFlexMaxPerc',...
    'Plantarmoment','PlantarMomperc','dorsalmoment','dorsalMomperc','GenPower','GenPowerperc','AbsPower','AbsPowerperc'};
%initialize  vectors
for p=1
    for i=1:length(indicators)
        eval(['loutput_res.Ankle.',planes{p},'.',indicators{i},'=[];'])
        eval(['routput_res.Ankle.',planes{p},'.',indicators{i},'=[];'])
    end
end



for p=1
    for i=1:length(indicators)
        for d=1:length(dataL)
            eval(['loutput_res.Ankle.',planes{p},'.',indicators{i},'=[','loutput_res.Ankle.',planes{p},'.',indicators{i},...
                ',','dataL{',num2str(d),'}.Ankle.',indicators{i},'(',num2str(p),',:)];'])
        end
        
        for d=1:length(dataR)
            eval(['routput_res.Ankle.',planes{p},'.',indicators{i},'=[','routput_res.Ankle.',planes{p},'.',indicators{i},...
                ',','dataR{',num2str(d),'}.Ankle.',indicators{i},'(',num2str(p),',:)];'])
        end
    end
end

for p=1
    for i=1:length(indicators)
        eval(['output_res.Ankle.',planes{p},'.',indicators{i},'=[',...
            'loutput_res.Ankle.',planes{p},'.',indicators{i},''',','routput_res.Ankle.',planes{p},'.',indicators{i},'''' ,'];'])
        
    end
end

end


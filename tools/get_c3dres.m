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
            if isfield(dataL,joints{j})
            eval(['loutput_res.',joints{j},'.',planes{p},'.',indicators{i},'=[','loutput_res.',joints{j},'.',planes{p},'.',indicators{i},...
                ',','dataL','.',joints{j},'.',indicators{i},'(',num2str(p),',:)];'])
            end


            if isfield(dataR,joints{j})
            eval(['routput_res.',joints{j},'.',planes{p},'.',indicators{i},'=[','routput_res.',joints{j},'.',planes{p},'.',indicators{i},...
                ',','dataR','.',joints{j},'.',indicators{i},'(',num2str(p),',:)];'])
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
        if isfield(dataL,'Elbow')
        eval(['loutput_res.Elbow.',planes{p},'.',indicators{i},'=[','loutput_res.Elbow.',planes{p},'.',indicators{i},...
            ',','dataL','.Elbow.',indicators{i},'(',num2str(p),',:)];'])

        end
        if isfield(dataR,'Elbow')
        eval(['routput_res.Elbow.',planes{p},'.',indicators{i},'=[','routput_res.Elbow.',planes{p},'.',indicators{i},...
            ',','dataR','.Elbow.',indicators{i},'(',num2str(p),',:)];'])
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

        eval(['loutput_res.footprogress.',planes{p},'.',indicators{i},'=[','loutput_res.footprogress.',planes{p},'.',indicators{i},...
            ',','dataL','.footprogress.',indicators{i},'(',num2str(1),',:)];'])



        eval(['routput_res.footprogress.',planes{p},'.',indicators{i},'=[','routput_res.footprogress.',planes{p},'.',indicators{i},...
            ',','dataR','.footprogress.',indicators{i},'(',num2str(1),',:)];'])

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

        if isfield(dataL.Hip,indicators{i})
            if i<4
                eval(['loutput_res.Hip.',planes{p},'.',indicators{i},'=[','loutput_res.Hip.',planes{p},'.',indicators{i},...
                    ',','dataL','.Hip.',indicators{i},'(',num2str(p),',:)];'])
            end
            if i>3 & p==1
                eval(['loutput_res.Hip.',planes{p},'.',indicators{i},'=[','loutput_res.Hip.',planes{p},'.',indicators{i},...
                    ',','dataL','.Hip.',indicators{i},'(',num2str(1),',:)];'])
            end

        end

        if isfield(dataR.Hip,indicators{i})
            if i<4
                eval(['routput_res.Hip.',planes{p},'.',indicators{i},'=[','routput_res.Hip.',planes{p},'.',indicators{i},...
                    ',','dataR','.Hip.',indicators{i},'(',num2str(p),',:)];'])
            end
            if i>3 & p==1
                eval(['routput_res.Hip.',planes{p},'.',indicators{i},'=[','routput_res.Hip.',planes{p},'.',indicators{i},...
                    ',','dataR','.Hip.',indicators{i},'(',num2str(1),',:)];'])
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
        if isfield(dataL.Knee,indicators{i})
            eval(['loutput_res.Knee.',planes{p},'.',indicators{i},'=[','loutput_res.Knee.',planes{p},'.',indicators{i},...
                ',','dataL','.Knee.',indicators{i},'(',num2str(p),',:)];'])

        end
        if isfield(dataR.Knee,indicators{i})

            eval(['routput_res.Knee.',planes{p},'.',indicators{i},'=[','routput_res.Knee.',planes{p},'.',indicators{i},...
                ',','dataR','.Knee.',indicators{i},'(',num2str(p),',:)];'])
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
        if isfield(dataL.Ankle,indicators{i})
            eval(['loutput_res.Ankle.',planes{p},'.',indicators{i},'=[','loutput_res.Ankle.',planes{p},'.',indicators{i},...
                ',','dataL','.Ankle.',indicators{i},'(',num2str(p),',:)];'])
        end
        if isfield(dataR.Ankle,indicators{i})
            eval(['routput_res.Ankle.',planes{p},'.',indicators{i},'=[','routput_res.Ankle.',planes{p},'.',indicators{i},...
                ',','dataR','.Ankle.',indicators{i},'(',num2str(p),',:)];'])
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


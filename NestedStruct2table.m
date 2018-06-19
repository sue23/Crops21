% NestedStruct2table by Gero Nootz 
% V1.0 06/22/2015 
%
% Uses the recursive function 'StepThroughCluster()' to extract data form 
% a nested table. The data is then converted to a table by the function
% 'convertCellsToTable()'. Allowed data fields are 'char' strings, one
% dimensional ‘double’ arrays and one dimensional ‘cell’ arrays of any size.
% The table can then be exported to a text file by using writetable(). 
%
% Iinputs for  Table = NestedStruct2table(cluster):
% ==================================
% A single Cluster 
%
% Autputs for  Table = NestedStruct2table(cluster):
% ==================================
% A single Table
% 
% Example:
% DataCluster.Date = '01/01/2015';
% DataCluster.Experiment1.Name = {'Experiment1'};
% DataCluster.Experiment1.Temperature = 100;
% DataCluster.Experiment1.x = 1:5;
% DataCluster.Experiment1.y = pi * DataCluster.Experiment1.x.^2;
% DataCluster.Experiment1.Comments  = [{''}, {'don''t trust'},{'too high'}];
% DataCluster.Experiment3.x = 1:7';
% DataCluster.Experiment3.y = 2*DataCluster.Experiment3.x;
% DataCluster.Experiment3.Comments  = 'Sensor to hot';
% DataCluster.Experiment3.Comments2  = [{''}, {'don''t trust'},{2}];
% %DataCluster.DoNotDoThis = zeros(3); %Fields of dimension > 1 are not supported
% 
% T = NestedStruct2table(DataCluster)
% FileName = 'TestTable.txt';
% writetable(T,FileName, 'Delimiter', '\t');

%%
function T = NestedStruct2table(ClusterIn)

% Extract data from cluster into Cells
[FieldNameCells, FieldValuesCells] = StepThroughCluster(ClusterIn, [], [], []);
% convert Cells to Table
T = convertCellsToTable(FieldNameCells, FieldValuesCells);
end
%%
function T = convertCellsToTable(FieldNameCells, FieldValuesCells)
%% find max data size
nFields = size(FieldValuesCells,2);% Determine  number of columns 
% Determine max number of rows 
SizeMax = 0;
for i = 1:nFields
    ClassID = class(FieldValuesCells{i});
    switch  ClassID
        case 'double'
            if ~isvector(FieldValuesCells{i})
                error('Fild dimension is > 1');
            end
            SizeCell = size(FieldValuesCells{i},1);
        case 'char'
            temptest = FieldValuesCells(i);
            SizeCell = size(temptest,1);
        case 'cell'
             if ~isvector(FieldValuesCells{i})
                error('Fild dimension is > 1');
            end
            SizeCell = max(size(FieldValuesCells{i}));
        otherwise
            warning('class type ''%s'' not implemented', ClassID)
    end
    
    if  SizeCell > SizeMax
        SizeMax = SizeCell;
    end
end
%% Generate  Cell Array
% allocate memory
ValueArray = cell(SizeMax, nFields);
% Fill Cell Array
for i = 1:nFields
    
    ClassID = class(FieldValuesCells{i});
    
    switch ClassID
        case 'double'
            % ValueArray(:,i) = cellstr(num2str(FieldValuesCells{i},10));
            FieldSize = max(size(FieldValuesCells{i}));
            ValueArray(1:FieldSize, i) = num2cell(FieldValuesCells{i});
            
        case 'char'
            ValueArray(1,i) = {sprintf('%s',FieldValuesCells{i})};
            
        case 'cell'
            FieldSize = max(size(FieldValuesCells{i}));
            ValueArray(1:FieldSize, i) = FieldValuesCells{i};
        otherwise
            warning('class type %s not implemented', ClassID)
    end
end

T = cell2table(ValueArray, 'VariableNames', FieldNameCells);
% writetable(T,FileName, 'Delimiter', '\t');
end
%%
function [FieldNameCells, FieldValuesCells] = StepThroughCluster(ClusterIn, FieldNameRoot, FieldNameCells, FieldValuesCells)

FieldNames = fieldnames(ClusterIn);

for ii = 1:length(FieldNames)
    if isstruct(ClusterIn.(FieldNames{ii})) % Step deeper
        fieldnames(ClusterIn.(FieldNames{ii}));
        ClusterOut = ClusterIn.(FieldNames{ii});
        FieldName  =  strcat(FieldNameRoot,FieldNames{ii},'_');
        % use function recursive !
        [FieldNameCells, FieldValuesCells]  = StepThroughCluster(ClusterOut, FieldName, FieldNameCells, FieldValuesCells);
    else % no more Fields => we are at data level => Save data to file
        FieldName  =  strcat(FieldNameRoot,FieldNames{ii});
        FieldNameCells{end+1} = FieldName;
        FieldValues = ClusterIn.(FieldNames{ii});
        try
        FieldValuesCells{end+1} = FieldValues';
        catch
            keyboard
        end
    end
end
end



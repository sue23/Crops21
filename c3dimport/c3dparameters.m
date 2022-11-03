function [c3dpar,ProcessorType]=c3dparameters(filename)
% C3DPARAMETERS c3d groups and parameters importing.
%   C3DPAR = C3DPARAMETERS(FILENAME)imports the groups 
%   and the parameters stored in the .c3d filename
%
%   C3DPAR is a struct array of .c3d N groups and M x N parameters
%      C3DPAR=
%         C3DPAR.[<GROUP1>].[<PARAMETER1GROUP1>]
%                         .[<PARAMETER2GROUP1>]
%                         .[<PARAMETERM1GROUP1>]
%              .[<GROUPN>].[<PARAMETER1GROUP1>]
%                         .[<PARAMETER2GROUP1>]
%                         .[<PARAMETERM2GROUPN>]
% 
%   See also c3ddata, c3dparameters.
% 
%   Author(s): F. Patanè, 2000

%Read the processor file type
[ProcessorType,nRecords,fpos]=c3dprocessor(filename);
%Open file
fid=fopen([filename '.c3d'],'r','n');
%Set the position at the first Group Identifier Format
fseek(fid,fpos,'bof');
%====================Reading Data========================
c3dpar={};
n=abs(fread(fid,1,'int8'));
G=-fread(fid,1,'int8');
i=1;
while n~=0
    % for j=1:nRecords
    %     if G~=0&n==0
    %         GN=G;
    %     else
    GN=ReadGIF(fid,n);
    %     end
    if not(isempty(GN))
        n=abs(fread(fid,1,'int8'));
        G=-fread(fid,1,'int8');
        while G<0 & n~=0
            [Name{i} Data{i} Description{i}]=ReadParam(fid,n,G,ProcessorType);
            if isempty(Data{i})&(ndims(Data{i})>1)
                Data{i}=[];
            end
            i=i+1;
            n=abs(fread(fid,1,'int8'));
            G=-fread(fid,1,'int8');
        end
        
        % workaround for NEXUS BUG (REALLY A BUG???)
        if exist('Name')
            [Reps,indRep]=find(strcmpi(Name{1},Name(2:end)),1);
            if ~isempty(indRep)
                Name(indRep+1:end)=[];
                Data(indRep+1:end)=[];
                Description(indRep+1:end)=[];
            end
            Group=cell2struct(Data,Name,2);
            c3dpar=setfield(c3dpar,GN,Group);
            clear Name Data Description;
        end        
        % end of workaround
        
        %old version (without the workaroud)
        %         Group=cell2struct(Data,Name,2);
        %         c3dpar=setfield(c3dpar,GN,Group);
        %         clear Name Data Description
        %end of old version (without the workaroud)    
        
        i=1;
    end
end
%=========================================================

%====================extra parameters=====================
if isfield(c3dpar.point,'labels2')
    c3dpar.point.labels=[c3dpar.point.labels;c3dpar.point.labels2];
end
%=============change '*[Num]' in 'Unknown[Num]' in label fields============
nstars=strmatch('*',c3dpar.point.labels);
for i=1:length(nstars)
    c3dpar.point.labels(nstars(i))={['unknown' c3dpar.point.labels{nstars(i)}(2:end)]};
end
%=============set analog field if not present============
if ~isfield(c3dpar,'analog')
    c3dpar.analog.used=0;
    c3dpar.analog.offset=0;%Zero analog Offset
    c3dpar.analog.scale=0;%channel Scale
    c3dpar.analog.gen_scale=0;%channel General Scale
    c3dpar.analog.labels={};
end
fclose(fid);

%
%==============================================================
%ReadGIF
%Read the Group Identifier Format
%==============================================================
%
function GN=ReadGIF(fid,n)
% if n~=0
%     n=1
%     GN=lower(fscanf(fid,'%c',n));
%     return
% end
GN=lower(fscanf(fid,'%c',n));
offset=fread(fid,1,'int16');
m=fread(fid,1,'int8');
GD=fscanf(fid,'%c',m);
% end GIF

%
%==============================================================
%ReadParam
%Read the Parameter Name and Data
%==============================================================
%

function [PN,Data,PD]=ReadParam(fid,n,G,ProcessorType)
PN=lower(fscanf(fid,'%c',n));
PN(isspace(PN))='';
offset=fread(fid,1,'int16');
cpos=ftell(fid);
T=fread(fid,1,'int8');
dim=[];
%data dimensions,0 for scalar value
d=fread(fid,1,'int8');

for i=0:(d-1)
    dim=[dim fread(fid,1,'uint8')];
end

if d==0
    dim=1;
end

%========================Read Data===========================
switch T,
    
    %%%%%%%%%%%%%%%%
    % Integer Data %
    %%%%%%%%%%%%%%%%
case 2,
    Data=fread(fid,dim,'int16');
    
    %%%%%%%%%%%%%
    % Real Data %
    %%%%%%%%%%%%%
    case 4
        if exist('verLessThan','file') && ~verLessThan('matlab', '7.7') && strcmp(ProcessorType,'vaxd')
            ProcessorType='n';
            NumberFormat='*uint32';
        else
            NumberFormat='float';
        end
        Data=fread(fid,prod(dim),NumberFormat,0,ProcessorType);
        
        if length(dim)>1
            Data=reshape(Data,dim);
        end
        if strcmp(NumberFormat,'*uint32');            
            Data=VaxToDouble(Data);
        end
%%%%%%%%%%%%%%%
% String Data %
%%%%%%%%%%%%%%%
case -1
    ldim=length(dim);
    dim3=1;
    if ldim==3 dim3=dim(3); dim=dim(1:2); end
    if dim3==0 Data=[];end
    for i=1:dim3
        Data(:,:,i)=readstr(dim,fid);
    end
    Data=squeeze(Data);
    %%%%%%%%%%%%%%%%
    % Logical Data %
    %%%%%%%%%%%%%%%%
case 1
    Data=fread(fid,dim,'bit1');
    
end
%=================================================================

m=fread(fid,1,'int8');
PD=[];
PD=fscanf(fid,'%c',m);
fseek(fid,cpos+offset-2,'bof');

% end ReadParam

%
%==============================================================
%Readstr
%Read the string data
%==============================================================
%
function Data=readstr(dim,fid)
Data=lower(fscanf(fid,'%c',dim));
% workaround for R2006a
temp=size(Data);
if dim(end)<temp(end)
    temp2=Data(:,end);
    Data(:,end)=[];
    fseek(fid,-length(temp2),'cof');
end
% end of workaround
if isempty(Data) Data=''; end
if length(dim)==2
    Data=cellstr(Data');
end
%end readstr

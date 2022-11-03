function [data,c3dpar]=c3ddata(varargin)
tic
%C3DDATA c3d data importing.
%   [DATA,C3DPAR] = C3DDATA(FILENAME)imports the .c3d filename
%
%   DATA is a cell array of video (3 components) and 
%   analog data (1 component).
%   DATA = { [NFrames x 3], ..., [NFrames x 3], [NFrames x 1], ...,[NFrames x 1] }
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
%   Caution:
%      this function uses the header constants declared in c3dheader.m
%      If the format of the c3d file header changes you have to change
%      the header constants in the c3dheader function and the corresponding
%      in the present function.
%
%   See also c3dheader, c3dparameters.

%   Author(s): F. Patanè, 2004

if nargin==0
  [filename, pathname] = uigetfile('*.c3d', 'c3d data importing');
  if filename==0, return; end
  filename=[pathname,'\',filename(1:end-4)];
%   cd(pathname);
else
    filename=varargin{1};
end
%Read header
if strcmpi(filename(end-3:end),'.c3d')
    filename(end-3:end)=[];
end
    header=c3dheader(filename);

%Read Parameter Records
[c3dpar,ProcessorType]=c3dparameters(filename);
%================Constants================================
nFr=header.NAFpF(3);%Number of analog Frames
nch=c3dpar.analog.used;%header.NASpF(3)/nFr;%Number of channels
nP=header.N3DpF(3);%Number of 3D points
PScale=header.Scale(3);%Point Scale
%---------- %Number format int16, float for real-----
NumberFormat='int16';
CMRFormat='int8'; %#ok<NASGU>
if header.Scale(3)<0
    NumberFormat='float';
    CMRFormat='int16';%#ok<NASGU> % camera mask and residual
end
%--------------------------------------------------------
chOffset=c3dpar.analog.offset';%Zero analog Offset
chScale=c3dpar.analog.scale';%channel Scale
chGScale=c3dpar.analog.gen_scale;%channel General Scale
chRScale=chScale.*chGScale';%channel Real Scale
FVF=header.FVF(3);%First Video Field
LVF=header.LVF(3);%Last Video Field
nF=LVF-FVF+1;%number of Fields
Pnbytes=8*nP;%dimension of 3D data field in bytes
chnbytes=2*nch*nFr;%dimension of analogue data field in bytes

%========set the reading pointer in to the c3d file======
%Open file
if exist('verLessThan','file') && ~verLessThan('matlab', '7.7') && strcmp(ProcessorType,'vaxd')
    fid=fopen([filename '.c3d'],'r','n');
else
    fid=fopen([filename '.c3d'],'r',ProcessorType);
end
%Set the position at the first 3D data record
fseek(fid,(header.R3DS(3)-1)*512,'bof');

%================Read Data ==========================
%init data
[p,ch]=ReadPointsAndAnalog(fid,nF,nP,nch,nFr,NumberFormat,ProcessorType,PScale);
chOffset=repmat(chOffset,[size(ch,1),1]);
chRScale=repmat(chRScale,[size(ch,1),1]);
ch=(ch-chOffset).*chRScale;
% data are valid only if not (0,0,0)
NotValid=~any(p,2);
p([NotValid,NotValid,NotValid])=nan;
    
fclose(fid);
%===================convert data to cell array============
datap=shiftdim(num2cell(p,[1,2]));
datach=shiftdim(num2cell(ch,1));
data=[datap(:)',datach(:)'];
% delete(h);


    
%%
% Read trajectories and analog channels     
function [p,ch]=ReadPointsAndAnalog(fid,nF,nP,nch,nFr,NumberFormat,ProcessorType,PScale)

if exist('verLessThan','file') && ~verLessThan('matlab', '7.7') && strcmp(ProcessorType,'vaxd') && strcmp(NumberFormat,'float')
    NumberFormat='*uint32';
    p=zeros(nF,3,nP,'uint32');
	ch=zeros(nch,nFr*nF,'uint32');
else
    p=zeros(nF,3,nP);
    ch=zeros(nch,nFr*nF);
end

if nch==0
    for j=1:nF
        Ptemp=fread(fid,[4,nP],NumberFormat); %================Read 3D Data field===============
        p(j,:,:)=shiftdim(Ptemp(1:3,:),-1);
    end
else
    for j=1:nF
        Ptemp=fread(fid,[4,nP],NumberFormat); %================Read 3D Data field===============
        p(j,:,:)=shiftdim(Ptemp(1:3,:),-1);
        ch(:,((j-1)*nFr+1):j*nFr)=fread(fid,[nch,nFr],NumberFormat);%===============Read analog Data field================
    end
end
if strcmp(NumberFormat,'*uint32');
    p=VaxToDouble(p);    
    ch=VaxToDouble(ch);
elseif strcmp(NumberFormat,'int16'),
    p=p*PScale;
end
if isempty(ch)
    ch=[];
else
    ch=ch';
end

function header=c3dheader(filename)
%C3DHEADER read a c3d header
%   HEADER = C3DHEADER(FILENAME)imports the header 
%   stored in the .c3d filename
%
%   HEADER is a is a struct array of .c3d header parameters value,
%   number of bytes and position in the c3d file header.
%   If the format of the file header changes you have to change
%   the header constants in this function. The position(1) and 
%   the number of bytes(2) are needed to this function to
%   correctly read their value in the c3d file header.
%   In this case see also c3ddata.m
%
%   the current header format is:
%
%    N3DpF: Number of 3d points per Field(n of trajectories
%       header.N3DpF(1)=1 - header.N3DpF.nbytes=2;
%    NASpF: Number of Analog data Sample per Field
%       header.NASpF(1)=2 - header.NASpF(2)=2;
%    FVF  : Field of First Video data
%       header.FVF(1)=3   - header.FVF(2)=2;
%    LVF  : Field of Last Video data
%       header.LVF(1)=4   - header.LVF(2)=2;
%    Scale: Scaling Factor
%       header.Scale(1)=6 - header.Scale(2)=4;
%    R3DS : Record where 3D data Starts
%       header.R3DS(1)=8  - header.R3DS(2)=2;
%    NAFpF: Number of Analog Frames per Field
%       header.NAFpF(1)=9    - header.NAFpF(2)=2;
% 
%   See also c3ddata, c3dparameters.
% 
%   Author(s): F. Patanè, 2002
%   $Revision: 2.0 $  $Date: 2002/10/24 $

%header Constants: if the format of the file header changes you have to change
%the header constants in this function.
header.N3DpF(1)=1;%Number of 3d points per Field(n of trajectories
header.N3DpF(2)=2;
header.NASpF(1)=2;%Number of Analog data Sample per Field
header.NASpF(2)=2;
header.FVF(1)=3;%Field of First Video data
header.FVF(2)=2;
header.LVF(1)=4;%Field of Last Video data
header.LVF(2)=2;
header.Scale(1)=6;%Scaling Factor
header.Scale(2)=4;
header.R3DS(1)=8;%Record where 3D data Starts
header.R3DS(2)=2;
header.NAFpF(1)=9;%Number of Analog Frames per Field
header.NAFpF(2)=2;
%==============================================================

listfield=fieldnames(header);
nfield=length(listfield);
%Open file
fid=fopen([filename,'.c3d'],'r','n');
if fid==-1
    error('file not found');
    return
end
%Reading
while nfield>0
   currfield=listfield{nfield};
   header=setfield( header,currfield,{3},headerValue(fid,getfield(header,currfield)) );
   nfield=nfield-1;
end
fclose(fid);

%
%==============================================================
%HV
%Read the Value of an header Item 
%==============================================================
%

function HV=headerValue(fid,currfield)
HV=currfield;
fseek(fid,HV(1)*2,'bof');
if HV(2)==2
   HV=fread(fid,1,'uint16');
else
    if exist('verLessThan','file') && ~verLessThan('matlab', '7.7')
        HV=fread(fid,1,'*uint32');
        HV=VaxToDouble(HV);
    else
        HV=fread(fid,1,'float','vaxd');
    end
end
% end HV


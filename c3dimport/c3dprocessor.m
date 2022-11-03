function [ProcessorType,nRecords,fpos]=c3dprocessor(filename)

%C3DPROCESSOR read the processor type from a c3d CAMARC file.
HeaderRecordLength=256*2;%bytes
ParameterRecordsLength=4;%bytes
fpos=HeaderRecordLength+ParameterRecordsLength;
%Open file
fid=fopen([filename '.c3d'],'r','n');
%Set the position at the last byte of Parameter record Header
fseek(fid,fpos-2,'bof');
%Read the number of parameter records stored
nRecords=fread(fid,1,'int8');
% =====================select the processor type===========
switch (fread(fid,1,'int8')-83)
case 1
    ProcessorType='n';
case 2
    ProcessorType='vaxd'; %'vaxd' format is no longer supported by Matlab2008!!
case 3
    ProcessorType='ieee-le';
otherwise
    error('error on processor type finding');
end
fclose(fid);

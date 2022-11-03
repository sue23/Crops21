function varargout=c3dget(c3d,varargin)
%C3DGET take points and analog data from a c3d MATLAB object.
%   [A,B,..] = C3DGET(C3D,...,OPT) Takes 
%   POINT data, ANALOG channels and EVENT times
%   from a c3d object
%
%--------------SYNTAX N°1: POINT data--------------------------------------
%   [A,B,..] = C3DGET(C3D,SUBJECT,LABELS,OPT) Takes point 
%   data from a c3d object
%
%   INPUTS:
%       C3D     - (struct) c3d file imported (see c3dimport)
%       SUBJECT - (string) name of the subject corresponding to LABELS argument
%                          type '' for no subject identifier
%       LABELS  - (cell array) -> {LABEL1,LABEL2,LABELi...,LABELn}
%       LABELi  - (string) i-th label
%       OPT     - (string) output option, possible values are:
%                   'a'-> 3d array (set of points, [nFx3xnP])
%                   'c'-> cell array (cell array {[nFx3],[nFx3],...)
%                   'b'-> 3d array (bodyset, [3xnPxnF])
%                   's'-> 2d arrays (separated arrays [nFx3], [nFx3],...)
%   OUTPUTS
%       [A,B,...] - number and data type of output arguments are determined
%       by the OPT value.
%
%   A = C3DGET(C3D,[SUBJECT],LABELS) assumes OPT='a' 
%
%   Example 1:
%       c3d=c3d2c3d('c3dSampleDinamic2');
%       sbj='stairs';
%       labels={'stupbl','stupbr','stupfl','stupfr'};
%       p=c3dget(c3d,sbj,labels);
%       plot(p(:,:,2)) %plots the trajectory of stupbr 
%
%   Example 2:
%       c3d=c3d2c3d('c3dSampleDinamic2');
%       sbj='stairs';
%       labels={'stupbl','stupbr','stupfl','stupfr'};
%       b=c3dget(c3d,sbj,labels,'b');
%       plot3(b(1,[1 2 4 3 1],10),b(2,[1 2 4 3 1],10),b(3,[1 2 4 3 1],10),'O-') %plots the body b at the frame 10 
%
%--------------SYNTAX N°2: ANALOG channels---------------------------------
%   [A,B,..] = C3DGET(C3D,LABELS,OPT) Takes analog data from a c3d object
%
%   INPUTS:
%       ...
%       OPT     - (string) output option, possible values are:
%                   'a'-> 2d array [nFxnCh]
%                   'c'-> cell array (cell array {[nFx1],[nFx1],...)
%                   's'-> 1d arrays (separated arrays [nFx1], [nFx1],...)
%   OUTPUTS
%       [A,B,...] - number and data type of output arguments are determined
%       by the OPT value.
%
%   A = C3DGET(C3D,LABELS) assumes OPT='a'
%
%   Example 1:
%       c3d=c3d2c3d('c3dSampleDinamic2');
%       v=c3dget(c3d,{'fz1','fz2'});
%       plot(v) %plots the channels fz1 and fz2 
%
%--------------SYNTAX N°3 EVENT times--------------------------------------
%   [A,B,..] = C3DGET(C3D,OPT) Takes analog data from a c3d object
%
%   INPUTS:
%       ...
%       OPT     - (string) output option, possible values are:
%                   'abs' -> events are expressed in absolute frame and time
%                   'rel' -> events are expressed in relative frame and time
%       
%   OUTPUTS:
%       A - (struct) A.context.event., where possible field names are
%                     context - 'right', 'left', 'general'
%                     event - 'footoff', 'footstrike', 'general'
%                     when  - 'time' 'aframe' 'vframe'
%                     time - time in seconds
%                     aframe - analog frame
%                     vframe - video frame
%
%   A = C3DGET(C3D) assumes OPT='abs'
%
%   Example 1:
%       c3d=c3d2c3d('c3dSampleDinamic2');
%       v=c3dget(c3d,{'fz1','fz2'});
%       events=c3dget(c3d,'abs');
%       plot(v) %plots the channels fz1 and fz2 
%       hold on
%       plotevents(events.left.footstrike.aframe,'r--'); %plots left
%                                                        %footstrike events
%       plotevents(events.right.footstrike.aframe,'g--');%plots right
%                                                        %footstrike events
%
%   NOTES:
%--------------------------------------------------------------------------
%    1. if a SUBJECT does not exist in the c3d object, then the
%       function gives error and lists the subjects present in the c3d obj
%
%    2. if no SUBJECT identifier is used use the following syntax for
%       to get POINT data:
%       [A,B,..] = C3DGET(C3D,'',LABELS,OPT) 
%
%    3. if one or more LABELS do not exist in the c3d object, then the
%       correspondent component of the output array/cell/bodyset is set to
%       NaN and a warning is invoked
%
%    4. the function is case sensitive for the argument LABELS, then 
%       the labels 'head', 'Head', 'HEAD, 'HeAd' DO NOT correspond to the 
%       same point/analog channel
%
%    5. type C3D.C3DPAR.POINT.RATE and C3D.C3DPAR.ANALOG.RATE to get
%    the respective sample frequencies of POINT data and ANALOG channels
%       Example 1:
%          c3d=c3d2c3d('c3dSampleDinamic2');
%          fs=c3d.c3dpar.point.rate % sample frequency of point data 
%--------------------------------------------------------------------------
%
%
%   See also c3dimport, c3dlabels.

%   Author(s): F. Patanè, 2008
%   $Revision: 2.0 $  $Date: 2008/6/feb $


%%  parse input
sbj='';
labels={};
switch nargin
    case 1
        data_type='event';
        opt='abs';
    case 2
        if ischar(varargin{1})
            data_type='event';
            opt=varargin{1};
        else
            data_type='analog';
            labels=varargin{1};
            opt='a';
        end
    case 3
        if ischar(varargin{1})
            data_type='point';
            sbj=varargin{1};
            labels=varargin{2};
            opt='a';
        else
            data_type='analog';
            labels=varargin{1};
            opt=varargin{2};
        end
    case 4
        data_type='point';
        sbj=varargin{1};
        labels=varargin{2};
        opt=varargin{3};
    otherwise
        error(nargchk(1,4,nargin));
end

%% parse data type (event, point or analog data)
switch data_type
    case 'event'
        varargout=c3devents(c3d,opt);
        if isfield(varargout,'events')
            varargout={varargout.events};
        else
            warning('C3DImport:GetData:EventNotPresent',...
                    'No event is present in c3d object');
                varargout={[]};              
        end
        return;
    case 'analog'
        d=2;
    case 'point'
        d=3;
%         if ~isempty(sbj)
% 
%             %---insert subject prefix
%             sbj_prefix=strmatch(sbj,c3d.c3dpar.subjects.names,'exact');
%             if isempty(sbj_prefix);
%                 if isempty([c3d.c3dpar.subjects.names{:}])
%                     error('C3DImport:GetData:NoSubject',...
%                         ['No subject is present in the c3d object']);
%                 else
%                     error('C3DImport:GetData:SubjectNotPresent',...
%                         ['Only following subjects are present in c3d object:',BuildErrorString(c3d.c3dpar.subjects.names)]);
%                 end
%             end
%             sbj_prefix=sbj_prefix(1);
%             sbj_prefix=c3d.c3dpar.subjects.label_prefixes{sbj_prefix};
%             if c3d.c3dpar.subjects.uses_prefixes==1
%                 for i=1:length(labels)
%                     labels{i}=[sbj_prefix,labels{i}];
%                 end
%             end
%         end
labels=getPrefLabels(c3d.c3dpar,sbj,labels);
        %---
otherwise
    error('argument error');
end

%% find data in c3d struct
[pos,index,lindex]=labelpos(c3d,labels);
if strcmp(data_type,'analog') & isfield(c3d.c3dpar.point,'labels')
    pos = pos + length(c3d.c3dpar.point.labels);
end
if any(~index)
    data=cell(1,length(labels));
    data(find(index))=c3d.data(pos(index));
    if ~isempty(pos)
        dims=size( data{find(index,1)} );
        data(~index)=repmat({nan(dims)},[sum(~index),1]);
    end
    warning off backtrace
    warning('C3DImport:GetData:LabelNotPresent',...
        ['Following labels are not present in c3d object:',BuildErrorString(labels(~index))]);
    warning on backtrace
else
    data=c3d.data(pos);
end

%% pack outputs
switch opt
    case 'a'
        varargout={cat(d,data{:})};
    case 'b'
        temp=cat(d,data{:});
        varargout={permute(temp,[2,3,1])};
        
    case 's'
        varargout=data;
    case 'c'
        varargout={data};
    otherwise
        error('option not allowed for packing data');
end

function str=BuildErrorString(labels)
temp=strvcat(labels);
temp=fliplr(temp);
temp(:,end+1)='n';
temp(:,end+1)='\';
temp=fliplr(temp);
str=sprintf('%s',temp');




function varargout=c3dlabels(c3d)
%C3DLABELS take labels from a c3d MATLAB object. 
%   LABELS = C3DLABELS(C3DPAR) Gives a cell array of strings
%   with the labels of both points and analog signals
%
%   [LPOINT  LANALOG]= C3DLABELS(C3DPAR) Gives a 2 cell array of strings
%   with the labels of points LPOINT and analog LANALOG signals
%
%   See also patientbuilder, datbuilder, bdatbuilder, parambuilder.

%   Author(s): F. Patanè, 2000

%c3d.c3dpar.analog.labels(isempty(c3d.c3dpar.analog.labels))=[];
varargout{1}=c3d.c3dpar.point.labels;
if nargout<=1
    varargout{1}=[varargout{1};c3d.c3dpar.analog.labels];
elseif nargout==2
    varargout{2}=c3d.c3dpar.analog.labels; 
end

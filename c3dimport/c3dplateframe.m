function varargout=c3dplateframe(c3d,varargin)
%C3DPLATEFRAME get the force plates transformation matrices
% [H01,H02,...]=C3DPLATEFRAME(c3d,PLATE)
%   PLATE is a index array pointing to the plate number
%
%   See also buildframe.

%   Author(s): F. Patanè, 2005
%   $Revision: 2.0 $  $Date: 2005/26/apr $

plates=c3d.c3dpar.force_platform.corners;
Nplate=size(plates,3);
plates_o=permute(c3d.c3dpar.force_platform.origin,[1,3,2]);
plates_o=repmat(plates_o,[1,4]);
plates=plates+plates_o;

for i=1:Nplate
    H(:,:,i)=buildframe(plates(:,:,i),[3 4],[3 2],[1:4],'xyz');
end
Nplate_req=[1:Nplate];
if nargin==2
    Nplate_req=varargin{1};
end
for i=1:length(Nplate_req)
    varargout{i}=H(:,:,Nplate_req(i));
end
    
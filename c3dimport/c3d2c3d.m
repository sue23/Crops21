function c3d=c3d2c3d(varargin)
%C3D2C3D import a CAMARC file in a c3d MATLAB object
%   C3D = C3D2C3D import a .c3d file, create a parameter
%   struct array C3DPAR, a data cell array DATA and ensemble them
%   in the whole struct cell C3D:
%
%   C3D = C3D.C3DPAR
%         C3D.DATA
%
%   C3D = C3D2C3D(FILENAME) to automatically load FILENAME.C3D
%
%   Example 1:
%       c3d=c3d2c3d('c3dSampleDinamic2');
%       p=c3dget(c3d,'stairs',{'stupbl','stupbr','stupfl','stupfr'});
%       plot(p(:,:,2)) %plots the trajectory of stupbr 
%
%   Example 2:
%       c3d=c3d2c3d('c3dSampleDinamic2.c3d');
%       p=c3dget(c3d,'stairs',{'stupbl','stupbr','stupfl','stupfr'});
%       plot(p(:,:,2)) %plots the trajectory of stupbr %
%
%   See also c3ddata, c3ddata, c3dlabels.

%   Author(s): F. Patanè, 2000
%   $Revision: 1.0 $  $Date: 2002/10/21 $

if nargin==1
    [c3d.data,c3d.c3dpar]=c3ddata(varargin{1});
else
    [c3d.data,c3d.c3dpar]=c3ddata;
end


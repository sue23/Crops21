function [pos,posi,labeli]=c3dispoint(c3d,strs)
%C3DISPOINT check if a cell array corresponds to point labels
%   [POS,POSI,LABELI] = C3DISPOINT(C3D,STRS)
%   POS is a numeric array with the position of STRS in  point labels
%   POSI is a boolean array long as STRS, it returns 1 if STRS(i)
%   is a point, 0 if not.
%   LABELI is a boolean array long as labels point, it returns 1 if the ith
%   label point is present in STRS, 0 if not.
%
%   See also c3disanalog.

%   Author(s): F. Patanè, 2002
%   $Revision: 2.0 $  $Date: 2002/10/24 $

[pos,posi,labeli]=islabel(c3d.c3dpar.point.labels,strs);

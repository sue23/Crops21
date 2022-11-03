function [pos,posi,labeli]=c3disanalog(c3d,strs)
%C3DISANALOG check if a cell array corresponds to analog labels
%   [POS,POSI,LABELI] = C3DISANALOG(C3D,STRS)
%   POS is a numeric array with the position of STRS in  analog labels
%   POSI is a boolean array long as STRS, it returns 1 if STRS(i)
%   is a analog, 0 if not.
%   LABELI is a boolean array long as labels analog, it returns 1 if the ith
%   label analog is present in STRS, 0 if not.
%
%   See also c3dispoint.

%   Author(s): F. Patanè, 2002
%   $Revision: 2.0 $  $Date: 2002/10/24 $

[pos,posi,labeli]=islabel(c3d.c3dpar.analog.labels,strs);

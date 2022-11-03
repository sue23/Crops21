function p=VaxToDouble(p)
% VAXTODOUBLE convert a int32 array (max 3d) to double using vax format.
%   Aout = VAXTODOUBLE(Ain)change the byte format of the matrix A from vax  
%   	to ieee754 floating point format
%
%   INPUTS:
%       Ain - [ d1xd2xd3xd4 ] uint32 input array, up to 4 dimensions
%
%   OUTPUTS
%       Aout- [ same dimm of input ] double output array
%
%   NOTE:
%--------------------------------------------------------------------------
%
%   function developed due to the lack from Matlab2008b of the 'vax' format 
%   support
%
%--------------------------------------------------------------------------
%
%   ATTENTION
%--------------------------------------------------------------------------
%   
%   input matrix Ain MUST be an array or a multidimensional array of 32 bit
%   integers
%
%--------------------------------------------------------------------------

%
%   See also fopen.

%   Copyright None!
%   $Revision: 2.0 $  $Date: 2006/10/5
%   $Author: F. Patanè, 2006%s=size(p);
s=size(p);
p=typecast(p(:),'uint8');
p=reshape(p,[4,s]);
p=p([3,4,1,2],:,:,:);
p=reshape( typecast(p(:),'single'),s );
p=double(p)/4;
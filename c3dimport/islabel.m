function [pos,posi,labeli]=islabel(labels,strs)
%ISLABEL check which items of cell array contains items are 
%   [POS,POSI,LABELI] = ISLABEL(LABELS,STRS)
%   POS is a numeric array with the position of strs in labels strings
%   POSI is a boolean array long as STRS, it returns 1 if STRS(i)
%   is present in labels, 0 if not.
%   LABELI is a boolean array long as LABELS, it returns 1 if LABELS(I)
%   is present in strs, 0 if not.
%
%   See also c3dispoint, c3disanalog.

%   Author(s): F. Patanè, 2002
%   $Revision: 2.0 $  $Date: 2002/10/24 $

pos=[];
posi=logical(zeros(size(strs)));
labeli=logical(zeros(size(labels)));
j=0;
for i=1:length(strs)
    temp=strmatch(strs(i),labels,'exact');
    posi(i)=~isempty(temp);
    labeli(temp)=posi(i);
    if posi(i)
        j=j+1;
        pos(i)=temp;
    end
end

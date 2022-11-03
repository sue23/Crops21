function [pos,index,lindex]=labelpos(c3d,strs)
%LABELPOS finds the indexes of selected labels in a c3d obj
%   POS = LABELPOS(C3D,STRS) find the position of cell array
%   STRS in C3D LABELS (  LABELS = {PointLabels,AnalogLabels}  )
%   in this case the length of POS is <= as STRS.
%
%   [POS,STRSI,LABELI] =LABELPOS(...) gives also the STRS indexes
%   and the LABELI indexes.
%   in this case the length of STRSI is the same as STRS, and the
%   length of LABELI is the same as LABELS
%
%   STRSI,LABELI are boolean arrays.   
%
%   See also c3dlabels, c3dispoint, c3disanalog.

%   Author(s): F. Patanè, 2002
%   $Revision: 2.0 $  $Date: 2002/10/24 $

labels=c3dlabels(c3d);
[pos,index,lindex]=islabel(labels,strs);

% if any(fail) 
%     fail=find(fail);
%     msg='Labels not found:';
%     for i=1:length(fail)
%         msg=[msg,'\n',strs{fail(i)}];
%     end
%     msg=sprintf(msg);
%     error(msg);
% end

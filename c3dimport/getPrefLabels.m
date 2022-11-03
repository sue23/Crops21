function labels=getPrefLabels(c3dpar,sbj,labels)

if ~isempty(sbj)
    
    %---insert subject prefix
    sbj_prefix=strmatch(sbj,c3dpar.subjects.names,'exact');
    if isempty(sbj_prefix);
        if isempty([c3dpar.subjects.names{:}])
            error('C3DImport:GetData:NoSubject',...
                ['No subject is present in the c3d object']);
        else
            error('C3DImport:GetData:SubjectNotPresent',...
                ['Only following subjects are present in c3d object:',BuildErrorString(c3dpar.subjects.names)]);
        end
    end
    sbj_prefix=sbj_prefix(1);
    %sbj_prefix=c3dpar.subjects.label_prefixes{sbj_prefix};
    if c3dpar.subjects.uses_prefixes==1
        for i=1:length(labels)
            %labels{i}=[sbj_prefix,labels{i}];
            labels{i}=['',labels{i}];
        end
    end
end
end

%   Author(s): F. Patanè, 2008
%   $Revision: 2.0 $  $Date: 2008/6/feb $
%   $Revision: 2.1 $  $Date: 2016/23/feb $ M. Petrarca
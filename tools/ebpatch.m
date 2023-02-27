function hl=ebpatch(x,data,var,cols)
%% vettore ascisse,valore medio, std, colors.
% vettori riga
[r1,c1]=size(data);
[r2,c2]=size(var);
if r1~=1
    data = data';
end
if r2~=1
    var = var';
end
N=min(size(data));
dim=max(size(data));
if(size(cols,1)==0)
    cols=eye(3);
end
eps=.0001;
for n=1:N
%     set(gca,'Color',[0.94,0.94,0.94])
    hold on
    col=cols(n,:);
    sat = 0.6;
% keyboard
if sum(isnan(data(n,:)))>0
data=data(find(isnan(data(n,:))==0))
var=var(find(isnan(data(n,:))==0))
dim=max(size(data));
x=find(isnan(data(n,:))==0)
end
    h=patch([x x(end:-1:1)], [data(n,:)+var(n,1:dim) data(n,end:-1:1)-var(n,end:-1:1)],-eps*ones(2*dim,1),sat+(1-sat)*col);
     set(h,'edgecolor',sat +(1-sat)*col);
     set(h,'FaceAlpha',0.5);
end
for n=1:N
    col=cols(n,:);
    hl(n)=line(x,data(n,:),'Color',col,'LineWidth',2);
end
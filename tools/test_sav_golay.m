function cutoff=test_sav_golay(frame,polord,derorder,fc)
% deve essere sopra 6!!
debug = 0;

x = rand(100000,1);
x=x-mean(x);
x = detrend(x,'constant');
[px,wx]=pspectrum(x,50);



y = sav_golay(x,frame,polord,derorder,fc);
y=y-mean(y);
y = detrend(y,'constant');
[p,w]=pspectrum(y,fc);


if debug
    figure
    plot(wx,px)
    figure
    plot(w,p)
    figure
    line(wx,px(:,1)./max(px(:,1)),'col','k');
    line(w,p(:,1)./max(p(:,1)),'col','r');
    line([0 25],[1 1]./sqrt(2));
    set(gca,'yscale','log');
end

% Find cutoff frequency
cutoff = max(w(find(p(15:end,1)>max(p(15:end,1))./sqrt(2))))
time_window = frame/fc 

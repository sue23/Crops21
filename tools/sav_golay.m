%
% T2= sg(T,l,forder,dorder,fc);
%  
% Polynomial filtering method of Savitsky and Golay 
% Y = vector of signals to be filtered
%     *** the derivative is calculated for each ROW  ** 
% l = filter length
% forder = filter order (2 = quadratic filter, 4= quartic)
% dorder = derivative order (0 = smoothing, 1 = first derivative, etc.) 
% fc = sampling frequency in Hz
function T2 = sav_golay(T,l,forder,dorder,fc)

if nargin==4
   fc=50;
end

[m,n] = size(T);
dorder = dorder + 1;

% *** check inputs ***
if  rem(l,2)-1 ~= 0
        error('filter length is not an odd integer')
elseif (forder) < (dorder)
        error('the derivative order is too large')  
end 

% This is added by sangui
if forder > (l-1) 
    error('filter length is too small');
end

% *** calculate filter coefficients ***
lc = (l-1)/2;                    %index

X = fliplr(vander([-lc:lc]/fc));
X = X(:,1:(forder+1));
F = pinv(X);                     % invert


% *** filter via convolution and take care of initial and end points ***
for col = 1:size(T,2)
 %yss = conv(T([ones(1,lc-1) 1:m m*ones(1,lc-1)],col),F(dorder,:)');
 yss = conv(T([ones(1,lc-1) 1:m m*ones(1,lc)],col),F(dorder,:)');  % This looks better
 % Argument sizes are m+2*(lc-1)=m+l-3 and l
 % Therefore size of result is m+2*l-4=m+2*(l-2)
 
    
 % Form the total output
 %T2(:,col) = [yss(l-1:end-(l-2))];
 T2(:,col) = [yss(l-1:end-(l-1))];  % This looks better
 
 %T2 is now (m+2*(l-2)-l-l+1=m-4+1=m-3

end

if dorder > 1
 T2 = (dorder-1)*(-1).^rem(dorder-1,2)*T2; 
% added by sangui to adjust for sign of derivative
% end of program
end



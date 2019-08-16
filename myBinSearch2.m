function a = myBinSearch2(x,L)
% Find i such that x(i) is the last element of x which is less than or equal to L.
% That is, x(i)<=L, x(i+1)>L if it exists.
% x must be sorted in ascending order.
% If x(1)>L, then the result is []
if(x(1)>x(end))
    error('the first argument must be sorted in ascending order');
end

a = 1;% x(a) is always <=L
b = numel(x); %x(b) is always >L
if(x(end)<=L)
    a=numel(x);
    return;
elseif(x(1)>L)
    a=[];
    return;
end
while(b-a>1)
    centre = floor((a+b)/2);
    if(x(centre)<=L)
        a = centre;
    else % x(centre)>s
        b = centre;
    end
end
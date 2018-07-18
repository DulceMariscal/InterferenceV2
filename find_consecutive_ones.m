function y=find_consecutive_ones(x)

 y = [x;0];
 d=diff([0;y])~=0; %This is one where there has been a transition from the previous index
 f = find(d);      %Indices of transitions
 p = f(2:2:end);
 y(p) = y(p) - p + f(1:2:end-1);
 y = cumsum(y(1:end-1)); %Contains the number of consecutive ones in the original vector (x)


end
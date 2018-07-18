function plot_dots_and_line(data) %Interference

[nsubs, nkinds] = size(data);
v = ones(nsubs, nkinds);

for kind=1:nkinds
    v(:,kind) = kind * v(:,kind) ;
end

plot(v,data,'o')
legend('A1', 'A2')

ADD_LINES=1;
if (ADD_LINES)
   for sub=1:nsubs 
      cdata=[data(sub,:)];
      if diff(cdata)>0
                line([1 2],cdata,'Color','black') 
      else
                line([1 2],cdata,'Color','green') 
      end
   end
end

end
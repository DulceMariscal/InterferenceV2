function addTransitions(transitions,lb,ub)
nt=length(transitions);

for i=1:nt
    ct=transitions(i);
    hold on 
    line([ct ct],[lb ub],'LineStyle','--','Color',[.8 .8 .8])
end


end
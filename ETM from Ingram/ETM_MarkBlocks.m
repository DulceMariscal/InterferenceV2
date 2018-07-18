function ETM_MarkBlocks(pm,pn,pp,trial_block_list,trial_type,trial_object_angle)
% ETM_MarkBlocks(pm,pn,pp,trial_block_list,trial_type,trial_object_angle)
% This function simply marks the different blocks in the paradigm.
% Its role is cosmetic not functional.

    TrialTypeText = { 'Z' 'E' 'C' };

    Hp = subplot(pm,pn,pp);
    hold on;
    xy = axis;
    x = [ (min(trial_block_list)-1) trial_block_list (max(trial_block_list)+1) ];
    i = find(diff(x) > 0);

    for j=1:length(i)
        X = [ i(j) i(j) ]-0.5;
        Y = [ xy(3) xy(4) ];
        plot(X,Y,'k:');
        
        if( (nargin == 6) && (j < length(i)) )
            yoffset = (mod(j+1,2)/15)+0.05;
            Ht = text(i(j)+0.5,xy(4)-yoffset,sprintf('%s%.0f°',TrialTypeText{trial_type(i(j))},degcentre(trial_object_angle(i(j)),180)));
            set(Ht,'FontSize',6);
        end
    end

    i(end) = i(end)-1;
    set(Hp,'XTick',i);
end

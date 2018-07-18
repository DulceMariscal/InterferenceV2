function nanse = nanse(m,dim)

numOfNotNan = sum(~isnan(m),2);

if any(numOfNotNan(:)>8)
    warning('Check the way nanse is being computed.')
end
nanse = squeeze(nanstd(m,0,dim)./sqrt(numOfNotNan));
% nanse =(nanstd(m,0,dim)./sqrt(numOfNotNan));
end

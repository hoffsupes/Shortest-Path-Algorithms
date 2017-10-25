

function [ind,minind] = get_nbrs(s,Y,thresh,d,trav)
ind = [];
minind = [];

ind = find(sqrt(sum(bsxfun(@power,Y - Y(s,:),2),2)) < thresh);
ind = setdiff(ind,trav);
ind = setdiff(ind,s);

if(~isempty(ind))
[~,tind] = min(sqrt(sum(bsxfun(@power,(Y(ind,:) - Y(d,:)),2),2)));
minind = ind(tind);
end

end
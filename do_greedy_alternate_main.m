
function main()
clc;
close all;
clear all;

load routedata.mat;

do_greedy_alternate(1,64,2,Y);

end

function do_greedy_alternate(S,d,nbd,Y)

trav = [];
hop_dist = [0];
s = S;
dn = 0;
while(1)
    
    [ind,minind] = get_nbrs(s,Y,nbd,d,trav);
    
    if(isempty(ind))
    trav = [trav s];
    dn = 1;
    disp('DEAD END!');
    break;
    end
    
    if(nnz(ind == d) == 1)
    trav = [trav s d];
    mask(s) = 0;
    hop_dist = [hop_dist sqrt(sum(bsxfun(@power,Y(s,:) - Y(d,:),2),2))];
    break;
    end
    
    trav = [trav s];
    hop_dist = [hop_dist sqrt(sum(bsxfun(@power,Y(s,:) - Y(minind,:),2),2))];
    
    s = minind;
    
end

nhops = length(trav) - 1;
fprintf('(s,d) is (%d,%d)\n\n',S,d);
fprintf('Number of hops %d \n\n',length(trav) - 1);
fprintf('Node Travseral\n'); trav
fprintf('\nMultihop Distance: %d \n',sum(hop_dist));

end

function [ind,minind] = get_nbrs(s,Y,thresh,d,trav)
ind = [];
minind = [];

ind = find(sqrt(sum(bsxfun(@power,Y - Y(s,:),2),2)) < thresh);
ind = setdiff(ind,trav);

if(~isempty(ind))
[~,tind] = min(sqrt(sum(bsxfun(@power,(Y(ind,:) - Y(d,:)),2),2)));
minind = ind(tind);
end

end
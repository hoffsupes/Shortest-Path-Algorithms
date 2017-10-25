function [Nhops,sum_dist,,nhu,rat,dn] = do_dij(S,d,nbd,Y,M)

nhu = [];
rat = [];
dn = 1;
sum_dist = []
Nhops = [];

if(S == d)
nhu = 0;
rat = 0;
return;
end

shrt_dist = zeros(1,length(Y));
shrt_dist(1:end) = Inf;
shrt_dist(S) = 0;

prev_ele = zeros(1,length(Y));
trav = false(1,length(Y));
mask = true(1,length(Y));

hop_dist = [0];

s = S;
nbd = 2;
p = 1;

while(1)
    
    R = M(s,:);             %% Distance of point s from all other points
    L = (R < nbd) & mask;   %% All those points which are new untraversed neighbors of s(within distance nbd)
    
    nbrs_idx = find(L~=0);  %% Unvisited neighbors
%     
    if (nnz(L) == 0)
    p = 0;
    prev_ele(d) = s;
    mask(s) = 0;
    trav(s) = 1;
    break;
    end
    
    if(nnz(nbrs_idx == d) == 1) %% If destination within neighbors of current s, exit
    shrt_dist(d) = shrt_dist(s) + M(s,d);
    prev_ele(d) = s;
    p = 1;
    mask(s) = 0;
    trav(s) = 1;
    break;
    end
    
    ch_nbr = nbrs_idx((shrt_dist(s) + M(s,nbrs_idx) ) < shrt_dist(nbrs_idx));
    shrt_dist(ch_nbr) = shrt_dist(s) + M(s,ch_nbr);
    prev_ele(ch_nbr) = s;
    
    sH = shrt_dist;
    sH(~mask) = Inf;
    [~,idx] = min(sH);
    
    mask(s) = 0;
    trav(s) = 1;
    
    s = idx;
   
end

pat = [get_path(prev_ele,d) d];

for i = 1:length(pat)-1
hop_dist = [hop_dist M(pat(i),pat(i+1))];
end

nhops = length(pat) - 1;
fprintf('(s,d) is (%d,%d)\n\n',S,d);
fprintf('Number of hops %d \n\n',nhops);
fprintf('Node Travseral\n'); pat
fprintf('\nMultihop Distance: %d \n',sum(hop_dist));

nhu = nhops / sum(hop_dist);
rat = sum(hop_dist) / M(S,d);
sum_dist = sum(hop_dist);
Nhops = nhops;
end

function f = get_path(sh,d)

if(sh(d) ~= 0)
f = get_path(sh,sh(d));
f = [f sh(d)];
else
f = [];
end

end

clc;
close all;
clear all;

load routedata.mat;

M = build_distance_map(Y);

S = 1;
d = 64;
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
    L(s) = 0;               %% So as to not consider itself
    nbrs_idx = find(L~=0);  %% Unvisited neighbors
%     
    if (nnz(L) == 0)
    mask(s) = 0;
    trav(s) = 1;
    
    sH = shrt_dist;
    sH(~mask) = Inf;
    [~,idx] = min(sH);
    
    s = idx;
    continue;
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
    
    mask(s) = 0;
    trav(s) = 1;
    
    sH = shrt_dist;
    sH(~mask) = Inf;
    [~,idx] = min(sH);
    
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

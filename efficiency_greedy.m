function main()

load routedata.mat;
M = build_distance_map(Y);
r = 2;
alpha = 2;
[NHOPS,DIST,nhu,rat,dn] = do_greedy_fxn(2,64,r,Y,M);

multi_hop = (1/(r^2))*(DIST)
sing_hop = (1/(r^2))*(M(2,64))

multi_hop / sing_hop

end
function [NHOPS,DIST,nhu,rat,dn] = do_greedy_fxn(S,d,nbd,Y,M)

mask = logical(ones(1,length(Y)));  %% Mask to store which points have been traversed, initially all ones
NHOPS = [];
DIST = [];
trav = [];
hop_dist = [0];             %% Initial Distance
s = S;
dn = 1;
nhu = [];
rat = [];

if(S == d)
nhu = 0;
rat = 0;
return;
end

while(1)
    
    R = M(s,:);             %% Distance of point s from all other points
    L = (R < nbd) & mask;   %% All those points which are new untraversed neighbors of s(within distance nbd)
    L(s) = 0;
    if(nnz(L) == 0)         %% If no new untraversed neighbors found for s 
    trav = [trav s];        %% Signifies Dead End, update list one final time exit
    disp('DEAD END!');
    mask(s) = 0;
    dn = 0;
    break;
    end
    
    nbrs_idx = find(L~=0);  %% If any points are found, their position given as per nonzero indices of resultant mask
    
    if(nnz(nbrs_idx == d) == 1) %% If destination within neighbors of current s, then add to traversal list and exit
    trav = [trav s d];
    mask(s) = 0;
    hop_dist = [hop_dist M(s,d)];   %% Final hop distance added
    break;
    end
                                        %%% If none of the above cases need to update to new node
    [~,min_nbr_idx] = min(M(nbrs_idx,d)); %% Of all the neighbors found, find one closest to d
    trav = [trav s];                    %% add old s to travsersal list
    mask(s) = 0;
    hop_dist = [hop_dist M(s,nbrs_idx(min_nbr_idx))];   %% add hop dist
    
    s = nbrs_idx(min_nbr_idx);          %% update source to neighbor which is closest to destination node
    
end

nhops = length(trav) - 1;           %% Number of hops is one less than total number of nodes
fprintf('(s,d) is (%d,%d)\n\n',S,d);
fprintf('Number of hops %d \n\n',length(trav) - 1);
fprintf('Node Travseral\n'); trav
fprintf('\nMultihop Distance: %d \n',sum(hop_dist));

nhu = nhops / sum(hop_dist);
rat = sum(hop_dist) / M(S,d);

NHOPS =  nhops;
DIST = sum(hop_dist)

end

function M = build_distance_map(Y)

x = Y(:,1);
y = Y(:,2);

M = bsxfun(@power,(bsxfun(@power,(repmat(x,[1 64]) - repmat(x',[64 1])),2) + bsxfun(@power,(repmat(y,[1 64]) - repmat(y',[64 1])),2)),0.5);

end

function main()
load('routedata.mat');

M = build_distance_map(Y);  %% Distance map built (Not part of logic itself, just did the calculations beforehand for ease of use
% stop_flag = 0;            %% also allows this to be used to list of any n
                            %%% points
                            %%% Each row in this matrix corresponds to the
                            %%% distance of one point from all other points
                            
S = 1;
d = 64;
nbd = 2;

[~,~,~,~,trav] = do_greedy_fxn(S,d,nbd,Y,M);
draw_ele(trav,Y,S,d);
nn = [];
rr = [];
dd = [];
NN = []
    for i = 1:50

    a = floor(1+ (64-1)*rand());
    b = floor(1+ (64-1)*rand());
    [N1,n,r,d,~] = do_greedy_fxn(a,b,nbd,Y,M);

    nn = [nn n];
    rr = [rr r];
    dd = [dd d];
    NN = [NN N1];
    end

    mean(NN)
    mean(nn)
    mean(rr)
    mean(dd)
    
end

function [nhops,nhu,rat,dn,trav] = do_greedy_fxn(S,d,nbd,Y,M)

mask = logical(ones(1,length(Y)));  %% Mask to store which points have been traversed, initially all ones
nhops = [];
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
    L(s) = 0;               %% Dont want to consider the node itself, otherwise yields repetitions
    
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
    trav = [trav s];                    %% a    dd old s to travsersal list
    mask(s) = 0;
    hop_dist = [hop_dist M(s,nbrs_idx(min_nbr_idx))];   %% add hop dist
    
    s = nbrs_idx(min_nbr_idx);          %% update source to neighbor which is closest to destination node
    
end

nhops = length(trav) - 1;           %% Number of hops is one less than total number of nodes
fprintf('(s,d) is (%d,%d)\n\n',S,d);
fprintf('Number of hops %d \n\n',length(trav) - 1);
fprintf('Node Travseral\n'); trav
fprintf('\nMultihop Distance: %d \n',sum(hop_dist));
fprintf('\nSinglehop Distance: %d \n',M(S,d));
nhu = nhops / sum(hop_dist);
rat = sum(hop_dist) / M(S,d);

end

function M = build_distance_map(Y)

x = Y(:,1);
y = Y(:,2);

M = bsxfun(@power,(bsxfun(@power,(repmat(x,[1 64]) - repmat(x',[64 1])),2) + bsxfun(@power,(repmat(y,[1 64]) - repmat(y',[64 1])),2)),0.5);

end
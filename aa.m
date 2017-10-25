clc;
load routedata.mat;

M = build_distance_map(Y); 
                            
S = 10;
d = 64;
nbd = 2;

[~,~,~,~,trav] = do_dij(S,d,nbd,Y,M);
disp('d2')
[prev_ele] = do_dij2(S,d,nbd,Y,M);
% draw_ele(trav,Y,S,d);
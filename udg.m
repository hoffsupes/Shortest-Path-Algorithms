function udg(Y,M,r)
scatter(Y(:,1),Y(:,2)); title('Wireless Network UDG'); hold on;
mask = true(size(M(1,:)));

for i = 1:length(M)

    R = (M(i,:) < r) & mask;
    R(i) = 0;
    k = find(R);
    
    for j = 1:length(k)
    line( [ Y(i,1);Y(k(j),1)],[ Y(i,2);Y(k(j),2)]); hold on;
    end
    
    mask(i) = 0;
end

end
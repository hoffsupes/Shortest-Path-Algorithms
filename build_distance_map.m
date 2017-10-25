function M = build_distance_map(Y)

x = Y(:,1);
y = Y(:,2);

M = bsxfun(@power,(bsxfun(@power,(repmat(x,[1 64]) - repmat(x',[64 1])),2) + bsxfun(@power,(repmat(y,[1 64]) - repmat(y',[64 1])),2)),0.5);

end
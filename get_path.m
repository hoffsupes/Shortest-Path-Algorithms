function f = get_path(sh,d)

if(sh(d) ~= 0)
f = get_path(sh,sh(d));
f = [f sh(d)];
else
f = [];
end

end
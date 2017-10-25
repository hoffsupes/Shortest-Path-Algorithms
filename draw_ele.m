function draw_ele(trav,Y,s,d)

scatter(Y(:,1),Y(:,2)); hold on;
plot(Y(s,1),Y(s,2),'r*'); hold on;
plot(Y(d,1),Y(d,2),'g*'); hold on;
for i = 1:length(trav)-1
line([Y(trav(i),1);Y(trav(i+1),1)],[Y(trav(i),2);Y(trav(i+1),2)]);
end
legend('points','source','destination');
end
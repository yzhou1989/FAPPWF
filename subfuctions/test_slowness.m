dist=80;
depth=[0,400,670,800];

raypar=NaN*ones(2,length(depth));
for i_r=1:length(depth)
    raypar(1,i_r)=raypar_r(deg2rayp(dist/2,'P',depth(i_r)),depth(1));
    raypar(2,i_r)=raypar_r(deg2rayp(dist/2,'P',depth(i_r)),depth(end));
end

figure;hold on;
plot(depth,raypar(1,:));
plot(depth,raypar(2,:));

xlabel('Depth (km)');
ylabel('Slowness (s/km)');
legend('Surface','Bottom');
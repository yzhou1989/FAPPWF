%%
sdep=ncread('GYPSUMS_kmps.nc','depth');
vs=ncread('GYPSUMS_kmps.nc','vs');
pdep=ncread('GYPSUMP_kmps.nc','depth');
vp=ncread('GYPSUMP_kmps.nc','vp');

vs_lon_lat=vs(1,1,:);
vs_ll=vs_lon_lat(:);

vp_lon_lat=vp(1,1,:);
vp_ll=vp_lon_lat(:);

figure;plot(sdep,vs_ll);
hold on;plot(pdep,vp_ll);


%%
figure;
vs=ncread('GYPSUMS_kmps.nc','vs');
dep=ncread('GYPSUMS_kmps.nc','depth');
for i_lay=1:112
    imagesc(vs(:,:,i_lay));
    view(-90,90);
    title(num2str(dep(i_lay)));
    pause(0.2);
end
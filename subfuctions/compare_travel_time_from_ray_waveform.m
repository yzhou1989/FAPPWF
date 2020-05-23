% Yong ZHOU
% 2019-03-30

% all for distance 110 degree

load lon_lat_110_1.mat
lon_lat=sortrows12(lon_lat);
ll_tt=lon_lat(:,1:4);
% plot_tt(ll_tt);

load out_tt.mat % distance 110 degree
out_tt=sortrows12(out_tt);
% plot_tt(out_tt);

load out_tt_noocean.mat % distance 110 degree
out_tt_noocean=sortrows12(out_tt_noocean);
% plot_tt(out_tt_noocean);

dt_wf_ray_ocean=out_tt(:,3:4)-ll_tt(:,3:4);
dt_wf_ray_ocean=[ll_tt(:,1:2),dt_wf_ray_ocean];
% plot_tt_gmt(dt_wf_ray_ocean);

dt_wf_ray_noocean=out_tt_noocean(:,3:4)-ll_tt(:,3:4);
dt_wf_ray_noocean=[ll_tt(:,1:2),-dt_wf_ray_noocean]; % + or -
plot_tt(dt_wf_ray_noocean);
plot_tt_gmt(dt_wf_ray_noocean);


%%% subfunctions

% sortrows12
function [out]=sortrows12(in)

out=sortrows(in,2);
out=sortrows(out,1);

end

% plot world map with matlab
function [f1,f2]=plot_tt(in)

lon=in(:,1);
lat=in(:,2);
t410=in(:,3);
t660=in(:,4);
lon=reshape(lon,180,[]);
lat=reshape(lat,180,[]);
t410=reshape(t410,180,[]);
t660=reshape(t660,180,[]);

f1=figure();
imagesc(lon(:,1),lat(1,:),t410);
axis xy;
colorbar;
colormap jet;

f2=figure();
imagesc(lon(:,1),lat(1,:),t660);
axis xy;
colorbar;
colormap jet;

end

% plot world map with gmt
function []=plot_tt_gmt(in)

dt410=in(:,[1,2,3]);
save('dt410.txt','dt410','-ascii');
% system('bash plot_t_grd dt410.txt');

dt660=in(:,[1,2,4]);
save('dt660.txt','dt660','-ascii');
% system('bash plot_t_grd dt660.txt');

end
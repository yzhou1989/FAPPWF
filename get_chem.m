% get_chem
%
% Yong ZHOU
% zhouy3@sustc.edu.cn
% 2018-05-07

dep=ncread('HMSL-P06_percent.nc','depth');
lat=ncread('HMSL-P06_percent.nc','latitude');
lon=ncread('HMSL-P06_percent.nc','longitude');
dvp=ncread('HMSL-P06_percent.nc','dvp');

dvs=ncread('HMSL-S06_percent.nc','dvs');
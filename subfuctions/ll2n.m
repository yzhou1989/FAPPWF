function [n]=ll2n(lon,lat)
% ll2n
% lon must be int+0.5 and lat must be int+0.5
%
% Yong ZHOU
% zhouy3@sustc.edu.cn
% 2018-05-07

n_lat=89.5-lat+1;
n_lon=lon-(-179.5)+1;

n=360*(n_lat-1)+n_lon;

end
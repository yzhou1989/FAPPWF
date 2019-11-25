function [lon_c,lat_c]=ll2crust(lon,lat)
% ll2crust
% convert lon and lat for crust
%
% Yong ZHOU
% 2018-05-07

if rem(lon,1)~=0
    lon_c=floor(lon)+0.5;
else
    lon_c=lon+0.5;
end

if rem(lat,1)~=0
    lat_c=floor(lat)+0.5;
else
    lat_c=lat-0.5;
end

end
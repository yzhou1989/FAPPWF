% merge_em
%
% Yong ZHOU
% 2017-11-13

lat=-20;
lon=180;

fn=strcat('crust_',num2str(lat),'_',num2str(lon));
crt=importdata(fn,' ',5);
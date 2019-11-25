function [ray]=raypar_s(rayin,depth)
% ray paramter at depth
% Yong ZHOU
% 2018-03-12

a=6371; % km
ldegree=pi*a/180;

rref=a-depth;

ray_sur=rayin./ldegree;
% ray=ray_sur;
ray=a.*ray_sur./rref;

end
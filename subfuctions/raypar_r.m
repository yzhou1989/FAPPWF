function [ray]=raypar_r(rayin,depth)
% ray paramter at depth
% Yong ZHOU
% 2018-03-12

a=6371; % km
rref=a-depth;

ldegree=pi*rref/180;

ray=rayin./ldegree;

end
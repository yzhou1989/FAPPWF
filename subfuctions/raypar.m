function [ray]=raypar(rayin)
% ray paramter at depth
% Yong ZHOU
% 2018-03-12

a=6371; % km
ldegree=pi*a/180;

ray=rayin./ldegree;

end
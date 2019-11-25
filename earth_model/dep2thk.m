function [thk,valout]=dep2thk(dep,valin)
% dep2thk
%
% Yong ZHOU
% 2017-11-12

valout=valin;
thk=conv(dep,[1,-1],'same');

valout(thk==0)=[];
thk(thk==0)=[];
thk(thk<0)=0;

end
function [ref,trans]=pprc_p0(alpha1,rho1,alpha2,rho2)
% pprc_p0
% vertical incident PP reflection and transmission coefficient
%
% Yong ZHOU
% zhouy3@sustc.edu.cn
% 2017-08-28

ar1=alpha1*rho1;
ar2=alpha2*rho2;

ref=-(ar1-ar2)/(ar1+ar2);
trans=2*ar1/(ar1+ar2);

end
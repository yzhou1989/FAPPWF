function [rho]=vp2rho(vp)
% vp2rho
% Vp converted to rho
% based on equation 1 in Brocher 2005
%
% Yong ZHOU
% zhouy3@sustc.edu.cn
% 2017-10-30

coef0=0.0;
coef1=1.6612;
coef2=-0.4721;
coef3=0.0671;
coef4=-0.0043;
coef5=0.000106;

rho=coef0+coef1*vp+coef2*vp.^2+coef3*vp.^3+coef4*vp.^4+coef5*vp.^5;

end
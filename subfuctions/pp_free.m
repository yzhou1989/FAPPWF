function [res]=pp_free(alpha,beta,p)
% Yong ZHOU
% 20170928

ksi=sqrt(1/alpha^2-p^2);
eta=sqrt(1/beta^2-p^2);

s1=4*beta^4*p^2*ksi*eta;
s2=(1-2*beta^2*p^2)^2;

res=(s1-s2)/(s1+s2);

end
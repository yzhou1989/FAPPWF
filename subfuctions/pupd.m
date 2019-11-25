function [res]=pupd(earthmodel,p)
% Yong ZHOU
% 2017-09-25

earthmodel=load(earthmodel);
earthmodel=num2cell(earthmodel);

[~,alpha1,beta1,rho1]=earthmodel{1,:};
[~,alpha2,beta2,rho2]=earthmodel{2,:};

a=rho2*(1-2*beta2^2*p^2)-rho1*(1-2*beta1^2*p^2);
b=rho2*(1-2*beta2^2*p^2)+2*rho1*beta1^2*p^2;
c=rho1*(1-2*beta1^2*p^2)+2*rho2*beta2^2*p^2;
d=2*(rho2*beta2^2-rho1*beta1^2);

E=b*sqrt(1/alpha1^2-p^2)+c*sqrt(1/alpha2^2-p^2);
E2=b*sqrt(1/alpha1^2-p^2)-c*sqrt(1/alpha2^2-p^2);
% F=0*b*sqrt(1/beta1^2-p^2)+c*sqrt(1/beta2^2-p^2);
F=b*sqrt(-p^2)+c*sqrt(1/beta2^2-p^2);
G=a-d*sqrt(1/alpha1^2-p^2)*sqrt(1/beta2^2-p^2);
% H=a-d*sqrt(1/alpha2^2-p^2)*0*sqrt(1/beta1^2-p^2);
H=a-d*sqrt(1/alpha2^2-p^2)*0*sqrt(-p^2);
% H2=a+d*sqrt(1/alpha2^2-p^2)*0*sqrt(1/beta1^2-p^2);
H2=a+d*sqrt(1/alpha2^2-p^2)*0*sqrt(-p^2);

D=E*F+G*H*p^2;

res=-(E2*F+H2*G*p^2)/D;

end
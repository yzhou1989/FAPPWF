function [E_inv]=gen_E_inv(omiga,p,pho,alpha,beta)
% gen_E_inv generate E inversion matrix

% omiga: angular frequency
% p: ray parameter
% pho: density
% alpha: P wave velocity
% bete: S wave velocity

ksi=sqrt(1/alpha^2-p^2);
eta=sqrt(1/beta^2-p^2);

E_inv=[beta^2*p/alpha,(1-2*beta^2*p^2)/(2*alpha*ksi),...
       -1i*p/(2*omiga*pho*alpha*ksi),-1i/(2*omiga*pho*alpha);
       (1-2*beta^2*p^2)/(2*beta*eta),-beta*p,...
       -1i/(2*omiga*pho*beta),1i*p/(2*omiga*pho*beta*eta);
       beta^2*p/alpha,-(1-2*beta^2*p^2)/(2*alpha*ksi),...
       1i*p/(2*omiga*pho*alpha*ksi),-1i/(2*omiga*pho*alpha);
       (1-2*beta^2*p^2)/(2*beta*eta),beta*p,...
       1i/(2*omiga*pho*beta),1i*p/(2*omiga*pho*beta*eta)];
   
end
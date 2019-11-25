function [E]=gen_E(omiga,p,pho,alpha,beta)
% gen_E generate E matrix

% omiga: angular frequency 1
% p: ray parameter s*km^-1
% pho: density kg*m^-3
% alpha: P wave velocity km*s^-1
% bete: S wave velocity km*s^-1

ksi=sqrt(1/alpha^2-p^2);
eta=sqrt(1/beta^2-p^2);

E=[alpha*p,beta*eta,alpha*p,beta*eta;
   alpha*ksi,-beta*p,-alpha*ksi,beta*p;
   2*1i*omiga*pho*alpha*beta^2*p*ksi,1i*omiga*pho*beta*(1-2*beta^2*p^2),...
   -2*1i*omiga*pho*alpha*beta^2*p*ksi,-1i*omiga*pho*beta*(1-2*beta^2*p^2);
   1i*omiga*pho*alpha*(1-2*beta^2*p^2),-2*1i*omiga*pho*beta^3*p*eta,...
   1i*omiga*pho*alpha*(1-2*beta^2*p^2),-2*1i*omiga*pho*beta^3*p*eta];

end
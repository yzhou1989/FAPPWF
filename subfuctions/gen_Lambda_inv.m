function [Lambda_inv]=gen_Lambda_inv(d,omiga,p,alpha,beta)
% gen_Lambda_inve generate Lambda inversion matrix

% d: depth of layer
% omiga: angular frequency
% p: ray parameter
% alpha: P wave velocity
% beta: S wave velocity

ksi=sqrt(1/alpha^2-p^2);
% ksi=1/alpha^2/ksi; % add by yzhou 20170925
eta=sqrt(1/beta^2-p^2);
% eta=1/beta^2/eta; % add by yzhou 201709125

Lambda_inv=diag([exp(-1i*omiga*ksi*d),exp(-1i*omiga*eta*d),...
               exp(1i*omiga*ksi*d),exp(1i*omiga*eta*d)]);

end
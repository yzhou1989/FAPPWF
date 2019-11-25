function [at]=ppat(earth_model,p)
% ppat
% compute PP arival time based on model and slowness
%
% Yong ZHOU
% 2017-12-21

thk=earth_model(:,1);
vp=earth_model(:,2);

u=1./vp;
eta=sqrt(u.^2-p^2);

at=2*sum(u.^2.*thk./eta);

end
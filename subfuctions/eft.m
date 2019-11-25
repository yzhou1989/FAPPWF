function [model_eft]=eft(model)
% earth flattening transform for model
% Yong ZHOU
% 2018-03-12

model_eft=NaN*ones(size(model));

for i_model=1:size(model,1)
    [model_eft(i_model,1),model_eft(i_model,2),model_eft(i_model,3),model_eft(i_model,4)]=...
        left(model(i_model,1),model(i_model,2),model(i_model,3),model(i_model,4));
end

end

function [zf,vpf,vsf,rho]=left(z,vp,vs,rho,varargin)
% earth flattening transform
% Yong ZHOU
% 2018-03-12

if nargin < 5
    a=6371; % km
else
    a=varargin{1};
end

r=a-z;

zf=-a*log(r/a);
vpf=(a/r)*vp;
vsf=(a/r)*vs;

end
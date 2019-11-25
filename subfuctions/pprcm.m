function [pp_w]=pprcm(p,omiga,earth_model)
% compute PP reflection coefficient for multi-layer model
% Usage:
%
% Output:
%   pp_w PP reflection coefficient for water layer
%
% Input:
%   p slowness
%   omiga angular frequency
%   earth_model cell for velocity structure
%
% Yong ZHOU
% zhouy3@sustc.edu.cn
% 2017-08-27

[d,alpha,beta,rho]=earth_model{1,:};
if beta==0
    eta=sqrt(1/alpha^2-p^2);
%     eta_h=1/alpha^2/eta;
%     k=-rho*omiga*tan(omiga*eta_h*d)/eta;
    k=-rho*omiga*tan(omiga*eta*d)/eta;
    s_layer=2;
else
    k=0;
    s_layer=1;
end

n_layer=size(earth_model,1);

M=eye(4);
for i_layer=s_layer:n_layer-1
    [d,alpha,beta,rho]=earth_model{i_layer,:};
    E=gen_E(omiga,p,rho,alpha,beta);
    E_inv=gen_E_inv(omiga,p,rho,alpha,beta);
    Lambda_inv=gen_Lambda_inv(d,omiga,p,alpha,beta);
    
    M=M*E*Lambda_inv*E_inv;
end

[~,alpha,beta,rho]=earth_model{end,:};
E_end=gen_E(omiga,p,rho,alpha,beta);
M=M*E_end;

pp_w=(M(3,3)*(-k*M(2,2)+M(4,2))-M(3,2)*(-k*M(2,3)+M(4,3)))./...
    (M(3,2)*(-k*M(2,1)+M(4,1))-M(3,1)*(-k*M(2,2)+M(4,2)));

end
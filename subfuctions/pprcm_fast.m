function [pp_w]=pprcm_fast(omiga,E_matrix,E_inv_matrix,Lambda_inv_matrix)
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
% zhouyong@scsio.ac.cn
% 2020-04-27

if isnan(E_matrix(1,1,1))
    s_layer=2;
    
    d=E_matrix(1,2,1);
    ksi=E_matrix(1,3,1);
    rho=E_matrix(1,4,1);
    k=-rho*omiga*tan(omiga*ksi*d)/ksi;
else
    s_layer=1;
    k=0;
end

E_matrix(3:4,:,:)=E_matrix(3:4,:,:)*omiga;
E_inv_matrix(:,3:4,:)=E_inv_matrix(:,3:4,:)/omiga;
Lambda_inv_matrix=Lambda_inv_matrix.^omiga;

n_layer=size(E_matrix,3);

M=eye(4);
for i_layer=s_layer:n_layer-1
    E=E_matrix(:,:,i_layer);
    E_inv=E_inv_matrix(:,:,i_layer);
    Lambda_inv=Lambda_inv_matrix(:,:,i_layer);
    
    M=M*E*Lambda_inv*E_inv;
end

E_end=E_matrix(:,:,end);
M=M*E_end;

pp_w=(M(3,3)*(-k*M(2,2)+M(4,2))-M(3,2)*(-k*M(2,3)+M(4,3)))./...
    (M(3,2)*(-k*M(2,1)+M(4,1))-M(3,1)*(-k*M(2,2)+M(4,2)));

end
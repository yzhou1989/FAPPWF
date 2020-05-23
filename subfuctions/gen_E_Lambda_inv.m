function [E,E_inv,Lambda_inv]=gen_E_Lambda_inv(p,earth_model)
% earth_model: matrix, not cell
%
% Yong ZHOU
% zhouyong@scsio.ac.cn
% 2020-04-27

n_layer=size(earth_model,1);
E=zeros(4,4,n_layer);
E_inv=E;
Lambda_inv=zeros(4,4,n_layer);

% oceanic layer
beta=earth_model(1,3);
if beta==0
    s_layer=2;
    E(1,1,1)=NaN; % index for oceanic layer
    
    alpha=earth_model(1,2);

    E(1,2,1)=earth_model(1,1); % d
    E(1,3,1)=sqrt(1/alpha^2-p^2); % ksi
    E(1,4,1)=earth_model(1,4); % rho
else
    s_layer=1;
end

for i_layer=s_layer:n_layer
    
    d=earth_model(i_layer,1);
    alpha=earth_model(i_layer,2);
    beta=earth_model(i_layer,3);
    rho=earth_model(i_layer,4);
    
    ksi=sqrt(1/alpha^2-p^2);
    eta=sqrt(1/beta^2-p^2);
    
    ap=alpha*p;
    bn=beta*eta;
    ae=alpha*ksi;
    bp=beta*p;
    
    group=1-2*beta^2*p^2;
    
    ipbp=2*1i*rho*beta^2*p;
    ipgroup=1i*rho*group;

    ekd=exp(-1i*ksi*d);
    eed=exp(-1i*eta*d);
    
    bpa=beta^2*p/alpha;
    gbn=group/(2*beta*eta);
    gae=group/(2*alpha*ksi);
    ipa=1i/(2*rho*alpha);
    ippae=ipa*p/ksi;
    ipb=1i/(2*rho*beta);
    ippbn=ipb*p/eta;
    
    aie=alpha*ipbp*ksi;
    bg=beta*ipgroup;
    bin=beta*ipbp*eta;
    ag=alpha*ipgroup;

    if i_layer<n_layer
        Lambda_inv(:,:,i_layer)=diag([ekd,eed,ekd^-1,eed^-1]);
        E_inv(:,:,i_layer)=[bpa,gbn,bpa,gbn;gae,-bp,-gae,bp;ippae,ipb,-ippae,-ipb;ipa,-ippbn,ipa,-ippbn]';
%         E_inv(:,:,i_layer)=[bpa,gae,ippae,ipa;gbn,-bp,ipb,-ippbn;bpa,bp,-ippae,ipa;gbn,bp,-ipb,-ippbn];
    end
    E(:,:,i_layer)=[ap,bn,ap,bn;ae,-bp,-ae,bp;aie,bg,-aie,-bg;ag,-bin,ag,-bin];
end

end
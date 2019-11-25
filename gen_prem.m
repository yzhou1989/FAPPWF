% gen_prem

% prem model from shearer 2009

% earth flattening transform

load prem_uneft.mat

prem_eft=NaN*ones(size(prem));

for i_prem=1:size(prem,1)
    [prem_eft(i_prem,1),prem_eft(i_prem,2),prem_eft(i_prem,3),prem_eft(i_prem,4)]=...
        eft(prem(i_prem,1),prem(i_prem,2),prem(i_prem,3),prem(i_prem,4));
end
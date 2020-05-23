function [dmodel]=plot_thk(in_model)
% plot_thk
% example: plot_thk('prem_thk.em')
%
% Yong ZHOU
% 2017-12-05

model=load(in_model);
model=model.prem;

dmodel=NaN*ones(size(model,1)*2,size(model,2));
dmodel(2:2:end)=model;
dmodel(1:2:end)=model;

dmodel(2:2:end,1)=cumsum(model(:,1));
dmodel(1,1)=0;
dmodel(3:2:end,1)=dmodel(2:2:end-1,1);

end
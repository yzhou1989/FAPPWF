function [dmodel]=plot_thk(in_model)
% plot_thk
% example: plot_thk('prem_thk.em')
%
% Yong ZHOU
% 2017-12-05

% model=load(in_model);
model=in_model;

dmodel=NaN*ones(size(model,1)*2,size(model,2));
dmodel(2:2:end)=model;
dmodel(1:2:end)=model;

dmodel(2:2:end,1)=cumsum(model(:,1));
dmodel(1,1)=0;
dmodel(3:2:end,1)=dmodel(2:2:end-1,1);

figure;hold on;
plot(dmodel(:,1),dmodel(:,2));
plot(dmodel(:,1),dmodel(:,3));
plot(dmodel(:,1),dmodel(:,4));
xlabel('Depth (km)');
legend('boxoff','on');
legend('Vp (km/s)','Vs (km/s)','Rho (10^3Kg/m^3)');

view([90 90])
set(gca,'YAxisLocation','Right');

end
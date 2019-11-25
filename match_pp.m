% lon=-63.5;lat=13.5;
% lon=-161.5;lat=-75.5;
lon=-43.5;lat=47.5;
% lon=90.5;lat=15.5;
% lon=90.5;lat=30.5;
% lon=150.5;lat=30.5;
% lon=152.5;lat=42.5;
% lon=-178.5;lat=54.5;
% lon=-94.5,lat=23.5;
% lon=-179.5;lat=55.5;
% lon=-9.5;lat=46.5;

pind='0075';
time_fore=20;
time_lap=10;

% prem_at
p=str2double(pind)*1e-3;
load prem.mat
at_prem=ppat(prem,p);

% arrival time
emf=strcat('../earth_model/pem/pem_',num2str(lon),'_',num2str(lat),'_.mat');
load(emf);
at=ppat(earth_model,p);

premf=strcat('pp_prem_',pind,'_.mat');
prems=load(premf);
pp_prem=prems.out_pp(:,2);
[~,min_ind]=min(pp_prem);
model=pp_prem(min_ind-time_fore:min_ind+time_lap);

[t_p,amp_p,ind_p]=corr_t_amp(model,pp_prem,2)
% figure;plot(prems.out_pp(:,1),pp_prem);
% hold on;plot((0:length(model)-1)/2+t_p,model)
% y_lim=get(gca,'YLim');
% plot((at_prem+3)*ones(1,2),y_lim);
% xlim([150,400]);
% title(strcat('prem\_',pind,':',num2str(t_p),'\_',num2str(amp_p)));

mf=strcat('pp_wf_',pind,'/pp_',num2str(lon),'_',num2str(lat),'_.mat');
load(mf);

% earth_model=;
% p=;
% fs=2;
% wf=;
% [tt,pp_wf]=ppwf(earth_model,p,wf,fs);
% out_pp=[tt,pp_wf];

[t,amp,ind]=corr_t_amp(model,out_pp(:,2),2)

figure;plot(out_pp(:,1),out_pp(:,2));
hold on;plot((0:length(model)-1)/2+t,model);
y_lim=get(gca,'YLim');
plot((at+3)*ones(1,2),y_lim);
xlim([150,400]);
title(strcat(num2str(time_lap),':',num2str(lon),'\_',num2str(lat),'\_',pind,':',num2str(t),'\_',num2str(amp)));
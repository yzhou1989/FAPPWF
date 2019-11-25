% plot_global_t_amp
%
% Yong ZHOU
% 2018-05-11

dist=80;

load(['lon_lat_',num2str(dist)]);

% arrival time of P660P, P410P and PP from PREM model with different
% distance
switch dist
    case 80
        th660=73.5;
        th410=110.2;
        thpp=183.5;
    case 110
        th660=81.0;
        th410=120.8;
        thpp=201.2;
    case 140
        th660=84.75;
        th410=129.2;
        thpp=214.5;
end

% theoretical travel time and amplitude ratio
load(['ppwf_prem_',num2str(dist)]);
fs=4;
n_order=4;
min_period=15; % s
max_period=75; % s

% parameters for filter
[b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass');
twin=30;

pp_t=out_pp(:,1);
pp_wf=out_pp(:,2);

%% process
% filter

ppwf_fil=filter(b,a,pp_wf);

% cross-correlation
[prem_t410,prem_amp410,ts410,tp410p,wfp410p,tpp410,wfpp410]=tamp_corr(pp_t',ppwf_fil',th410,thpp,twin,'y');
[prem_t660,prem_amp660,ts660,tp660p,wfp660p,tpp660,wfpp660]=tamp_corr(pp_t',ppwf_fil',th660,thpp,twin,'y');

t410=lon_lat(:,[1,2,3]);
t410(:,3)=t410(:,3)-prem_t410;
tf_410=['t410_',num2str(dist),'.txt'];
save(tf_410,'t410','-ascii');
system(['sh plot_t_grd ',tf_410]);

t660=lon_lat(:,[1,2,4]);
t660(:,3)=t660(:,3)-prem_t660;
tf_660=['t660_',num2str(dist),'.txt'];
save(tf_660,'t660','-ascii');
system(['sh plot_t_grd ',tf_660]);

a410=lon_lat(:,[1,2,5]);
a410(:,3)=(a410(:,3)-prem_amp410)/prem_amp410*100;
af_410=['a410_',num2str(dist),'.txt'];
save(af_410,'a410','-ascii');
system(['sh -x plot_amp_grd ',af_410]);

a660=lon_lat(:,[1,2,6]);
a660(:,3)=(a660(:,3)-prem_amp660)/prem_amp660*100;
af_660=['a660_',num2str(dist),'.txt'];
save(af_660,'a660','-ascii');
system(['sh plot_amp_grd ',af_660]);

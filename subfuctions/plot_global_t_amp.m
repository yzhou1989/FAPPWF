% plot_global_t_amp
%
% Yong ZHOU
% 2018-05-11

clear;
%% parameters
ddeg=110;

method=1; % 1 for 'PP_p', 2 for 'P660P_p' and 3 for 'dif_p'

refd=800; % km
min_thick=5.0;

gauss=6;

fs=4;
ln=4096;

n_order=4;
min_period=15; % s
max_period=75; % s
[b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass'); % parameters for filter

twin=30; %s width of time window for cross-correlation

%% dt and ar from waveforms with prem model

% generate input waveform
gauss_mean=gauss/2+50;
gauss_sigma=gauss/6;
[ti,wf,fs]=gen_wf(gauss_mean,gauss_sigma,fs,ln);

% load prem
load('../earth_model/prem_uneft.mat'); % for prem
prem_cut=cut_model(prem,0,refd);
prem_eft=eft(prem_cut);
prem_cake_eft=gen_cake(prem_eft,min_thick);
em=prem_cake_eft;

p=raypar_r(deg2rayp(ddeg,'P^660P'),0);
[~,pp_wf]=ppwf_fast(em,p,wf,fs);
p660p_fil=filter(b,a,pp_wf);

p=raypar_r(deg2rayp(ddeg,'P^410P'),0);
[~,pp_wf]=ppwf_fast(em,p,wf,fs);
p410p_fil=filter(b,a,pp_wf);

p=raypar_r(deg2rayp(ddeg,'PP'),0);
[pp_t,pp_wf]=ppwf_fast(em,p,wf,fs);
pp_fil=filter(b,a,pp_wf);

% thpp=get_thpp(pp_t,pp_fil);
% th410=thpp-(deg2ttime(ddeg,'PP')-deg2ttime(ddeg,'P^410P'));
% th660=thpp-(deg2ttime(ddeg,'PP')-deg2ttime(ddeg,'P^660P'));

% arrival time of P660P, P410P and PP from PREM model with different
% distance
switch ddeg
    case 80
        switch method
            case 1
                th660=73.50;
                th410=110.25; % th410=110.2; need check
                thpp=183.50;
            case 2
                th660=76.75;
                th410=114.50;
                thpp=191.25;
            case 3
                th660=76.75;
                th410=112.25;
                thpp=183.50;
        end
        
    case 110
        switch method
            case 1
                th660=81.00;
                th410=120.75;
                thpp=201.25;
            case 2
                th660=82.50;
                th410=123.75;
                thpp=205.75;                
            case 3
                th660=82.50;
                th410=122.50;
                thpp=201.25;                
        end
        
    case 140
        switch method
            case 1
                th660=84.75;
                th410=129.25;
                thpp=214.50;
            case 2
                th660=85.50;
                th410=130.75;
                thpp=217.25;                
            case 3
                th660=85.50;
                th410=130.00;
                thpp=214.50;                
        end
end

% cross-correlation
switch method
    case 1
        [prem_t410,prem_amp410]=tamp_corr_2(pp_t,pp_fil,pp_fil,th410,thpp,twin,'y');
        [prem_t660,prem_amp660]=tamp_corr_2(pp_t,pp_fil,pp_fil,th660,thpp,twin,'y');
    case 2
        [prem_t410,prem_amp410]=tamp_corr_2(pp_t,p660p_fil,p660p_fil,th410,thpp,twin,'y');
        [prem_t660,prem_amp660]=tamp_corr_2(pp_t,p660p_fil,p660p_fil,th660,thpp,twin,'y');
    case 3
        [prem_t410,prem_amp410]=tamp_corr_2(pp_t,p410p_fil,pp_fil,th410,thpp,twin,'y');
        [prem_t660,prem_amp660]=tamp_corr_2(pp_t,p660p_fil,pp_fil,th660,thpp,twin,'y');
end


%% dt and ar from waveforms with different earth model
lon_lat=NaN*ones(360*180,6);
ill=0;

for lon=-179.5:179.5
    for lat=-89.5:89.5
        ill=ill+1;
        lon_lat(ill,1)=lon;
        lon_lat(ill,2)=lat;
    end
end

for ill=1:length(lon_lat)
    %         tic;
    disp(ill);
    
    p660p=load(['./wf_rem_eft_P660P_',num2str(ddeg),'/wf_',num2str(lon_lat(ill,1)),'_',num2str(lon_lat(ill,2)),'_.mat']);
    p410p=load(['./wf_rem_eft_P410P_',num2str(ddeg),'/wf_',num2str(lon_lat(ill,1)),'_',num2str(lon_lat(ill,2)),'_.mat']);
    pp=load(['./wf_rem_eft_PP_',num2str(ddeg),'/wf_',num2str(lon_lat(ill,1)),'_',num2str(lon_lat(ill,2)),'_.mat']);
    
    pp_t=p660p.out_pp(:,1);
    
    p660p_fil=filter(b,a,p660p.out_pp(:,2));
    p410p_fil=filter(b,a,p410p.out_pp(:,2));
    pp_fil=filter(b,a,pp.out_pp(:,2));
    
    % cross-correlation between phases from one waveform
    %     thpp=get_thpp(pp_t,p660p_fil);
    %     th410=thpp-dth410;
    %     th660=thpp-dth660;
    
    
    switch method
        case 1
            thpp=get_thpp(pp_t,pp_fil);
            [t410,amp410]=tamp_corr_2(pp_t',pp_fil',pp_fil',th410,thpp,twin,'y');
            [t660,amp660]=tamp_corr_2(pp_t',pp_fil',pp_fil',th660,thpp,twin,'y');
        case 2
            thpp=get_thpp(pp_t,p660p_fil);
            [t410,amp410]=tamp_corr_2(pp_t',p660p_fil',p660p_fil',th410,thpp,twin,'y');
            [t660,amp660]=tamp_corr_2(pp_t',p660p_fil',p660p_fil',th660,thpp,twin,'y');
        case 3
            thpp=get_thpp(pp_t,pp_fil);
            [t410,amp410]=tamp_corr_2(pp_t',p410p_fil',pp_fil',th410,thpp,twin,'y');
            [t660,amp660]=tamp_corr_2(pp_t',p660p_fil',pp_fil',th660,thpp,twin,'y');
    end
    
    % save result
    lon_lat(ill,3)=t410;
    lon_lat(ill,4)=t660;
    lon_lat(ill,5)=amp410;
    lon_lat(ill,6)=amp660;
    
    %         toc;
end

save(['lon_lat_',num2str(ddeg),'_',num2str(method)],'lon_lat');

%% plot figures
t410=lon_lat(:,[1,2,3]);
t410(:,3)=t410(:,3)-prem_t410;
tf_410=['t410_',num2str(ddeg),'_',num2str(method),'.txt'];
save(tf_410,'t410','-ascii');
system(['sh plot_t_grd ',tf_410]);

t660=lon_lat(:,[1,2,4]);
t660(:,3)=t660(:,3)-prem_t660;
tf_660=['t660_',num2str(ddeg),'_',num2str(method),'.txt'];
save(tf_660,'t660','-ascii');
system(['sh plot_t_grd ',tf_660]);

a410=lon_lat(:,[1,2,5]);
a410(:,3)=(a410(:,3)-prem_amp410)/prem_amp410*100;
af_410=['a410_',num2str(ddeg),'_',num2str(method),'.txt'];
save(af_410,'a410','-ascii');
system(['sh -x plot_amp_grd ',af_410]);

a660=lon_lat(:,[1,2,6]);
a660(:,3)=(a660(:,3)-prem_amp660)/prem_amp660*100;
af_660=['a660_',num2str(ddeg),'_',num2str(method),'.txt'];
save(af_660,'a660','-ascii');
system(['sh plot_amp_grd ',af_660]);
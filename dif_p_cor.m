%% parameters
refd=800; % km
min_thick=5.0; 

gauss=6;

fs=4;
ln=4096;

% ddeg=140;

n_order=4;
min_period=15; % s
max_period=75; % s
[b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass'); % parameters for filter

twin=30; %s width of time window for cross-correlation

%% load earth model
% % load prem
% load('../earth_model/prem_uneft.mat'); % for prem
% prem_cut=cut_model(prem,0,refd);
% prem_eft=eft(prem_cut);
% prem_cake_eft=gen_cake(prem_eft,min_thick);
% em=prem_cake_eft;

lon=90.5;
lat=30.5;
emf=['../earth_model/rem_eft/rem_eft_',num2str(lon),'_',num2str(lat),'_.mat'];
load(emf);
em=earth_model;

%% generate input waveform
gauss_mean=gauss/2+50;
gauss_sigma=gauss/6;
[ti,wf,fs]=gen_wf(gauss_mean,gauss_sigma,fs,ln);

%% slowness
ddeg_vec=80:10:140;
res=NaN*ones(length(ddeg_vec),13);

for i_ddeg=1:length(ddeg_vec)
    ddeg=ddeg_vec(i_ddeg);
    
    %% compute reflect waveform and filter
    [~,pp_wf_pp]=ppwf(em,raypar(deg2rayp(ddeg,'PP')),wf,fs);
    ppwf_fil_pp=filter(b,a,pp_wf_pp);
    [~,pp_wf_p410p]=ppwf(em,raypar(deg2rayp(ddeg,'P^410P')),wf,fs);
    ppwf_fil_p410p=filter(b,a,pp_wf_p410p);
    [pp_t,pp_wf_p660p]=ppwf(em,raypar(deg2rayp(ddeg,'P^660P')),wf,fs);
    ppwf_fil_p660p=filter(b,a,pp_wf_p660p);
    
    % cross-correlation
    thpp=get_thpp(pp_t,ppwf_fil_pp);
    th410=thpp-(deg2ttime(ddeg,'PP')-deg2ttime(ddeg,'P^410P'));
    th660=thpp-(deg2ttime(ddeg,'PP')-deg2ttime(ddeg,'P^660P'));
    
    [t410_1,amp410_1]=tamp_corr_2(pp_t,ppwf_fil_pp,ppwf_fil_pp,th410,thpp,twin,'y');
    [t660_1,amp660_1]=tamp_corr_2(pp_t,ppwf_fil_pp,ppwf_fil_pp,th660,thpp,twin,'y');
    
    [t410_2,amp410_2]=tamp_corr_2(pp_t,ppwf_fil_p660p,ppwf_fil_pp,th410,thpp,twin,'y');
    [t660_2,amp660_2]=tamp_corr_2(pp_t,ppwf_fil_pp,ppwf_fil_pp,th660,thpp,twin,'y');    
    
    [t410_3,amp410_3]=tamp_corr_2(pp_t,ppwf_fil_p410p,ppwf_fil_pp,th410,thpp,twin,'y');
    [t660_3,amp660_3]=tamp_corr_2(pp_t,ppwf_fil_p660p,ppwf_fil_pp,th660,thpp,twin,'y');
    
    res(i_ddeg,1:2)=[ddeg,raypar(deg2rayp(ddeg,'PP'))];
    res(i_ddeg,3:4)=[t410_1,amp410_1];
    res(i_ddeg,5:6)=[t660_1,amp660_1];
    res(i_ddeg,7:8)=[t410_3,amp410_3];
    res(i_ddeg,9:10)=[t660_3,amp660_3];
    
    res(i_ddeg,11:13)=[thpp,th410,th660];
end

%% plot waveform
figure; hold on;
plot(pp_t,ppwf_fil_pp);
plot(pp_t,ppwf_fil_p410p);
plot(pp_t,ppwf_fil_p660p);
xlabel('Time (s)');ylabel('Amplitude');
title('Distance=140 degree');
% xlim([50 250]);
xlim([0 300]);

%% plot result
% dTpp-p410p
figure;hold on;
plot(res(:,1),res(:,3));
plot(res(:,1),res(:,7));
plot(res(:,1),res(:,11)-res(:,12),'k--');

xlabel('Distance (degree)');
ylabel('Differential Time (s)');
legend('slowness with PP','different slowness','Taup');
title('DTpp-p410p');

% dAp410/pp
figure;hold on;
plot(res(:,1),100*res(:,4));
plot(res(:,1),100*res(:,8));

xlabel('Distance (degree)');
ylabel('Amplitude ratio (%)');
legend('slowness with PP','different slowness');
title('DAp410p/pp');

% dTpp-p660p
figure;hold on;
plot(res(:,1),res(:,5));
plot(res(:,1),res(:,9));
plot(res(:,1),res(:,11)-res(:,13),'k--');

xlabel('Distance (degree)');
ylabel('Differential Time (s)');
legend('slowness with PP','different slowness','Taup');
title('DTpp-p660p');

% dAp660/pp
figure;hold on;
plot(res(:,1),100*res(:,6));
plot(res(:,1),100*res(:,10));

xlabel('Distance (degree)');
ylabel('Amplitude ratio (%)');
legend('slowness with PP','different slowness');
title('DAp660p/pp');
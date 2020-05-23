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

method=1;

%% generate input waveform
gauss_mean=gauss/2+50;
gauss_sigma=gauss/6;
[ti,wf,fs]=gen_wf(gauss_mean,gauss_sigma,fs,ln);

%% slowness
ddeg_vec=80:10:140;
res=NaN*ones(length(ddeg_vec),10);

% figure(1);hold on;title('DT PP-P410P');
% figure(2);hold on;title('DT PP-P660P');
% figure(3);hold on;title('AR P410P/PP');
% figure(4);hold on;title('AR P660P/PP');

for i_ddeg=1:length(ddeg_vec)
    ddeg=ddeg_vec(i_ddeg);
    
    % load prem
    load('../earth_model/prem_uneft.mat'); % for prem
    prem_cut=cut_model(prem,0,refd);
    prem_eft=eft(prem_cut);
    prem_cake_eft=gen_cake(prem_eft,min_thick);
    prem_em=prem_cake_eft;
    
    p=raypar_r(deg2rayp(ddeg,'P^660P'),0);
    [~,pp_wf]=ppwf_fast(prem_em,p,wf,fs);
    p660p_fil=filter(b,a,pp_wf);
    
    p=raypar_r(deg2rayp(ddeg,'P^410P'),0);
    [~,pp_wf]=ppwf_fast(prem_em,p,wf,fs);
    p410p_fil=filter(b,a,pp_wf);
    
    p=raypar_r(deg2rayp(ddeg,'PP'),0);
    [pp_t,pp_wf]=ppwf_fast(prem_em,p,wf,fs);
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
    
    %% compute reflect waveform and filter
    
    %% load earth model
    lon=90.5;
    lat=30.5;
    emf=['../earth_model/rem_eft/rem_eft_',num2str(lon),'_',num2str(lat),'_.mat'];
    load(emf);
    em=earth_model;
    
    [~,pp_wf_pp]=ppwf_fast(em,raypar(deg2rayp(ddeg,'PP')),wf,fs);
    ppwf_fil_pp=filter(b,a,pp_wf_pp);
    [~,pp_wf_p410p]=ppwf_fast(em,raypar(deg2rayp(ddeg,'P^410P')),wf,fs);
    ppwf_fil_p410p=filter(b,a,pp_wf_p410p);
    [pp_t,pp_wf_p660p]=ppwf_fast(em,raypar(deg2rayp(ddeg,'P^660P')),wf,fs);
    ppwf_fil_p660p=filter(b,a,pp_wf_p660p);
    
    % cross-correlation
    %     thpp=get_thpp(pp_t,ppwf_fil_pp);
    %     th410=thpp-(deg2ttime(ddeg,'PP')-deg2ttime(ddeg,'P^410P'));
    %     th660=thpp-(deg2ttime(ddeg,'PP')-deg2ttime(ddeg,'P^660P'));
    
    switch method
        case 1
            [t410,amp410]=tamp_corr_2(pp_t,ppwf_fil_pp,ppwf_fil_pp,th410,thpp,twin,'y');
            [t660,amp660]=tamp_corr_2(pp_t,ppwf_fil_pp,ppwf_fil_pp,th660,thpp,twin,'y');
        case 2
            [t410,amp410]=tamp_corr_2(pp_t,ppwf_fil_p660p,ppwf_fil_p660p,th410,thpp,twin,'y');
            [t660,amp660]=tamp_corr_2(pp_t,ppwf_fil_p660p,ppwf_fil_p660p,th660,thpp,twin,'y');
        case 3
            [t410,amp410]=tamp_corr_2(pp_t,ppwf_fil_p410p,ppwf_fil_pp,th410,thpp,twin,'y');
            [t660,amp660]=tamp_corr_2(pp_t,ppwf_fil_p660p,ppwf_fil_pp,th660,thpp,twin,'y');
    end
    
    res(i_ddeg,1:2)=[ddeg,raypar(deg2rayp(ddeg,'PP'))];
    res(i_ddeg,3:4)=[t410,amp410];
    res(i_ddeg,5:6)=[t660,amp660];
    res(i_ddeg,7:8)=[prem_t410,prem_amp410];
    res(i_ddeg,9:10)=[prem_t660,prem_amp660];
    
end

plot(res(:,1),res(:,3)-res(:,7));
plot(res(:,1),res(:,5)-res(:,9));
plot(res(:,1),100*(res(:,4)-res(:,8))./res(:,8));
plot(res(:,1),100*(res(:,6)-res(:,10))./res(:,10));

% %% plot waveform
% figure; hold on;
% plot(pp_t,ppwf_fil_pp);
% plot(pp_t,ppwf_fil_p410p);
% plot(pp_t,ppwf_fil_p660p);
% xlabel('Time (s)');ylabel('Amplitude');
% title('Distance=140 degree');
% % xlim([50 250]);
% xlim([0 300]);
%
% %% plot result
% % dTpp-p410p
% figure;hold on;
% plot(res(:,1),res(:,3));
% plot(res(:,1),res(:,7));
% plot(res(:,1),res(:,11)-res(:,12),'k--');
%
% xlabel('Distance (degree)');
% ylabel('Differential Time (s)');
% legend('slowness with PP','different slowness','Taup');
% title('DTpp-p410p');
%
% % dAp410/pp
% figure;hold on;
% plot(res(:,1),100*res(:,4));
% plot(res(:,1),100*res(:,8));
%
% xlabel('Distance (degree)');
% ylabel('Amplitude ratio (%)');
% legend('slowness with PP','different slowness');
% title('DAp410p/pp');
%
% % dTpp-p660p
% figure;hold on;
% plot(res(:,1),res(:,5));
% plot(res(:,1),res(:,9));
% plot(res(:,1),res(:,11)-res(:,13),'k--');
%
% xlabel('Distance (degree)');
% ylabel('Differential Time (s)');
% legend('slowness with PP','different slowness','Taup');
% title('DTpp-p660p');
%
% % dAp660/pp
% figure;hold on;
% plot(res(:,1),100*res(:,6));
% plot(res(:,1),100*res(:,10));
%
% xlabel('Distance (degree)');
% ylabel('Amplitude ratio (%)');
% legend('slowness with PP','different slowness');
% title('DAp660p/pp');
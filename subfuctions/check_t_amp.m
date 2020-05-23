%% parameters
ddeg=80;

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

%% generate input waveform
gauss_mean=gauss/2+50;
gauss_sigma=gauss/6;
[ti,wf,fs]=gen_wf(gauss_mean,gauss_sigma,fs,ln);

%% dt and ar from waveforms with prem model

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
%             thpp=get_thpp(pp_t,ppwf_fil_pp);
            [t410,amp410]=tamp_corr_2(pp_t,ppwf_fil_pp,ppwf_fil_pp,th410,thpp,twin,'y');
            [t660,amp660]=tamp_corr_2(pp_t,ppwf_fil_pp,ppwf_fil_pp,th660,thpp,twin,'y');
        case 2
            thpp=get_thpp(pp_t,ppwf_fil_p660p);
            [t410,amp410]=tamp_corr_2(pp_t,ppwf_fil_p660p,ppwf_fil_p660p,th410,thpp,twin,'y');
            [t660,amp660]=tamp_corr_2(pp_t,ppwf_fil_p660p,ppwf_fil_p660p,th660,thpp,twin,'y');
        case 3
            thpp=get_thpp(pp_t,ppwf_fil_pp);
            [t410,amp410]=tamp_corr_2(pp_t,ppwf_fil_p410p,ppwf_fil_pp,th410,thpp,twin,'y');
            [t660,amp660]=tamp_corr_2(pp_t,ppwf_fil_p660p,ppwf_fil_pp,th660,thpp,twin,'y');
    end
    
    dt410=t410-prem_t410;
    dt660=t660-prem_t660;
    ar410=(amp410-prem_amp410)/prem_amp410*100;
    ar660=(amp660-prem_amp660)/prem_amp660*100;
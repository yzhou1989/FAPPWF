% batch_match_pp
%
% Yong ZHOU
% 2020-04-28

tic;

%% parameters

    fs=4;
    n_order=4;
    min_period=15; % s
    max_period=75; % s
    
    [b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass'); % parameters for filter
    
    twin=30; %s. width of time window for cross-correlation
    
for ddeg=80:30:140    
    % differential arrival time between P660P, P410P and PP from PREM model with different distance
    dth410=deg2ttime(ddeg,'PP')-deg2ttime(ddeg,'P^410P');
    dth660=deg2ttime(ddeg,'PP')-deg2ttime(ddeg,'P^660P');
    
    %% main part
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
        thpp=get_thpp(pp_t,p660p_fil);
        th410=thpp-dth410;
        th660=thpp-dth660;
        
        [t410,amp410]=tamp_corr_2(pp_t',p410p_fil',pp_fil',th410,thpp,twin,'y');
        [t660,amp660]=tamp_corr_2(pp_t',p660p_fil',pp_fil',th660,thpp,twin,'y');
        
        %     % cross-correlation  between phases from different waveforms
        %     thpp=get_thpp(pp_t,pp_fil);
        %     th410=thpp-dth410;
        %     th660=thpp-dth660;
        %
        %     [t410,amp410]=tamp_corr_2(pp_t',p410p_fil',pp_fil',th410,thpp,twin,'y');
        %     [t660,amp660]=tamp_corr_2(pp_t',p660p_fil',pp_fil',th660,thpp,twin,'y');
        
        % save result
        lon_lat(ill,3)=t410;
        lon_lat(ill,4)=t660;
        lon_lat(ill,5)=amp410;
        lon_lat(ill,6)=amp660;
        
        %         toc;
    end
    
    save(['lon_lat_',num2str(ddeg),'.mat'],'lon_lat');
    
    toc;
    
end
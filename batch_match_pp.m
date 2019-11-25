% batch_match_pp
%
% Yong ZHOU
% 2017-12-20

st=cputime;

dist=80;

fs=4;
n_order=4;
min_period=15; % s
max_period=75; % s

% parameters for filter
[b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass');

    
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

% width of time window for cross-correlation
twin=30; %s

% pind='0055';
% time_fore=20;
% time_lap=10;
% 
% premf=strcat('pp_prem_',pind,'_.mat');
% prems=load(premf);
% pp_prem=prems.out_pp(:,2);
% [~,min_ind]=min(pp_prem);
% model=pp_prem(min_ind-time_fore:min_ind+time_lap);
% 
% [t_p,amp_p,ind_p]=corr_t_amp(model,pp_prem,2)
% 
% figure;plot(prems.out_pp(:,1),pp_prem);
% hold on;plot((0:length(model)-1)/2+t_p,model)
% xlim([150,400]);
% title(strcat('prem\_',pind,':',num2str(t_p),'\_',num2str(amp_p)));

lon_lat=NaN*ones(360*180,6);
ill=0;

for lon=-179.5:179.5
% for lon=0.5:365.5
    for lat=-89.5:89.5
        ill=ill+1;
        lon_lat(ill,1)=lon;
        lon_lat(ill,2)=lat;
    end
end
        
for ill=1:length(lon_lat)
    %         tic;
    ill
    
    lon=lon_lat(ill,1);
    lat=lon_lat(ill,2);
    
    mf=strcat('./wf_eft_4096_',num2str(dist),'/wf_',num2str(lon),'_',num2str(lat),'_.mat');
%     mf=strcat('./wf_hem_eft_',num2str(dist),'/wf_',num2str(lon),'_',num2str(lat),'_.mat');
    load(mf);
    pp_t=out_pp(:,1);
    pp_wf=out_pp(:,2);
    
    %% process
    % filter

    ppwf_fil=filter(b,a,pp_wf);
    
    % cross-correlation
    [t410,amp410,ts410,tp410p,wfp410p,tpp410,wfpp410]=tamp_corr(pp_t',ppwf_fil',th410,thpp,twin,'y');
    [t660,amp660,ts660,tp660p,wfp660p,tpp660,wfpp660]=tamp_corr(pp_t',ppwf_fil',th660,thpp,twin,'y');
    
    %% save result
    lon_lat(ill,3)=t410;
    lon_lat(ill,4)=t660;
    lon_lat(ill,5)=amp410;
    lon_lat(ill,6)=amp660;
    
    %         figure;plot(out_pp(:,1),out_pp(:,2));
    %         hold on;plot((0:length(model)-1)/2+t,model);
    %         xlim([150,400]);
    %         title(strcat(num2str(lon),'\_',num2str(lat),'\_',pind,':',num2str(t),'\_',num2str(amp)));
    
    %         toc;
end

save(['lon_lat',num2str(dist),'.mat'],'lon_lat');

ct=cputime-st
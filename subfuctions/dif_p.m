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

plotok=1;

%% laod earth model
% load prem
load('../earth_model/prem_uneft.mat'); % for prem
prem_cut=cut_model(prem,0,refd);
prem_eft=eft(prem_cut);
prem_cake_eft=gen_cake(prem_eft,min_thick);
em=prem_cake_eft;

% lon=90.5;
% lat=30.5;
% emf=['../earth_model/rem_eft/rem_eft_',num2str(lon),'_',num2str(lat),'_.mat'];
% load(emf);
% em=earth_model;

%% generate input waveform
gauss_mean=gauss/2+50;
gauss_sigma=gauss/6;
[ti,wf,fs]=gen_wf(gauss_mean,gauss_sigma,fs,ln);

%% slowness
ddeg_vec=80:10:140;
res_d=NaN*ones(3,6,length(ddeg_vec));

for iddeg=1:length(ddeg_vec)
    ddeg=ddeg_vec(iddeg);
    
    p_d_vec=zeros(3,1);
    p_d_vec(1)=deg2rayp(ddeg,'PP');
    p_d_vec(2)=deg2rayp(ddeg,'P^410P');
    p_d_vec(3)=deg2rayp(ddeg,'P^660P');
    
    res=NaN*ones(length(p_d_vec),6);
    
    if plotok ~=0, figure; hold on; end
    for i_pd=1:3
        p_d=p_d_vec(i_pd);
        p=raypar_r(p_d,0);
        
        %% compute reflect waveform and filter
%         [pp_t,pp_wf]=ppwf(em,p,wf,fs);
        [pp_t,pp_wf]=ppwf_fast(em,p,wf,fs);
        ppwf_fil=filter(b,a,pp_wf);
        
        % cross-correlation
        thpp=get_thpp(pp_t,ppwf_fil);
        th410=thpp-(deg2ttime(ddeg,'PP')-deg2ttime(ddeg,'P^410P'));
        th660=thpp-(deg2ttime(ddeg,'PP')-deg2ttime(ddeg,'P^660P'));
        
        [t410,amp410,ts410,tp410p,wfp410p,tpp410,wfpp410]=tamp_corr(pp_t,ppwf_fil,th410,thpp,twin,'y');
        [t660,amp660,ts660,tp660p,wfp660p,tpp660,wfpp660]=tamp_corr(pp_t,ppwf_fil,th660,thpp,twin,'y');
        
        res(i_pd,1:2)=[p_d,p];
        res(i_pd,3:4)=[t410,amp410];
        res(i_pd,5:6)=[t660,amp660];
        
        if plotok ~=0
%             % method 1
%             plot(pp_t,ppwf_fil);
            % method 2
            ind_t=find(pp_t==thpp-40);
            plot(pp_t(1:ind_t),ppwf_fil(1:ind_t)*10);
            plot(pp_t(ind_t:end),ppwf_fil(ind_t:end));
        end
    end
    res_d(:,:,iddeg)=res;
    
    %% figure
    if plotok ~= 0
        xlabel('Time (s)');ylabel('Amplitude');
        legend('PP','P410P','P660P');
        xlim([0 300]);
        ylim=get(gca,'YLim');
        plot(pp_t(ind_t)*ones(1,2),ylim,'k--');
        set(gcf,'Position',[0,0,600,500]);
        set(gca,'Xminortick','on','Yminortick','on');
        title(['dist=',num2str(ddeg)]);
    end
    
end

%% plot result
% dTpp-p410p
figure;hold on;
plot(ddeg_vec,reshape(res_d(1,3,:),1,length(ddeg_vec)));
plot(ddeg_vec,reshape(res_d(2,3,:),1,length(ddeg_vec)));
plot(ddeg_vec,reshape(res_d(3,3,:),1,length(ddeg_vec)));

xlabel('Distance (degree)');
ylabel('Differential Time (s)');
legend('PP','P410P','P660P');
title('DT PP-P410P');

% dAp410/pp
figure;hold on;
plot(ddeg_vec,reshape(100*res_d(1,4,:),1,length(ddeg_vec)));
plot(ddeg_vec,reshape(100*res_d(2,4,:),1,length(ddeg_vec)));
plot(ddeg_vec,reshape(100*res_d(3,4,:),1,length(ddeg_vec)));

xlabel('Distance (degree)');
ylabel('Amplitude ratio (%)');
legend('PP','P410P','P660P');
title('Ar P410P/PP');


% dTpp-p660p
figure;hold on;
plot(ddeg_vec,reshape(res_d(1,5,:),1,length(ddeg_vec)));
plot(ddeg_vec,reshape(res_d(2,5,:),1,length(ddeg_vec)));
plot(ddeg_vec,reshape(res_d(3,5,:),1,length(ddeg_vec)));

xlabel('Distance (degree)');
ylabel('Differential Time (s)');
legend('PP','P410P','P660P');
title('DT PP-P660P');

% dAp660/pp
figure;hold on;
plot(ddeg_vec,reshape(100*res_d(1,6,:),1,length(ddeg_vec)));
plot(ddeg_vec,reshape(100*res_d(2,6,:),1,length(ddeg_vec)));
plot(ddeg_vec,reshape(100*res_d(3,6,:),1,length(ddeg_vec)));

xlabel('Distance (degree)');
ylabel('Amplitude ratio (%)');
legend('PP','P410P','P660P');
title('Ar P660P/PP');

%% compute differentail traveltime and amplitude ratio
load prem_res;

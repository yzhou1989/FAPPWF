% single_point_tamp
% measure arrival time and amptidue between PP and PdP based on cross-correlation method
% Yong ZHOU 20180408

%% input parameters
% input the longitude and latitude
% lon=-43.5;lat=47.5; % ocean with sediment
lon=90.5;lat=30.5; % tibet

refd=800; % km
min_thick=5.0; % km

% input waveform
gauss=6;

% fs=4;
fs=4;
% ln=1600;
ln=4096;

% slowness
dis=140; % in degree

switch dis
    case 80
        p_d=8.293;
    case 110
        p_d=7.221;
    case 140
        p_d=6.129;
end

n_order=4;
min_period=15; % s
max_period=75; % s

% width of time window for cross-correlation
lwin=30; %s

%% theoretical arrival time from taup
% at_pp=911.02;
% at_220=865.41;
% at_410=834.89;
% at_660=799.58;
at_pp=1143.93;
at_220=0;
at_410=1062.00;
at_660=1021.01;
de_at=[0,at_pp-at_220,at_pp-at_410,at_pp-at_660];
refat=0;
theo_at=refat-de_at;

%% input waveform
p=raypar(p_d); % ray parameter at refrence depth
% p=raypar_s(p_d,refd);
% for p=0:0.01:0.075
% p=0;

gauss_mean=gauss/2+50;
gauss_sigma=gauss/6;
[ti,wf,fs]=gen_wf(gauss_mean,gauss_sigma,fs,ln);
inp_wf=[ti',wf'];
% wf=wf';
% save('input_wf_.mat','inp_wf');
% figure;plot(inp_wf(:,1),inp_wf(:,2));
% xlabel('Time s')

% hilbert transform
save('inp_wf.txt','inp_wf','-ascii');
system('python gen_hilbert inp_wf.txt');
[th,wfh]=readsac('inp_wf.txt.sac.hilberted');

inp_wfh=[th,wfh];
save('input_wfh.mat','inp_wfh');
th=th';wfh=wfh';

% plot
figure;hold on;
plot(ti,wf);plot(th,wfh);
xlim([-10 100]);
xlabel('Time (s)');ylabel('Amplitude');
legend('orignal','hilberted');

%% load earth model
% load prem

% load('mod_ak135.mat');
% prem=mod_ak135(:,[1,3,4,2]);

load('ek1_ak135.mat');
prem=ek1_ak135(:,[1,3,4,2]);

prem_cut=cut_model(prem,0,refd);
prem_eft=eft(prem_cut);
prem_cake_eft=gen_cake(prem_eft,min_thick);
em=prem_cake_eft;

% load('../earth_model/prem_uneft.mat'); % for prem
% prem_cut=cut_model(prem,0,refd);

% prem_cake_uneft=gen_cake(prem_cut,min_thick);
% em=prem_cake_uneft;
% % model modification
% em(133:end,:)=[];
% em(end,1)=130;
% em=[em;em(end,:)];
% em(end,1)=0;

% prem_eft=eft(prem_cut);
% prem_cake_eft=gen_cake(prem_eft,min_thick);
% em=prem_cake_eft;
% em(end-1,1)=50;

% em=[0,6.0,3.6,2.6];
% em=[4.0,1.50,0,1.0;
%     0.0,5.0,3.0,3.0];
% em=[4.0,1.50,0.5,1.0;
%     0.0,5.0,3.0,3.0];
% em=[4.0,5.0,3.0,3.0;
%     0.0,5.0,3.0,3.0];

% % P660P
% em=...
%     [10,11.4769636905806,6.22460445535871,3.99000000000000;...
%     10,12.0133748465182,6.64926328714261,4.38000000000000;...
%     0,12.0133748465182,6.64926328714261,4.38000000000000];

% em=...
%     [10,10.2700000000000,5.57000000000000,3.99000000000000;...
%     10,10.7500000000000,5.95000000000000,4.38000000000000;...
%     0,10.7500000000000,5.95000000000000,4.38000000000000];

% modfication model
% em(1,1)=sum(em(1:3,1));
% em(2:3,:)=[];

% 
% model modification
% em(144:end,:)=[];
% em(end,1)=146.96;
% em=[em;em(end,:)];
% em(end,1)=0;

% % load special earth model
% emf=strcat('../earth_model/rem/rem_',num2str(lon),'_',num2str(lat),'_.mat');
% load(emf);
% em=earth_model;

reft410=0;reft660=0; 
fn='prem_50';

% plot earth model
eml=cake2line(em);
figure;hold on;
plot(eml(:,1),eml(:,2));
plot(eml(:,1),eml(:,3));
plot(eml(:,1),eml(:,4));
% xlim([0,80]);
legend('Vp','Vs','Rho');
xlabel('Depth (km)');
ylabel('Value');
title(fn);
% save figures
emfn=strcat('em_',fn);
saveas(gcf,strcat(emfn,'.fig'));
saveas(gcf,strcat(emfn,'.png'));
%% compute waveform
[pp_t,pp_wf]=ppwf(em,p,wf,fs);
% [t_p,pp_wf_p]=ppwf(prem_cake_eft,p,wf,fs);
% prem_pp=[t_p',pp_wf_p'];

figure;hold on;
% plot(pp_t,pp_wf+(p/0.01));
plot(pp_t,pp_wf);
xlabel('Time (s)');
ylabel('Amplitude');
xlim([-10,250]);
title(['p=',num2str(p)]);
% title(fn);
% title('unfilter');
% save figures
emfn=strcat('wfuf_',fn); % waveform unfilter
saveas(gcf,strcat(emfn,'.fig'));
saveas(gcf,strcat(emfn,'.png'));

% end

%% filter waveform
[b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass');
% pp_wf_p_fil=filter(b,a,pp_wf_p);
ppwf_fil=filter(b,a,pp_wf);

[~,ind_s]=max(ppwf_fil);
t_p=pp_t-pp_t(ind_s);

figure;hold on;
plot(t_p,ppwf_fil);
title(fn);
% plot(t_p,pp_wf_p);
% plot(t_ue,wf_ue);
% figure;plot(t_p-131.8+3.5,pp_wf_p_fil,'r');
% figure;plot(t_ue-142.5+3.5,wf_pp_fil);hold on;
% legend('eft','uneft','filter');
gca_ylim=get(gca,'YLim');

for i_dis=1:4
    if i_dis==2
        continue;
    else
        plot([theo_at(i_dis),theo_at(i_dis)],gca_ylim,'k--');
    end
end
xlabel('Time (s)');
ylabel('Amplitude');


%% measure time shift and amplitude ratio of PdP and PP
% pwin=lwin*fs;
% 
% point_pp=find(abs(t_p-theo_at(1))<=1/fs);
% point_pp=point_pp(2);
% 
% point_p410p=find(abs(t_p-theo_at(3)-reft410)<=1/fs);
% point_p410p=point_p410p(2);
% 
% point_p660p=find(abs(t_p-theo_at(4)-reft660)<=1/fs);
% point_p660p=point_p660p(2);
% 
% pp_sect=ppwf_fil(point_pp-pwin:point_pp+pwin);
% t_s=t_p(point_pp-pwin:point_pp+pwin);
% 
% p410p_sect=ppwf_fil(point_p410p-pwin:point_p410p+pwin);
% t410_s=t_p(point_p410p-pwin:point_p410p+pwin);
% 
% if point_p660p-pwin<=0
%     p660p_sect=ppwf_fil(1:point_p660p+pwin);
%     t660_s=t_p(1:point_p660p+pwin);
%     disp('Warning: P660P window length modified!');
% else
%     p660p_sect=ppwf_fil(point_p660p-pwin:point_p660p+pwin);
%     t660_s=t_p(point_p660p-pwin:point_p660p+pwin);
% end
% 
% plot(t_s,pp_sect,'r');
% plot(t410_s,p410p_sect,'g');
% plot(t660_s,p660p_sect,'m');
% % save figures
% emfn=strcat('wff_',fn); % waveform filtered
% saveas(gcf,strcat(emfn,'.fig'));
% saveas(gcf,strcat(emfn,'.png'));
% 
% [t410,amp410]=corr_t_amp(p410p_sect,pp_sect,fs);
% t410=t410+reft410;
% [t660,amp660]=corr_t_amp(p660p_sect,pp_sect,fs);
% t660=t660+reft660;
% 
% reft410=t410;reft660=t660;

[t410,amp410]=tamp_corr(t_p,ppwf_fil,theo_at(3),0,lwin);
[t660,amp660]=tamp_corr(t_p,ppwf_fil,theo_at(4),0,lwin);

tamp=[t410,t660,amp410,amp660]

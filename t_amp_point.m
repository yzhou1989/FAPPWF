% t_amp_point
% measure arrival time and amptidue between PP and PdP based on cross-correlation method
% Yong ZHOU 20180321

%% input parameters
% input the longitude and latitude
% lon=-43.5;lat=47.5; % ocean with sediment
lon=90.5;lat=30.5; % tibet

refd=800; % km
min_thick=5; % km

% input waveform
gauss=6;

fs=4;
% ln=1600;
ln=3200;

p_d=8.293; %s/degree 80
% p_d=8.091;
% p_d=7.880;
% p_d=7.221; %s/degree 110
% p_d=6.129; %s/degree 140

n_order=4;
min_period=15; % s
max_period=75; % s

% halfwidht of time window for cross-correlation
lwin=20; %s

%% theoretical arrival time from taup
at_pp=911.02;
at_220=865.41;
at_410=834.89;
at_660=799.58;
de_at=[0,at_pp-at_220,at_pp-at_410,at_pp-at_660];
refat=0;
theo_at=refat-de_at;

%% input waveform
p=raypar(p_d); % ray parameter at refrence depth
% p=raypar_s(p_d,refd);

gauss_mean=gauss/2;
gauss_sigma=gauss/6;
[ti,wf,fs]=gen_wf(gauss_mean,gauss_sigma,fs,ln);
inp_wf=[ti',wf'];
% save('input_wf_.mat','inp_wf');
% figure;plot(inp_wf(:,1),inp_wf(:,2));
% xlabel('Time s')

%% load earth model
% load prem
load('../earth_model/prem_uneft.mat'); % for prem
prem_cut=cut_model(prem,0,refd);
prem_cake_uneft=gen_cake(prem_cut,min_thick);
em=prem_cake_uneft;

tmp_prem=em(2:3,:);
tmp_prem_1=sum(tmp_prem)./2;
tmp_prem_1(1)=2*tmp_prem_1(1);

em=[em(1,:);tmp_prem_1;em(4:end,:)];

% thickness of ocean
% em(1,:)=[];

i_ocean=0;
i_crust=0;

ocean_thk_vec=0:2:10;
crust_thk_vec=0:10:70;
% datebase initialization
tamp_db=NaN*ones(length(ocean_thk_vec),length(crust_thk_vec),4);
% load tamp_db;

for i_ocean=1:length(ocean_thk_vec)
reft410=0;reft660=0;
% thickness of crust
for i_crust=1:length(crust_thk_vec)

ocean_thk=ocean_thk_vec(i_ocean);
crust_thk=crust_thk_vec(i_crust);
    
em(1,1)=ocean_thk; % 2 4 6 8 10
em(2,1)=crust_thk;

fn=strcat('o',num2str(ocean_thk),'c',num2str(crust_thk));

% em(2,1)=10; % 10 20 30 40 50 60 70

% prem_eft=eft(prem_cut);
% prem_cake_eft=gen_cake(prem_eft,min_thick);
% em=prem_cake_eft;

% % load special earth model
% emf=strcat('../earth_model/rem/rem_',num2str(lon),'_',num2str(lat),'_.mat');
% load(emf);
% em=earth_model;

% plot earth model
eml=cake2line(em);
figure;hold on;
plot(eml(:,1),eml(:,2));
plot(eml(:,1),eml(:,3));
plot(eml(:,1),eml(:,4));
xlim([0,80]);
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
plot(pp_t,pp_wf);
title('unfilter');
xlabel('Time (s)');
ylabel('Amplitude');
title(fn);
% save figures
emfn=strcat('wfuf_',fn); % waveform unfilter
saveas(gcf,strcat(emfn,'.fig'));
saveas(gcf,strcat(emfn,'.png'));

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

for i_dis=1:4
    plot([theo_at(i_dis),theo_at(i_dis)],[-0.1,0.1],'k--');
end
xlabel('Time (s)');
ylabel('Amplitude');


%% measure time shift and amplitude ratio of PdP and PP
pwin=lwin*fs;

point_pp=find(abs(t_p-theo_at(1))<=1/fs);
point_pp=point_pp(2);

point_p410p=find(abs(t_p-theo_at(3)-reft410)<=1/fs);
point_p410p=point_p410p(2);

point_p660p=find(abs(t_p-theo_at(4)-reft660)<=1/fs);
point_p660p=point_p660p(2);

pp_sect=ppwf_fil(point_pp-pwin:point_pp+pwin);
t_s=t_p(point_pp-pwin:point_pp+pwin);

p410p_sect=ppwf_fil(point_p410p-pwin:point_p410p+pwin);
t410_s=t_p(point_p410p-pwin:point_p410p+pwin);

if point_p660p-pwin<=0
    p660p_sect=ppwf_fil(1:point_p660p+pwin);
    t660_s=t_p(1:point_p660p+pwin);
    disp('Warning: P660P window length modified!');
else
    p660p_sect=ppwf_fil(point_p660p-pwin:point_p660p+pwin);
    t660_s=t_p(point_p660p-pwin:point_p660p+pwin);
end

plot(t_s,pp_sect,'r');
plot(t410_s,p410p_sect,'g');
plot(t660_s,p660p_sect,'m');
% save figures
emfn=strcat('wff_',fn); % waveform filtered
saveas(gcf,strcat(emfn,'.fig'));
saveas(gcf,strcat(emfn,'.png'));

[t410,amp410]=corr_t_amp(p410p_sect,pp_sect,fs);
t410=t410+reft410;
[t660,amp660]=corr_t_amp(p660p_sect,pp_sect,fs);
t660=t660+reft660;

reft410=t410;reft660=t660;

tamp=[t410,t660,amp410,amp660];

% save to database
tamp_db(i_ocean,i_crust,1)=t410;
tamp_db(i_ocean,i_crust,2)=t660;
tamp_db(i_ocean,i_crust,3)=amp410;
tamp_db(i_ocean,i_crust,4)=amp660;

save tamp_db.mat tamp_db;

close all;

end

end
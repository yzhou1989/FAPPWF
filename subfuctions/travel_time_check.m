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
% load prem
load('../earth_model/prem_uneft.mat'); % for prem
prem_cut=cut_model(prem,0,refd);
prem_eft=eft(prem_cut);
prem_cake_eft=gen_cake(prem_eft,min_thick);
em=prem_cake_eft;
% em(1,:)=[];
% em=[[3,3,2,2];em];

% lon=-173.5; % 90.5 for Tibet
% lat=-19.5;
% emf=['../earth_model/rem_eft/rem_eft_',num2str(lon),'_',num2str(lat),'_.mat'];
% load(emf);
% em=earth_model;

plot_thk(em);

%% generate input waveform
gauss_mean=gauss/2+50;
gauss_sigma=gauss/6;
[ti,wf,fs]=gen_wf(gauss_mean,gauss_sigma,fs,ln);

%% slowness
ddeg=110;
p=raypar_r(deg2rayp(ddeg,'PP'),0);

[pp_t,pp_wf]=ppwf_fast(em,p,wf,fs);
ppwf_fil=filter(b,a,pp_wf);

th660=82.50;
th410=123.75;

% % cross-correlation
thpp=get_thpp(pp_t,ppwf_fil);
% th410=thpp-(deg2ttime(ddeg,'PP')-deg2ttime(ddeg,'P^410P'));
% th660=thpp-(deg2ttime(ddeg,'PP')-deg2ttime(ddeg,'P^660P'));
% 
[t410,amp410]=tamp_corr_2(pp_t,ppwf_fil,ppwf_fil,th410,thpp,twin,'y');
[t660,amp660]=tamp_corr_2(pp_t,ppwf_fil,ppwf_fil,th660,thpp,twin,'y');

% figure;plot(pp_t,ppwf_fil);
% figure;plot(pp_t,pp_wf);
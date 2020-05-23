%% parameters
refd=800; % km
min_thick=5.0;

gauss=6;

fs=4;
ln=4096;

%% laod earth model
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
ddeg=110;
p=raypar_r(deg2rayp(ddeg,'P^660P'),0);

%% compute reflect waveform and filter
[pp_t,pp_wf]=ppwf_fast(em,p,wf,fs);

figure; hold on;
plot(pp_t,pp_wf);
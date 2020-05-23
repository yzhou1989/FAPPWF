% generate input waveform
gauss=6;

fs=4;
ln=4096;

gauss_mean=gauss/2+50;
gauss_sigma=gauss/6;
[ti,wf,fs]=gen_wf(gauss_mean,gauss_sigma,fs,ln);

% slowness
dis=110; % in degree

switch dis
    case 80
        p_d=8.293;
    case 110
        p_d=7.221;
    case 140
        p_d=6.129;
end
    
p=raypar(p_d);

% compute reflect waveform
tic
refd=800; % km
min_thick=5.0;

load('../earth_model/prem_uneft.mat'); % for prem
prem_cut=cut_model(prem,0,refd);
prem_eft=eft(prem_cut);
prem_cake_eft=gen_cake(prem_eft,min_thick);
em=prem_cake_eft;

tmp_prem=em(2:3,:);
tmp_prem_1=sum(tmp_prem)./2;
tmp_prem_1(1)=2*tmp_prem_1(1);
em=[em(1,:);tmp_prem_1;em(4:end,:)];

crust=7;
% crust=10;
em(2,1)=crust;

n_order=4;
min_period=15; % s
max_period=75; % s

ocean_vek=0:1:8;

p1=figure;hold on;
p2=figure;hold on;
p3=figure;hold on;
p4=figure;hold on;

tamp_tmp=size(length(ocean_vek),4);

for i_ocean=1:length(ocean_vek)
   ocean=ocean_vek(i_ocean);
   em(1,1)=ocean;
   [pp_t,pp_wf]=ppwf(em,p,wf,fs);
   % p1
   figure(p1);
   plot(pp_t,pp_wf);
   % p2
   figure(p2);
   plot(pp_t,pp_wf+0.6*ocean/2);
   % p3
   [b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass');
   ppwf_fil=filter(b,a,pp_wf);
   figure(p3);
   plot(pp_t,ppwf_fil);
   % p4
   figure(p4);
   plot(pp_t,ppwf_fil+0.6*ocean/2);
   % t_amp
   twin=30;
%    t410=68.5;
%    t660=31;
%    tpp=138.75;
   t660=81;
   t410=120.8;
%    tpp=202.2;
   tpp=get_thpp(pp_t,ppwf_fil)
   [t410,amp410]=tamp_corr(pp_t,ppwf_fil,t410,tpp,twin,'y');
   [t660,amp660]=tamp_corr(pp_t,ppwf_fil,t660,tpp,twin,'y');
   
   tamp_tmp(i_ocean,1)=t410;
   tamp_tmp(i_ocean,2)=t660;
   tamp_tmp(i_ocean,3)=amp410;
   tamp_tmp(i_ocean,4)=amp660;
end

figure;hold on;
plot(ocean_vek,tamp_tmp(:,1));
plot(ocean_vek,tamp_tmp(:,2));
figure;hold on;
plot(ocean_vek,tamp_tmp(:,3));
plot(ocean_vek,tamp_tmp(:,4));
% %% generate input waveform
% tic

figure;
hold on;

gauss_vec=[3,6,10];
for gauss_ind=1:3
gauss=gauss_vec(gauss_ind);
    
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

% earthmodel='pem_-38.5_83.5';
load('prem.mat');
earth_model=prem;

load('../earth_model/prem_uneft.mat'); % for prem
prem_cut=cut_model(prem,0,refd);
prem_eft=eft(prem_cut);
prem_cake_eft=gen_cake(prem_eft,min_thick);
em=prem_cake_eft;

[pp_t,pp_wf]=ppwf(em,p,wf,fs);
pp_t=pp_t';
pp_wf=pp_wf';

n_order=4;
min_period=15; % s
max_period=75; % s
[b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass');
ppwf_fil=filter(b,a,pp_wf);

% width of time window for cross-correlation
twin=30; %s

switch gauss
    case 3
        thpp=199.8;
        th410=119.2;
        th660=79.5;
    case 6
        thpp=201.2;
        th410=120.8;
        th660=81;
    case 10
        thpp=203.2;
        th410=123;
        th660=83;
end

% cross-correlation
[t410,amp410,ts410,tp410p,wfp410p,tpp410,wfpp410]=tamp_corr(pp_t',ppwf_fil',th410,thpp,twin,'y');
[t660,amp660,ts660,tp660p,wfp660p,tpp660,wfpp660]=tamp_corr(pp_t',ppwf_fil',th660,thpp,twin,'y');

% plot
ind_p=560;
t_p=pp_t-thpp;
ppwf_fil_p=ppwf_fil./max(abs(ppwf_fil));

[t_p,ppwf_fil_p]=cut_seismogram(t_p,ppwf_fil_p,-165,30);

plot(t_p(1:ind_p),ppwf_fil_p(1:ind_p)*10+gauss_ind,'k');
plot(t_p(ind_p+1:end),ppwf_fil_p(ind_p+1:end)+gauss_ind,'k');
text(-140,gauss_ind-0.3,[num2str(t410),' s/',num2str(amp410*100),'%']);
text(-140,gauss_ind-0.5,[num2str(t660),' s/',num2str(amp660*100),'%']);
xlim([-160 30]);
ylim([0 4]);

end

plot([-25 -25],[0 4],'k--');
xlabel('Time to PP (s)');
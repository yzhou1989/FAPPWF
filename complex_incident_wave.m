%% parameters
refd=800; % km
min_thick=5.0;

gauss=6;

fs=4;
ln=4096;

t_range=[-200,600];

% ddeg=140;

n_order=4;
min_period=15; % s
max_period=75; % s
[b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass'); % parameters for filter

twin=30; %s width of time window for cross-correlation

th660=82.50;
th410=123.75;
thpp=205.75;

%% laod earth model
% load prem
load('../earth_model/prem_uneft.mat'); % for prem
prem_cut=cut_model(prem,0,refd);
prem_eft=eft(prem_cut);
prem_cake_eft=gen_cake(prem_eft,min_thick);
em=prem_cake_eft;

%% generate input waveform
gauss_mean=gauss/2+50;
gauss_sigma=gauss/6;
[ti,wf1,fs]=gen_wf(gauss_mean,gauss_sigma,fs,ln);

wf2=wf1;
wfadd=wf1(150:300)*0.4;
ts=162;
wf2(ts:ts+length(wfadd)-1)=wf2(ts:ts+length(wfadd)-1)+wfadd;
wf2=wf2./max(abs(wf2));

f='/home/yzhou/Documents/PP_waveform_synthesis/src-clean/earthquake_waveform/2000-12-06_Mw7.0_Turkmenistan/IC.SSE.00.BHZ.M.2000.341.171523.SAC.transed';
[t,s]=readsac(f);

tsind=find(abs(t-548.7)<0.05);
teind=find(abs(t-608.7)<0.05);

sc=s(tsind(1):teind(1));
sc=-sc./max(abs(sc));
sc=sc(1:20:end);
hamming_win=hamming(length(sc));
sch=sc.*hamming_win;

wfr=wf1;

wfr(200-17:200+length(sch)-1-17)=sch;

figure;hold on;
plot(ti-53,wf1,'k');
plot(ti-53,wf2,'b');
plot(ti-53,wfr,'r');
xlabel('Time (s)');ylabel('Normalized amplitude');
xlim([-30,30]);
legend('Gauss function','Two Gauss function','Observed P wave');
legend('boxoff','on');
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');

wfinc={wf1;wf2;wfr};
wfref=cell(3,6);

%%
ddeg=110;
p=raypar_r(deg2rayp(ddeg,'P^660P'),0);

for i_c=1:length(wfinc)
    
    wf=wfinc{i_c};
    [pp_t,pp_wf]=ppwf_fast(em,p,wf,fs);
    ppwf_fil=filter(b,a,pp_wf);
    
    [t410,amp410]=tamp_corr_2(pp_t,ppwf_fil,ppwf_fil,th410,thpp,twin,'y');
    [t660,amp660]=tamp_corr_2(pp_t,ppwf_fil,ppwf_fil,th660,thpp,twin,'y');
    
    % shift
    [~,ind_t]=max(ppwf_fil);
    t_p=pp_t-pp_t(ind_t);
    
    [tpp,wfpp]=shift_pp(t_p,ppwf_fil,0,t_range);
    
    wfref{i_c,1}=tpp;
    wfref{i_c,2}=wfpp./max(abs(wfpp));
    wfref{i_c,3}=t410;
    wfref{i_c,4}=amp410;
    wfref{i_c,5}=t660;
    wfref{i_c,6}=amp660;
    
end

%%
figure;hold on;
% for i_c=1:length(wfinc)
%     plot(wfref{i_c,1},wfref{i_c,2});
% end
plot(wfref{1,1},wfref{1,2},'k');
plot(wfref{2,1},wfref{2,2},'b');
plot(wfref{3,1},wfref{3,2},'r');

xlim([-210 50]);
xlabel('Time (s)');ylabel('Normalized amplitude');
legend('Gauss function','Two Gauss function','Observed P wave');
legend('boxoff','on');
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
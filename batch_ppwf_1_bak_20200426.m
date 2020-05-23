% %% generate input waveform
% tic
gauss=6;

fs=4;
ln=4096;

gauss_mean=gauss/2+50;
gauss_sigma=gauss/6;
[ti,wf,fs]=gen_wf(gauss_mean,gauss_sigma,fs,ln);
% inp_wf=[ti',wf'];
% save(strcat('./wf_eft_',num2str(dis),'/input_wf_.mat'),'inp_wf');
% toc

%% read input waveform
% [ti,wf]=readsac('inp_wf.txt.sac.hilberted');
% ti=ti';
% wf=wf';
% fs=1/(ti(2)-ti(1));

%% slowness
dis=80; % in degree
p=raypar_r(deg2rayp(dis,'P^660P'),0);

%% compute reflect waveform
% tic
% refd=800; % km
% min_thick=5.0;
% 
% % earthmodel='pem_-38.5_83.5';
% load('prem.mat');
% earth_model=prem;
% 
% load('../earth_model/prem_uneft.mat'); % for prem
% prem_cut=cut_model(prem,0,refd);
% prem_eft=eft(prem_cut);
% prem_cake_eft=gen_cake(prem_eft,min_thick);
% em=prem_cake_eft;
% 
% [t,pp_wf]=ppwf(em,p,wf,fs);
% out_pp=[t',pp_wf'];
% save(strcat('pp_prem','_.mat'),'out_pp');
% toc

%% compute reflect waveform with global model
list=dir('../earth_model/rem_eft/*.mat');
% list=dir('./hem_eft/*.mat');
% for i_model=1:10800 %length(list)
for i_model=1:length(list)
    tic
    disp(strcat(num2str(i_model),'/',num2str(length(list))));
    ff=fullfile(list(i_model).folder,list(i_model).name);
    load(ff);
    [t,pp_wf]=ppwf(earth_model,p,wf,fs);
    
    out_pp=[t',pp_wf'];
    save(strcat('./wf_rem_eft_660_20200426_',num2str(dis),'/wf_',num2str(lon),'_',num2str(lat),'_.mat'),...
        'out_pp','lon','lat');
    toc
end

%% plot_figure
% tic
% figure;hold on;
% plot(ti,wf);
% toc
% plot(t,pp_wf);
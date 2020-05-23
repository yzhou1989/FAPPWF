%% generate input waveform
gauss=6;

fs=4;
ln=4096;

gauss_mean=gauss/2+50;
gauss_sigma=gauss/6;
[ti,wf,fs]=gen_wf(gauss_mean,gauss_sigma,fs,ln);

%% slowness
dis=80; % in degree
p=raypar_r(deg2rayp(dis,'P^660P'),0);

%% compute reflect waveform with global model
list=dir('../earth_model/rem_eft/*.mat');
% list=dir('./hem_eft/*.mat');
for i_model=32401:43200 %length(list)
% for i_model=1:length(list)
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
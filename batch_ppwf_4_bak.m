%% generate input waveform
tic
gauss=6;

fs=2;
ln=1600;

gauss_mean=gauss/2;
gauss_sigma=gauss/6;

[wf,fs,ti]=gen_wf(gauss_mean,gauss_sigma,fs,ln);
inp_wf=[ti',wf'];
save('input_wf_.mat','inp_wf');
toc

%% compute reflect waveform
tic
% earthmodel='pem_-38.5_83.5';
load('prem.mat');
earth_model=prem;
p=0.075;

[t,pp_wf]=ppwf(earth_model,p,wf,fs);
out_pp=[t',pp_wf'];
save(strcat('pp_prem','_.mat'),'out_pp');
toc

%% compute reflect waveform with global model
list=dir('../earth_model/pem/*.mat');
for i_model=32401:43200 %length(list)
    tic
    disp(i_model);
    ff=fullfile(list(i_model).folder,list(i_model).name);
    load(ff);
    [t,pp_wf]=ppwf(earth_model,p,wf,fs);
    
    out_pp=[t',pp_wf'];
    save(strcat('./pp_wf_0075/pp_',num2str(lon),'_',num2str(lat),'_.mat'),...
        'out_pp','lon','lat');
    toc
end

%% plot_figure
% tic
% figure;hold on;
% plot(ti,wf);
% toc
% plot(t,pp_wf);
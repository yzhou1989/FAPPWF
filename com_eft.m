%% input waveform
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

%% prem
tic;

load prem_uneft;
earth_model=gen_cake(prem,5);
p=0.0605; % s/km

[t,pp_wf]=ppwf(earth_model,p,wf,fs);

toc

%% prem_eft

prem_eft=eft(prem);
earth_model_eft=gen_cake(prem_eft,5);

p=0.0605; % s/km

[t_eft,pp_wf_eft]=ppwf(earth_model_eft,p,wf,fs);

toc

%% plot

figure;
plot(t,pp_wf);
hold on;
plot(t_eft,pp_wf_eft,'r');
legend('uneft','eft');
xlabel('Time (s)');
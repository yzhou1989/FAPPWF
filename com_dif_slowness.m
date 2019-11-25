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

%% PP
tic;

refdep=800;

load prem_uneft;
cp=cut_model(prem,refdep);
earth_model=gen_cake(cp,5);

p_pp=8.293; % s/degree
p=raypar(p_pp,refdep)

[pp_t,pp_wf]=ppwf(earth_model,p,wf,fs);

toc

%% P410P
tic;

p_p410p=8.091; % s/degree
p=raypar(p_p410p,refdep)

[p410p_t,p410p_wf]=ppwf(earth_model,p,wf,fs);

toc

%% P660P
tic;

p_p660p=7.880; % s/degree
p=raypar(p_p660p,refdep)

[p660p_t,p660p_wf]=ppwf(earth_model,p,wf,fs);

toc
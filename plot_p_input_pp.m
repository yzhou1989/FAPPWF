% load input waveform from axisem
load p_cut_deg.mat;

fs=4;
%% 3. load model
refd=800; % km
min_thick=5.0;

load('../earth_model/prem_uneft.mat'); % for prem
prem_cut=cut_model(prem,0,refd);
prem_eft=eft(prem_cut);
prem_cake_eft=gen_cake(prem_eft,min_thick);
em=prem_cake_eft;

% filter parameters
n_order=4;
min_period=15; % s
max_period=75; % s

[b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass');

%%
n_d=size(p_cut_deg,1);
ppwf_input_axisem_p=cell(n_d,4);

for i_d=1:n_d
    deg=p_cut_deg{i_d,1};
    rayp=p_cut_deg{i_d,2};
    p=raypar(rayp);
    wf=p_cut_deg{i_d,4};
    wf=wf./max(abs(wf));
    [t,pp_wf]=ppwf(em,p,wf,fs);
    
    ppwf_input_axisem_p{i_d,1}=deg*2;
    ppwf_input_axisem_p{i_d,2}=p;
    ppwf_input_axisem_p{i_d,3}=t;
    ppwf_input_axisem_p{i_d,4}=pp_wf;
end

%% plot
figure;
hold on;
coef=5;
for i_d=1:n_d
    deg=ppwf_input_axisem_p{i_d,1};
    t=ppwf_input_axisem_p{i_d,3};
    pp_wf=ppwf_input_axisem_p{i_d,4};
    
    % filter
    ppwf_fil=filter(b,a,pp_wf);
    
    plot(t,ppwf_fil*coef+deg,'k');
end
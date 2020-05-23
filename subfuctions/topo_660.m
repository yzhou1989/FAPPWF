gauss_topo=10;
fs_topo=100;
ln_topo=1001;

gauss_mean=gauss_topo/2+0;
gauss_sigma=gauss_topo/6;
[ti_topo,wf_topo,fs_topo]=gen_wf(gauss_mean,gauss_sigma,fs_topo,ln_topo);
wf_topo=660+30*wf_topo;

dis=ti_topo(1:10:end);
topo=wf_topo(1:10:end);

mean_topo=mean(topo);

gauss=6;

fs=4;
ln=4096;

t_range=[-200,600];

gauss_mean=gauss_topo/2+50;
gauss_sigma=gauss_topo/6;
[ti,wf,fs]=gen_wf(gauss_mean,gauss_sigma,fs,ln);

refd=800;
min_thick=5;

ddeg=110;
p=raypar_r(deg2rayp(ddeg,'P^660P'),0);

n_order=4;
min_period=15; % s
max_period=75; % s
[b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass'); % parameters for filter

%%
figure;hold on;
plot(ti_topo,wf_topo);
plot(dis,topo,'ko');
plot([0,10],mean_topo*ones(1,2),'r');
hold off;
xlabel('Distance (degree)');
ylabel('Depth (km)');
title('Topography');
view([0 -90]);

topo_x=[topo,mean_topo];

num_topo=length(topo_x);
wfcell=cell(num_topo,3);

%%
for i_topo=1:num_topo
    
    % load prem
    load('../earth_model/prem_uneft.mat'); % for prem
    prem(22:23,1)=topo_x(i_topo)*ones(2,1);
    prem_cut=cut_model(prem,0,refd);
    prem_eft=eft(prem_cut);
    prem_cake_eft=gen_cake(prem_eft,min_thick);
    em=prem_cake_eft;
    
    % generate input waveform
    [pp_t,pp_wf]=ppwf_fast(em,p,wf,fs);
    ppwf_fil=filter(b,a,pp_wf);
    
    %shift
    [~,ind_t]=max(ppwf_fil);
    t_p=pp_t-pp_t(ind_t);
    
    [tpp,wfpp]=shift_pp(t_p,ppwf_fil,0,t_range);
    
    wfcell{i_topo,1}=tpp;
    wfcell{i_topo,2}=pp_wf;
    wfcell{i_topo,3}=wfpp;
    
end
wf_stack=sum(cell2mat(wfcell(1:end-1,3)))./(size(wfcell,1)-1);

%%
tind=-30;
ind_t=find(tpp==tind);

figure;hold on;
for i_topo=1:num_topo-1
    plot(wfcell{i_topo,1}(1:ind_t),wfcell{i_topo,3}(1:ind_t)*20+i_topo*1,'k');
    plot(wfcell{i_topo,1}(ind_t:end),wfcell{i_topo,3}(ind_t:end)*2+i_topo*1,'k');
end

plot(tpp(1:ind_t),wf_stack(1:ind_t)*20+12*1,'k');
plot(tpp(ind_t:end),wf_stack(ind_t:end)*2+12*1,'k');

plot(wfcell{end,1}(1:ind_t),wfcell{end,3}(1:ind_t)*20+12*1,'r');
plot(wfcell{end,1}(ind_t:end),wfcell{end,3}(ind_t:end)*2+12*1,'r');

ylim=get(gca,'YLim');
plot([tind,tind],ylim,'k--');

xlim([-210,30]);
xlabel('Time (s)');
ylabel('');

%%
tind=-30;
ind_t=find(tpp==tind);

figure;hold on;
for i_topo=1:num_topo-1
    plot(wfcell{i_topo,1}(1:ind_t),wfcell{i_topo,3}(1:ind_t)*20,'color',[0.5,0.5,0.5]);
    plot(wfcell{i_topo,1}(ind_t:end),wfcell{i_topo,3}(ind_t:end)*2,'color',[0.5,0.5,0.5]);
end

plot(tpp(1:ind_t),wf_stack(1:ind_t)*20,'k');
plot(tpp(ind_t:end),wf_stack(ind_t:end)*2,'k');

plot(wfcell{end,1}(1:ind_t),wfcell{end,3}(1:ind_t)*20,'r');
plot(wfcell{end,1}(ind_t:end),wfcell{end,3}(ind_t:end)*2,'r');

ylim=get(gca,'YLim');
plot([tind,tind],ylim,'k--');

xlim([-210,30]);
xlabel('Time (s)');
ylabel('');
% plot_stack
%
% Yong ZHOU
% 2017-12-29

load stack_global.mat
g_ts=ts;
ps=ps./max(abs(ps));
g_ps=ps;

load regionA.mat
a_ts=ts;
ps=ps./max(abs(ps));
a_ps=ps;

load regionB.mat
b_ts=ts;
ps=ps./max(abs(ps));
b_ps=ps;

load regionC.mat
c_ts=ts;
ps=ps./max(abs(ps));
c_ps=ps;

load regionD.mat
d_ts=ts;
ps=ps./max(abs(ps));
d_ps=ps;

pind='0055';
time_fore=20;
time_lap=10;

premf=strcat('pp_prem_',pind,'_.mat');
prems=load(premf);
pp_prem=prems.out_pp(:,2);
[~,min_ind]=min(pp_prem);
model=pp_prem(min_ind-time_fore:min_ind+time_lap);

[t_p,amp_p,ind_p]=corr_t_amp(model,pp_prem,2);
[g_t,~,~]=corr_t_amp(model,g_ps,2);
[a_t,~,~]=corr_t_amp(model,a_ps,2);
[b_t,~,~]=corr_t_amp(model,b_ps,2);
[c_t,~,~]=corr_t_amp(model,c_ps,2);
[d_t,~,~]=corr_t_amp(model,d_ps,2);

% figure;hold on;plot(g_ts,g_ps);plot((0:length(model)-1)/2+g_t+min(g_ts),model);
% figure;hold on;plot(a_ts,a_ps);plot((0:length(model)-1)/2+a_t+min(a_ts),model);
% figure;hold on;plot(b_ts,b_ps);plot((0:length(model)-1)/2+b_t+min(b_ts),model);
% figure;hold on;plot(c_ts,c_ps);plot((0:length(model)-1)/2+c_t+min(c_ts),model);
% figure;hold on;plot(d_ts,d_ps);plot((0:length(model)-1)/2+d_t+min(d_ts),model);

t_min=0;
t_max=800;

[gs_t,gs_pp]=shift_pp(g_ts,g_ps,t_p-g_t-min(g_ts),[t_min t_max]);
[as_t,as_pp]=shift_pp(a_ts,a_ps,t_p-a_t-min(a_ts),[t_min t_max]);
[bs_t,bs_pp]=shift_pp(b_ts,b_ps,t_p-b_t-min(b_ts),[t_min t_max]);
[cs_t,cs_pp]=shift_pp(c_ts,c_ps,t_p-c_t-min(c_ts),[t_min t_max]);
[ds_t,ds_pp]=shift_pp(d_ts,d_ps,t_p-d_t-min(d_ts),[t_min t_max]);

[t_sh,~,~]=corr_t_amp(model,gs_pp,2);
[~,t_ind]=min(model);
t_ind=t_ind/2;
t_sh=t_sh+t_ind;
% figure;hold on;plot(gs_t,gs_pp);plot((0:length(model)-1)/2+t_sh+min(gs_t),model);

figure;hold on;
plot(gs_t-t_sh,gs_pp+0.0,'black');
plot(as_t-t_sh,as_pp+0.0,'red');
plot(bs_t-t_sh,bs_pp+0.0,'blue');
plot(cs_t-t_sh,cs_pp+0.0,'cyan');
plot(ds_t-t_sh,ds_pp+0.0),'m';
legend('global','regionA','regionB','regionC','regionD');
legend('boxoff','on');
% xlim([-200,-40]);

figure;hold on;
plot(gs_t-t_sh,gs_pp+0.0,'black');
plot(as_t-t_sh,as_pp+0.1,'red');
plot(bs_t-t_sh,bs_pp+0.2,'blue');
plot(cs_t-t_sh,cs_pp+0.3,'cyan');
plot(ds_t-t_sh,ds_pp+0.4,'magenta');
% legend('global','regionA','regionB','regionC','regionD');
y_sh=0.02;
text(-200,0+y_sh,'global');
text(-200,0.1+y_sh,'regionA');
text(-200,0.2+y_sh,'regionB');
text(-200,0.3+y_sh,'regionC');
text(-200,0.4+y_sh,'regionD');
% xlim([-200,-40]);

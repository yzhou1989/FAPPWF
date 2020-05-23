[~,ind_ts]=max(wf);
ts=ti(ind_ts);

[dt410,dt660,atpp,at410,at660]=travel_time_ray_theory_point(em,p);

%%
figure;hold on;
plot(pp_t,pp_wf);
ylim=get(gca,'YLim');
plot(ts+atpp*ones(1,2),ylim,'--');
plot(ts+at410*ones(1,2),ylim,'--');
plot(ts+at660*ones(1,2),ylim,'--');
xlim([0 300]);
xlabel('Time (s)');ylabel('Amplitude');

%%
ind_660=find(pp_t==105);
[~,ind_ts2]=max(ppwf_fil(1:ind_660));
ts2=pp_t(ind_ts2);

figure;hold on;
plot(pp_t,ppwf_fil);
ylim=get(gca,'YLim');
plot(ts2*ones(1,2),ylim,'--');
plot(ts2+dt660-dt410*ones(1,2),ylim,'--');
plot(ts2+dt660*ones(1,2),ylim,'--');
xlim([0 300]);
xlabel('Time (s)');ylabel('Amplitude');
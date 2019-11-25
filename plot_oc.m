ocean=4;
em(1,1)=ocean;

n_order=4;
min_period=15; % s
max_period=75; % s

crust_vek=0:10:80;

figtit=strcat('ocean\_thk=',num2str(ocean),'km');

p1=figure;hold on;title(figtit);xlabel('Time (s)');
p2=figure;hold on;title(figtit);xlabel('Time (s)');
p3=figure;hold on;title(figtit);xlabel('Time (s)');
p4=figure;hold on;title(figtit);xlabel('Time (s)');

tamp_tmp=size(length(crust_vek),4);

for i_crust=1:length(crust_vek)
   crust=crust_vek(i_crust);
   em(2,1)=crust;
   [pp_t,pp_wf]=ppwf(em,p,wf,fs);
   % p1
   figure(p1);
   plot(pp_t,pp_wf);
   % p2
   figure(p2);
   plot(pp_t,pp_wf+0.6*crust/10);
   % p3
   [b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass');
   ppwf_fil=filter(b,a,pp_wf);
   figure(p3);
   plot(pp_t,ppwf_fil);
   % p4
   figure(p4);
   plot(pp_t,ppwf_fil+0.6*crust/10);
   twin=30;
   t410=68.5;
   t660=31;
%    tpp=138.75;
   [tpp_max,tpp_ind]=max(ppwf_fil);
   tpp=pp_t(tpp_ind);
   plot([tpp,tpp],[-0.3+0.6*crust/10,0.3+0.6*crust/10]);
   
   [t410,amp410]=tamp_corr(pp_t,ppwf_fil,t410,tpp,twin);
   [t660,amp660]=tamp_corr(pp_t,ppwf_fil,t660,tpp,twin);
   
   tamp_tmp(i_crust,1)=t410;
   tamp_tmp(i_crust,2)=t660;
   tamp_tmp(i_crust,3)=amp410;
   tamp_tmp(i_crust,4)=amp660;
end

figure;hold on;
plot(crust_vek,tamp_tmp(:,1),'o-');
plot(crust_vek,tamp_tmp(:,2),'o-');
xlabel('Crust thk (km)');
ylabel('time shift (s)');
title(figtit);
legend('PP-P410P','PP-P660P');

figure;hold on;
plot(crust_vek,tamp_tmp(:,3),'o-');
plot(crust_vek,tamp_tmp(:,4),'o-');
xlabel('Crust thk (km)');
ylabel('Amplitude ratio');
title(figtit);
legend('P410P/PP','P660P/PP');
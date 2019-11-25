% plot PdP/PP amplitude ratio with distance
%
% Yong ZHOU
% 20190715

% run deg_time_stack.m with line 1 to 84 to get struct deg_ppwf which
% contains seismic waves. More detail see file deg_time_stack.m
% deg_time_stack;

% paraters
twin=30; % for cross-correlation
thpp=0;

num_dts=size(deg_ppwf,1);
dtm=zeros(num_dts,5);

for i_d=1:num_dts

ddeg=deg_ppwf{i_d,1};
pp_t=deg_ppwf{i_d,3}';
ppwf_fil=deg_ppwf{i_d,4}';

th410=-dt_pp_pdp(ddeg,'P^410P');
th660=-dt_pp_pdp(ddeg,'P^660P');

[t410,amp410,ts410,tp410p,wfp410p,tpp410,wfpp410]=tamp_corr(pp_t',ppwf_fil',th410,thpp,twin,'y');
[t660,amp660,ts660,tp660p,wfp660p,tpp660,wfpp660]=tamp_corr(pp_t',ppwf_fil',th660,thpp,twin,'y');

dtm(i_d,1)=ddeg;
dtm(i_d,2)=t410;
dtm(i_d,3)=amp410;
dtm(i_d,4)=t660;
dtm(i_d,5)=amp660;

end

% plot figures
figure;
hold on;
plot(dtm(:,1),dtm(:,3),'r');
plot(dtm(:,1),dtm(:,5),'k');
xlabel('Distance (degree)');
ylabel('Amplitude ratio');
legend('P410P/PP','P660P/PP');
hold off;
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');

function [dt]=dt_pp_pdp(ddeg,phase_pdp)
% compute differential travel time between PP and PdP
%
% ddeg distance in degree
% phase_pdp 'P^410P' or 'P^660P'
%
% Yong ZHOU
% 2019/07/15

tt_pp=deg2ttime(ddeg,'PP');
tt_pdp=deg2ttime(ddeg,phase_pdp);

dt=tt_pp-tt_pdp;

end
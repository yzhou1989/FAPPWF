figure;hold on;

indp=170*4;

plot(tpp(1:indp),10*wfpp_cph(:,1:indp),'color',[0.5,0.5,0.5]);
plot(tpp(1:indp),10*sum(wfpp_cph(:,1:indp))./size(wfpp_cph,1),'k');

plot(tpp(indp+1:end),wfpp_cph(:,indp+1:end),'color',[0.5,0.5,0.5]);
plot(tpp(indp+1:end),sum(wfpp_cph(:,indp+1:end))./size(wfpp_cph,1),'k');

plot(tpp(1:indp),10*wfpp_cp(:,1:indp)+2,'color',[0.5,0.5,0.5]);
plot(tpp(1:indp),10*sum(wfpp_cp(:,1:indp))./size(wfpp_cph,1)+2,'k');

plot(tpp(indp+1:end),wfpp_cp(:,indp+1:end)+2,'color',[0.5,0.5,0.5]);
plot(tpp(indp+1:end),sum(wfpp_cp(:,indp+1:end))./size(wfpp_cph,1)+2,'k');

plot(tpp(1:indp),10*wfpp_660(:,1:indp)+4,'color',[0.5,0.5,0.5]);
plot(tpp(1:indp),10*sum(wfpp_660(:,1:indp))./size(wfpp_cph,1)+4,'k');

plot(tpp(indp+1:end),wfpp_660(:,indp+1:end)+4,'color',[0.5,0.5,0.5]);
plot(tpp(indp+1:end),sum(wfpp_660(:,indp+1:end))./size(wfpp_cph,1)+4,'k');

xlim([-210,35]);
ylim([-1.5 5.5]);

yLim=get(gca,'YLim');
plot(tpp(indp)*ones(1,2),yLim,'k--');

text(-206,4.6,'PREM+MDT');
text(-206,2.6,'PREM+Crust1.0');
text(-206,0.6,'RREM+Crust1.0+MDT');

twin=30;
t410=-80.4;
t660=-120.2;
t_pp=0;

[t410_660,amp410_660]=tamp_corr(tpp,sum(wfpp_660)./size(wfpp_660,1),t410,t_pp,twin,'y');
[t660_660,amp660_660]=tamp_corr(tpp,sum(wfpp_660)./size(wfpp_660,1),t660,t_pp,twin,'y');

text(-206,3.7,strcat(num2str(t410_660),'/',num2str(amp410_660)));
text(-206,3.4,strcat(num2str(t660_660),'/',num2str(amp660_660)));
plot(-t410_660*ones(1,2),[4-0.8,4+0.8],'k-');
plot(-t660_660*ones(1,2),[4-0.8,4+0.8],'k-');

[t410_cp,amp410_cp]=tamp_corr(tpp,sum(wfpp_cp)./size(wfpp_cp,1),t410,t_pp,twin,'y');
[t660_cp,amp660_cp]=tamp_corr(tpp,sum(wfpp_cp)./size(wfpp_cp,1),t660,t_pp,twin,'y');

text(-206,1.7,strcat(num2str(t410_cp),'/',num2str(amp410_cp)));
text(-206,1.4,strcat(num2str(t660_cp),'/',num2str(amp660_cp)));
plot(-t410_cp*ones(1,2),[2-0.8,2+0.8],'k-');
plot(-t660_cp*ones(1,2),[2-0.8,2+0.8],'k-');

[t410_cph,amp410_cph]=tamp_corr(tpp,sum(wfpp_cph)./size(wfpp_cph,1),t410,t_pp,twin,'y');
[t660_cph,amp660_cph]=tamp_corr(tpp,sum(wfpp_cph)./size(wfpp_cph,1),t660,t_pp,twin,'y');

text(-206,-0.3,strcat(num2str(t410_cph),'/',num2str(amp410_cph)));
text(-206,-0.6,strcat(num2str(t660_cph),'/',num2str(amp660_cph)));
plot(-t410_cph*ones(1,2),[0-0.8,0+0.8],'k-');
plot(-t660_cph*ones(1,2),[0-0.8,0+0.8],'k-');

xlabel('Time (s)');
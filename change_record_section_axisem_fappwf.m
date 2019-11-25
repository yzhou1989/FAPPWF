open record_section_axisem_fappwf.fig

% change color
ac=get(gca,'children');
ac1=ac(1:61,1);
ac2=ac(62:end,1);
set(ac1,'color','r');
set(ac2,'color','k');

xlabel('Time to PP (s)');
ylabel('Distance (^o)');

xlim([-160 20]);
ylim([61 161]);

set(gcf,'Position',[0,0,500,800]);
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');

hold on;

plot([-108,-132],[76,143],'k--');
plot([-74,-88],[76,143],'k--');

text(-140,145,'P660P');
text(-96,145,'P410P');
text(-18,152,'PP');

% legend
% legend('boxoff','on')
% legend('location','north');
% legend('AxiSEM','FAPPWF');

plot([-145,-128],[157,157],'k');
text(-127,157,'AxiSEM');
plot([-145,-128],[154.6,154.6],'r');
text(-127,154.6,'FAPPWF');

hold off;

fn='record_section_axisem_fappwf_color.eps';
print(gcf,'-depsc2','-r1200',fn);
hold on;
xlabel('Time to PP (s)')
plot([-30 -30],[70 150],'k--')
xlim([-160 20])
ylim([75 148])
legend('FAPPWF','AxiSEM');
legend('box','off');
set(gca,'XMinorTick','on');

text(-50,145,'x10')
hold off;
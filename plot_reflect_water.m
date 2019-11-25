% %% generate input waveform
% tic
gauss=2;

fs=10;
ln=4096;

shift=50;

gauss_mean=gauss/2+shift;
gauss_sigma=gauss/6;
[ti,wf,fs]=gen_wf(gauss_mean,gauss_sigma,fs,ln);

p=0;

load water.em;

[pp_t,pp_wf]=ppwf(water,p,wf,fs);

figure;
hold on;
plot(ti-shift-1,wf,'k');
plot(pp_t-shift-1,pp_wf,'r');

xlim([-4 30]);

xlabel('Time (s)');
ylabel('Amplitude');

legend('Incident wave','reflected wave','box','off');
set(gca,'XMinorTick','on')
set(gca,'YMinorTick','on')

set(gcf,'Position',[0,0,300,300]);
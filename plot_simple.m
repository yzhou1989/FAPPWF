% plot_simple
% plot simple figure for ppwf function
%
% Yong ZHOU
% zhouy3@sustc.edu.cn
% 2017-10-21

res_y=y(1:ln/2);
res_t=t(1:ln/2)-gauss_mean;
res_ppwf=real(pp_wf(1:ln/2));

figure;hold on;
plot(res_t,res_y,'k');
plot(res_t,res_ppwf,'r');
xlim([-1-gauss_mean,50]);ylim([-1.1,1.1]);
legend('incident waveform','reflect waveform');
hold off;
legend('boxoff');
xlabel('Time (s)');ylabel('Amplitude');
rem=strrep(em,'_','\_');
title(strcat(rem,'\_',num2str(p),'\_',num2str(gauss_sigma)));

% saveas(gcf,strcat(em,'_',num2str(p),'.fig'));
% print(gcf,strcat(em,'_',num2str(p)),'-depsc');
% saveas(gcf,strcat(em,'_',num2str(p),'.png'));
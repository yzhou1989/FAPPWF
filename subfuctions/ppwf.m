function [t,pp_wf]=ppwf(earth_model,p,wf,fs)
% ppwf
% compute reflected PP waveform
%
% Yong ZHOU
% zhouy3@sustc.edu.cn
% 2017-10-21

% earth_model=load(em);
earth_model=num2cell(earth_model);

% generation of input waveform
% fs=100;
ts=1/fs;
% ln=80000; % ln=8*time_duration*fs. update 20170915
ln=length(wf);
t=(0:ln-1)*ts';

% y=gaussmf(t,[gauss_sigma gauss_mean]);

yf=fft(wf);
omiga=fs/2*linspace(0,1,ln/2+1);

omiga(1)=1e-16;

pprc=NaN*ones(1,size(omiga,2));
for i_omiga=1:length(omiga)
    pprc(i_omiga)=pprcm(p,2*pi*omiga(i_omiga),earth_model);
end

pprc_all=[pprc,pprc(end-1:-1:2)];
ppf=pprc_all.*yf;
ppfm=[ppf(1),conj(ppf(ln:-1:ln/2+2)),ppf(ln/2+1:ln)];

pp_wf=real(ifft(ppfm));

% res_t=t(1:ln/2)-gauss_mean;
% res_ppwf=real(pp_wf(1:ln/2));

% if strcmp(fig_label,'simple') == 1
%     plot_simple;
% end

end
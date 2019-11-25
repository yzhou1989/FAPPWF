function [res_t,res_ppwf]=ppwf(gauss_mean,gauss_sigma,p,em,fig_label)
% ppwf
% compute reflected PP waveform
%
% Yong ZHOU
% zhouy3@sustc.edu.cn
% 2017-10-21

earth_model=load(em);
earth_model=num2cell(earth_model);

% generation of input waveform
fs=100;
ts=1/fs;
ln=8000; % ln=8*time_duration*fs. update 20170915
t=(0:ln-1)*ts;

y=gaussmf(t,[gauss_sigma gauss_mean]);

yf=fft(y);
omiga=fs/2*linspace(0,1,ln/2+1);

omiga_all=[omiga,omiga(end-1:-1:2)];
omiga_all(1)=1e-16;
omiga_used=[omiga(1),omiga_all(ln/2:ln)];

% pprc=NaN*ones(1,size(yf,2));
pprc=NaN*ones(size(omiga_used));
for i_omiga=1:length(omiga_used)
%     pprc(i_omiga)=pprcm(p,2*pi*omiga_all(i_omiga),earth_model);
    pprc(i_omiga)=pprcm(p,2*pi*omiga_used(i_omiga),earth_model);
end

ppf=pprc.*[yf(1),yf(ln/2:ln)];
% ppfm=[ppf(1),conj(ppf(ln:-1:ln/2+2)),ppf(ln/2+1:ln)];
ppfm=[ppf(1),conj(ppf(ln/2:-1:2)),ppf(1:ln/2)];

pp_wf=ifft(ppfm);

res_t=t(1:ln/2)-gauss_mean;
res_ppwf=real(pp_wf(1:ln/2));

if strcmp(fig_label,'simple') == 1
    plot_simple;
end

end
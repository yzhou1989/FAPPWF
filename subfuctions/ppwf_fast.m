function [t,pp_wf]=ppwf_fast(earth_model,p,wf,fs)
% ppwf_fast
% compute reflected PP waveform
%
% Yong ZHOU
% zhouyong@scsio.ac.cn
% 2020-04-27

% earth_model=load(em);

% generation the time seris
ts=1/fs;
ln=length(wf);
t=(0:ln-1)*ts';

[E,E_inv,Lambda_inv]=gen_E_Lambda_inv(p,earth_model);

yf=fft(wf);
omiga=fs/2*linspace(0,1,ln/2+1);

omiga(1)=1e-16;

pprc=NaN*ones(1,size(omiga,2));
for i_omiga=1:length(omiga)
    pprc(i_omiga)=pprcm_fast(2*pi*omiga(i_omiga),E,E_inv,Lambda_inv);
end

pprc_all=[pprc,pprc(end-1:-1:2)];
ppf=pprc_all.*yf;
ppfm=[ppf(1),conj(ppf(ln:-1:ln/2+2)),ppf(ln/2+1:ln)];

pp_wf=real(ifft(ppfm));

end
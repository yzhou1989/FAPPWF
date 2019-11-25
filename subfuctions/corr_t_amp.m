function[t,amp,ind]=corr_t_amp(wf1,wf2,fs)
% corr_t_amp
% compute t and amplitide based on waveform 1 and 2
% 
% Yong ZHOU
% 2017-12-12

[acor,lag]=xcorr(wf1,wf2);
% [~,i2]=max(abs(acor));
[acor2,~]=xcorr(wf2,wf2);
[v1,ind_m]=max(abs(acor));
% [v1,ind_m]=max(acor);
[v2,~]=max(acor2);

t=lag(ind_m)/fs;
amp=v1/v2;

ind=0;

end
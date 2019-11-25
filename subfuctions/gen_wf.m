function [t,wf,fs]=gen_wf(gauss_mean,gauss_sigma,fs,ln)
% generate waveform
%
% Yong ZHOU
% 2017-12-05

ts=1/fs;
t=(0:ln-1)*ts';
wf=gaussmf(t,[gauss_sigma gauss_mean]);

end
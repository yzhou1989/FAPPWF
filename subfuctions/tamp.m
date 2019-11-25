function [time,amp]=tamp(em,p,gauss,fig_ind)
% tamp
% compute time shift and amplitude
% 
% Yong ZHOU
% zy29@foxmail.com
% 2017-09-19

[t,~,~,w]=ppwf(em,p,gauss/2,gauss/6,fig_ind);
amp=-min(w);
time=t(w==min(w));

% reft=18.9;
% refamp=0.3281;

reft=0;
refamp=0;

time=time-reft;
amp=amp-refamp;

end
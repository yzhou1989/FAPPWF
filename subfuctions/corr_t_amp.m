function[dt,amp,ind]=corr_t_amp(wf1,wf2,fs,varargin)
% corr_t_amp
% compute t and amplitide based on waveform 1 and 2
% 
% Yong ZHOU
% 2017-12-12

if nargin == 4
    interp=varargin{1};
else
    interp=1;
end

len=length(wf1);
t=1:len;
t_int=1:1/interp:len;

wf1_int=interp1(t,wf1,t_int,'spline');
wf2_int=interp1(t,wf2,t_int,'spline');

[acor,lag]=xcorr(wf1_int,wf2_int);
% [~,i2]=max(abs(acor));
[acor2,~]=xcorr(wf2_int,wf2_int);
% [v1,ind_m]=max(abs(acor));
[v1,ind_m]=max(acor);
[v2,~]=max(acor2);

dt=lag(ind_m)/(fs*interp);
amp=v1/v2;

ind=0;

end
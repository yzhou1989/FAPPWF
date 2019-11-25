function [t,amp,tshift,tpdp,wfpdp,tpp,wfpp]=tamp_corr(t,wf,tmpdp,tmpp,twin,ind_win)
% compute time shift and amplitude ratio
%
% Yong ZHOU
% 2018-04-10
%
% t arrival differential time
% amp amplitude ratio
% cross-correlation time shift
% t1 PdP time window
% wf1 PdP waveform
% t2 PP time window
% wf2 PP waveform

fs=1/(t(2)-t(1));

[t1s,t1e]=cut_time(t,tmpdp,twin);
[t2s,t2e]=cut_time(t,tmpp,twin);

tpdp=t(t1s:t1e);
tpp=t(t2s:t2e);

if ind_win=='y'
    wfpdp=wf(t1s:t1e).*hamming(length(wf(t1s:t1e)))';
    wfpp=wf(t2s:t2e).*hamming(length(wf(t2s:t2e)))';
else
    wfpdp=wf(t1s:t1e);
    wfpp=wf(t2s:t2e);
end

[tshift,amp]=corr_t_amp(wfpdp,wfpp,fs);

t=abs(tmpp-tmpdp)-tshift;

end

function [ss,es]=cut_time(t,tmid,twin)
% compute serials of t
% t time series
% tmid middle point of time
% twin time window

tdelta=t(2)-t(1);
s_mid=find(abs(t-tmid)<=tdelta);
if isscalar(s_mid)==0
    s_mid=s_mid(2);
end

n_s=ceil(0.5*twin/tdelta);

ss=s_mid-n_s;
es=s_mid+n_s;

end
function [t_c,seis_c]=cut_seismogram(t,seis,t_s,t_e)
% cut seismogram
%
% Yong ZHOU
% zhouy3@sustc.edu.cn
% 2019-01-17

if t_s > t(1) && t_e < t(end)
    
    t_inc=t(2)-t(1);
    
    ind_s=find(abs(t-t_s) <= 0.5*t_inc,1,'first');
    ind_e=find(abs(t-t_e) <= 0.5*t_inc,1,'first');
    
    t_c=t(ind_s:ind_e);
    seis_c=seis(ind_s:ind_e);
    
else
    error('t_s is too small or t_e is too large.');
end

end
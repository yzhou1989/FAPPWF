function [ts,ps]=shift_pp(t,p,t_shift,t_range)
% shift_pp
%
% Yong ZHOU
% 2017-12-22

int=t(2)-t(1);
ts=t_range(1):int:t_range(2);
ps=zeros(size(ts));

t=t+t_shift;

min_tt=max(t(1),t_range(1));
max_tt=min(t(end),t_range(2));

ps_min_ind=find(ts==min_tt);
ps_max_ind=find(ts==max_tt);

p_min_ind=find(t==min_tt);
p_max_ind=find(t==max_tt);

ps(ps_min_ind:ps_max_ind)=p(p_min_ind:p_max_ind);

end
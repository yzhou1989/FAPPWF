function [thpp] = get_thpp(t,ppwf)
% get arrival time of PP
%
% Yong ZHOU
% 2020-04-28
% zhouyong@scsio.ac.cn

[~,ind]=max(ppwf);
thpp=t(ind);

end
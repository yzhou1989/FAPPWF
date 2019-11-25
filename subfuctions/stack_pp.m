function [ts,ps]=stack_pp(lon,lat,shift)
% stack_pp
%
% Yong ZHOU
% 2017-12-22

num_f=length(lon);

shift_min=min(shift);
shift_max=max(shift);

ppf=strcat('pp_wf_0055/pp_',num2str(lon(1)),'_',num2str(lat(1)),'_.mat');
ppstru=load(ppf);
t=ppstru.out_pp(:,1);
int=t(2)-t(1);

t_min=t(1)+shift_min;
t_max=t(end)+shift_max;
ts=t_min:int:t_max;

pp_all=NaN*ones(num_f,length(ts));

% figure;xl=[100,300];

for i_f=1:num_f
    ppf=strcat('pp_wf_0055/pp_',num2str(lon(i_f)),'_',num2str(lat(i_f)),'_.mat');
    ppstru=load(ppf);
    t=ppstru.out_pp(:,1);
    pp=ppstru.out_pp(:,2);
    
    [~,pps]=shift_pp(t,pp,shift(i_f),[t_min,t_max]);
    
%     % figure
%     subplot(num_f+1,1,i_f)
%     plot(ts,pps);
%     xlim(xl);
    
    pp_all(i_f,:)=pps;
end

ps=sum(pp_all,1)/size(pp_all,1);

% % figure
% subplot(num_f+1,1,num_f+1);
% plot(ts,ps);
% xlim(xl);

end
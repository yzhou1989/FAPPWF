% stack_660
% Yong ZHOU
% zhouy3@sustc.edu.cn
% 2018-05-07

fs=4;
n_order=4;
min_period=15; % s
max_period=75; % s

list=dir('./wf_hem_eft_110/*.mat');
t_range=[-200,600];
n_t=(t_range(2)-t_range(1))*fs+1;

n_list=length(list);
n_non=0;

wfpp_all=NaN*ones(n_list,n_t);

for i_list=1:n_list
    
    disp(strcat(num2str(i_list),'/',num2str(n_list)));
    
    % load data
    ff=fullfile(list(i_list).folder,list(i_list).name);
    load(ff);

    pp_t=out_pp(:,1);
    pp_wf=out_pp(:,2);
    
    % filter
    [b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass');
    ppwf_fil=filter(b,a,pp_wf);
    max_ppwf=max(abs(ppwf_fil));
    ppwf_fil=ppwf_fil./max_ppwf;
    
    % shift time
    [~,ind_t]=max(ppwf_fil);
    t_p=pp_t-pp_t(ind_t);
    
    % plot
%     figure;plot(t_p,ppwf_fil);
    
    [tpp,wfpp]=shift_pp(t_p,ppwf_fil,0,t_range);
    
%     % for stack in regions A, B, C, D or all
%     region=regionB;
%     if inpolygon(lon,lat,region(:,1),region(:,2))==0
%        wfpp=zeros(size(wfpp));
%        n_non=n_non+1;
%     end
    
    wfpp_all(i_list,:)=wfpp;
end

% plot_stack 1
figure;hold on;
for i_list=1:n_list
    plot(tpp,wfpp_all(i_list,:),'color',[127,127,127]/255);
end
wfpp_stack=sum(wfpp_all)./(n_list-n_non);
plot(tpp,wfpp_stack,'k','LineWidth',2);
xlim([-200,35]);
xlabel('Time (s)');ylabel('Amplitude');

% plot_stack 2
figure(p2);hold on;
indp=170*4;
for i_list=1:n_list
%     plot(tpp,wfpp_all(i_list,:),'color',[127,127,127]/255);
    plot(tpp(1:indp),wfpp_all(i_list,1:indp)*10,'color',[127,127,127]/255);
    plot(tpp(indp+1:end),wfpp_all(i_list,indp+1:end),'color',[127,127,127]/255);
end

wfpp_stack=sum(wfpp_all)./(n_list-n_non);
% plot(tpp,wfpp_stack,'k','LineWidth',2);
plot(tpp(1:indp),wfpp_stack(1:indp)*10,'k','LineWidth',2);
plot(tpp(indp+1:end),wfpp_stack(indp+1:end),'k','LineWidth',2);

yLim=get(gca,'YLim');
plot([tpp(indp),tpp(indp)],yLim,'k--');
xlim([-200,35]);
xlabel('Time (s)');ylabel('Amplitude');

% stack_cp
% Yong ZHOU
%
% zhouy3@sustc.edu.cn
% 2018-05-07

fs=4;
n_order=4;
min_period=15; % s
max_period=75; % s

% mantle discontinuity
d410=importdata('d410.all07.c2.vel6.head.dat',' ',5);
d410=d410.data;
d410(:,6)=d410(:,5)-d410(:,3);

n_list=size(d410,1);
t_range=[-200,600];
n_t=(t_range(2)-t_range(1))*fs+1;

wfpp_all=NaN*ones(n_list,n_t);

for i_list=1:n_list
    
    disp(strcat(num2str(i_list),'/',num2str(n_list)));
    
    % load data
    lon=d410(i_list,1);
    lat=d410(i_list,2);
    
    if lon>=180
        lon=lon-360;
    end

    [lon_c,lat_c]=ll2crust(lon,lat);
    
    ff=strcat('./wf_eft_4096_110/wf_',num2str(lon_c),'_',num2str(lat_c),'_.mat');
    load(ff);
    
    pp_t=out_pp(:,1);
    pp_wf=out_pp(:,2);
    
    % filter
    [b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass');
    ppwf_fil=filter(b,a,pp_wf);
    
    % shift time
    [~,ind_t]=max(ppwf_fil);
    t_p=pp_t-pp_t(ind_t);
    
    [tpp,wfpp]=shift_pp(t_p,ppwf_fil,0,t_range);
%     wfpp_all(i_list,:)=wfpp;
    wfpp_all(i_list,:)=wfpp./max(abs(wfpp));
    
end

% plot_stack 1
figure;hold on;
for i_list=1:n_list
    plot(tpp,wfpp_all(i_list,:),'color',[127,127,127]/255);
end
wfpp_stack=sum(wfpp_all)./n_list;
plot(tpp,wfpp_stack,'k','LineWidth',2);
xlim([-200,35]);
xlabel('Time (s)');ylabel('Amplitude');

% plot_stack 2
figure(p2);hold on;
indp=170*4;
for i_list=1:n_list
    plot(tpp(1:indp),wfpp_all(i_list,1:indp)*10,'color',[127,127,127]/255);
    plot(tpp(indp+1:end),wfpp_all(i_list,indp+1:end),'color',[127,127,127]/255);
end

wfpp_stack=sum(wfpp_all)./n_list;
plot(tpp(1:indp),wfpp_stack(1:indp)*10,'k','LineWidth',2);
plot(tpp(indp+1:end),wfpp_stack(indp+1:end),'k','LineWidth',2);

yLim=get(gca,'YLim');
plot([tpp(indp),tpp(indp)],yLim,'k--');
xlim([-200,35]);
xlabel('Time (s)');ylabel('Amplitude');

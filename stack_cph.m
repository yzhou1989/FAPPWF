% stack_cp
% Yong ZHOU
%
% zhouy3@sustc.edu.cn
% 2018-05-07

fs=4;
n_order=4;
min_period=15; % s
max_period=75; % s

refd=800;
min_thick=5;

% slowness
dis=110; % in degree

switch dis
    case 80
        p_d=8.293;
    case 110
        p_d=7.221;
    case 140
        p_d=6.129;
end
    
p=raypar(p_d);

% generate input waveform
gauss=6;
ln=4096;

gauss_mean=gauss/2+50;
gauss_sigma=gauss/6;
[ti,wf,fs]=gen_wf(gauss_mean,gauss_sigma,fs,ln);

% load crust1.0 and PREM
load_crust1;
prem_file=load('prem_uneft.mat');

% mantle discontinuity
d410=importdata('d410.all07.c2.vel6.head.dat',' ',5);
d410=d410.data;
d410(:,6)=d410(:,5)-d410(:,3);

d660=importdata('d660.all07.c2.vel6.head.dat',' ',5);
d660=d660.data;
d660(:,6)=d660(:,5)-d660(:,3);

n_list=size(d410,1);
t_range=[-200,600];
n_t=(t_range(2)-t_range(1))*fs+1;

wfpp_all=NaN*ones(n_list,n_t);

list=dir('./cph_wf/wf_*.mat');

for i_list=1:n_list
%     tic;
    
    %% compute seismograms (comment)
%     disp(strcat(num2str(i_list),'/',num2str(n_list)));
%     
%     % load data
%     lon=d410(i_list,1);
%     lat=d410(i_list,2);
%     
%     if lon>=180
%         lon=lon-360;
%     end
% 
%     [lon_c,lat_c]=ll2crust(lon,lat);
%     i_line=ll2n(lon_c,lat_c);
%     
%     disc_410=d410(i_list,6);
%     disc_660=d660(i_list,6);
%     
%     % get earth_model
%     earth_model=get_hem(i_line,prem_file,refd,min_thick,...
%         th1,th2,th3,th4,th5,th6,th7,th8,...
%         vp1,vp2,vp3,vp4,vp5,vp6,vp7,vp8,...
%         vs1,vs2,vs3,vs4,vs5,vs6,vs7,vs8,...
%         ro1,ro2,ro3,ro4,ro5,ro6,ro7,ro8,...
%         bd1,bd9,disc_410,disc_660);
%     save(strcat('./cph_em/em_',num2str(lon),'_',num2str(lat),'_.mat'),'earth_model','lon','lat');
%     
%     % change discontinuity depth
%     
%     % compute seismogram
%     [pp_t,pp_wf]=ppwf(earth_model,p,wf,fs);
%     save(strcat('./cph_wf/wf_',num2str(lon),'_',num2str(lat),'_.mat'),'pp_t','pp_wf','lon','lat');
    
    %% extract seismograms (used)
    disp(strcat(num2str(i_list),'/',num2str(n_list)));
    ff=fullfile(list(i_list).folder,list(i_list).name);
    load(ff);

%     pp_t=out_pp(:,1);
%     pp_wf=out_pp(:,2);
    
    % filter
    [b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass');
    ppwf_fil=filter(b,a,pp_wf);
    
    % shift time
    [~,ind_t]=max(ppwf_fil);
    t_p=pp_t-pp_t(ind_t);
    
    [tpp,wfpp]=shift_pp(t_p,ppwf_fil,0,t_range);
%     wfpp_all(i_list,:)=wfpp;
    wfpp_all(i_list,:)=wfpp./max(abs(wfpp));
    
%     toc;
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
p2=figure;hold on;
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

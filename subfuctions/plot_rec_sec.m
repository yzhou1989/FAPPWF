%% plot record section with PP

% filter parameters
n_order=4;
min_period=15; % s
max_period=75; % s

fs=4;
dt=1/fs;

n_rec=141;
deg_ppwf_unfilter=cell(n_rec,4);
deg_ppwf_filter=cell(n_rec,4);
deg_ppwf_cut=cell(n_rec,4);

t_s=-150;
t_e=50;

for i_rec=1:n_rec
    i_rec_str=num2str(i_rec,'%04d');
    recfn=['axisem_simulated_PP/recfile_',i_rec_str,'_disp_post_mij_conv0000_N.dat'];
    recd=load(recfn);
    
    td=recd(:,1);
    pp_wfd=recd(:,2);
    
    deg=serial2deg(i_rec);
    rayp=deg2rayp(deg);
    
    % interpolation
    t=dt*(ceil(td(1)/dt):floor(td(end)/dt));
    pp_wf=interp1(td,pp_wfd,t);
    
    % filter
    [b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass');
    ppwf_fil=filter(b,a,pp_wf);
    
    % save unfiltered seismograms
    deg_ppwf_unfilter{i_rec,1}=deg;
    deg_ppwf_unfilter{i_rec,2}=rayp;
    deg_ppwf_unfilter{i_rec,3}=t;
    deg_ppwf_unfilter{i_rec,4}=pp_wf;
    
    % save filtered seismograms
    deg_ppwf_filter{i_rec,1}=deg;
    deg_ppwf_filter{i_rec,2}=rayp;
    deg_ppwf_filter{i_rec,3}=t;
    deg_ppwf_filter{i_rec,4}=ppwf_fil;
    
    % save cutted seismograms
    ttime=deg2ttime(deg);
    t_t=t-ttime;
    [t_cut,ppwf_cut]=cut_seismogram(t_t,ppwf_fil,t_s,t_e);
    
    deg_ppwf_cut{i_rec,1}=deg;
    deg_ppwf_cut{i_rec,2}=rayp;
    deg_ppwf_cut{i_rec,3}=t_cut;
    deg_ppwf_cut{i_rec,4}=ppwf_cut;
end

%% plot record section
figure;
hold on;
amp_coef1=20;
for i_d=41:5:101
    deg=deg_ppwf_filter{i_d,1};
    t=deg_ppwf_filter{i_d,3};
    ppwf_fil=deg_ppwf_filter{i_d,4};

    % add arrival time
    ttime=deg2ttime(deg);
    t_shift=t-ttime;
%     plot(t_shift,ppwf_fil*amp_coef1+deg,'k');
    
    % cut seismograms
    [t_cut,pp_cut]=cut_seismogram(t_shift,ppwf_fil,-150,60);
    pp_cut=pp_cut./max(abs(pp_cut)); %normalized
    % align with maximum amplitude 
    [~,max_ind]=max(pp_cut);
    max_t=t_cut(max_ind);
    t_align=t_cut-max_t;
    
%     plot(t_align,pp_cut*amp_coef1+deg,'k');
%     plot(t_align,pp_cut*amp_coef1+deg,'color',[0.5 0.5 0.5]);
    [~,ind_p]=min(abs(t_align-(-30)))
    plot(t_align(1:ind_p),pp_cut(1:ind_p)*amp_coef1+deg,'k');
    plot(t_align(ind_p+1:end),pp_cut(ind_p+1:end)*amp_coef1*0.1+deg,'k');
    
%     t_p=t-ttime;
%     [~,ind_p]=min(abs(t_p-(-30)));
%     plot(t_p(1:ind_p),ppwf_fil(1:ind_p)*amp_coef*10+deg*2,'r');
%     plot(t_p(ind_p+1:end),ppwf_fil(ind_p+1:end)*amp_coef+deg*2,'r');
end

% deg_vec=cell2mat(deg_ppwf_filter(:,1));
% ttime_p=deg2ttime(deg_vec,'PP');
% plot(ttime_p,deg_vec,'r');
% plot(ttime_p-30,deg_vec,'b--');
% plot(ttime_p+60,deg_vec,'b--');

hold off;
% xlim([-180 50]);
% ylim([60 160]);
% ylim('auto');
xlabel('Time (s)');ylabel('Distance (^o)');


%% cut p waves
figure;
hold on;
amp_coef1=1e-1;
d_s=1;
d_e=31;
deg_vec=cell2mat(deg_ppwf_unfilter(d_s:d_e,1));
ttime_p=deg2ttime(deg_vec,'P');
p_cut_deg=cell(size(deg_vec,1),4);
for i_d=1:31
    deg=deg_ppwf_unfilter{i_d,1};
    rayp=deg_ppwf_unfilter{i_d,2};
    t=deg_ppwf_unfilter{i_d,3};
    pp_wf=deg_ppwf_unfilter{i_d,4};
    
    t_align_p=t-ttime_p(i_d);
    
    [t_cut,p_cut]=cut_seismogram(t_align_p,pp_wf,-10,40);
%     [t_cut,p_cut]=cut_seismogram(t_cut,p_cut,-50,100);
    p_cut_extend=[zeros(1,160),p_cut,zeros(1,4096-160-201)];
    t_cut_extend=[0:size(p_cut_extend,2)-1]/fs;
    
%     p_cut_extend=p_cut_extend./max(abs(p_cut_extend)); % normalized
    
%     plot(t-ttime_p(i_d),pp_wf*amp_coef1+deg,'k');
%     plot(t_cut,p_cut*amp_coef1+deg,'k');
    plot(t_cut_extend,p_cut_extend,'k');
    
    % save 
    p_cut_deg{i_d,1}=deg;
    p_cut_deg{i_d,2}=rayp;
    p_cut_deg{i_d,3}=t_cut_extend;
    p_cut_deg{i_d,4}=p_cut_extend;
end

% plot(zeros(size(ttime_p)),deg_vec,'r');
% plot(zeros(size(ttime_p))-30,deg_vec,'b--');
% plot(zeros(size(ttime_p))+30,deg_vec,'b--');
xlabel('Time (s)');
ylabel('Distance (^o)');

%% plot record section
figure;
hold on;
amp_coef1=1e-1;
for i_d=1:31
    deg=deg_ppwf_filter{i_d,1};
    t=deg_ppwf_filter{i_d,3};
    ppwf_fil=deg_ppwf_filter{i_d,4};

    % add arrival time
    ttime=deg2ttime(deg);
%     plot(t-ttime,ppwf_fil*amp_coef1+deg,'k');
    
%     plot([ttime,ttime],[deg-0.5,deg+0.5],'r');
%     plot([ttime,ttime]-150,[deg-0.5,deg+0.5],'b');
%     plot([ttime,ttime]+50,[deg-0.5,deg+0.5],'b');
end

deg_vec=cell2mat(deg_ppwf_filter(:,1));
ttime_p=deg2ttime(deg_vec,'PP');
% plot(ttime_p,deg_vec,'r');
% plot(ttime_p-30,deg_vec,'b--');
% plot(ttime_p+60,deg_vec,'b--');

hold off;
% xlim([-180 50]);
% ylim([60 160]);
% ylim('auto');
xlabel('Time (s)');ylabel('Distance (^o)');

%%
figure;hold on;
amp_coef2=10;
for i_d=1:101 %size(deg_ppwf_axisem,1)
    deg=deg_ppwf_filter{i_d,1};
    t=deg_ppwf_filter{i_d,3};
    ppwf_fil=deg_ppwf_filter{i_d,4};
    
    plot(t-ttime,ppwf_fil*amp_coef2+deg,'k');
end
xlabel('Time (s)');ylabel('Distance (^o)');
xlim([-200 60]);
hold off;

%%
amp_coef3=20;
figure;
hold on;
for i_d=41:101
    deg=deg_ppwf_cut{i_d,1};
    t=deg_ppwf_cut{i_d,3};
    ppwf_cut=deg_ppwf_cut{i_d,4};
    
    % align with maximum amplitude 
    [~,max_ind]=max(ppwf_cut);
    max_t=t(max_ind);
    t_align=t-max_t;
    
    % normolized
    ppwf_cut=ppwf_cut./max(ppwf_cut);
    
    plot(t_align,ppwf_cut*amp_coef3+deg,'r--');
end
xlabel('Time (s)');ylabel('Distance (^o)');
hold off;

%% subfunctions
function [deg]=serial2deg(serial)

deg=serial+39; % distance in degree

end
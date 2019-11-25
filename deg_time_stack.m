%% 1. slowness
deg=80:140;
rayp=deg2rayp(deg); % distance in degree to ray paramter
p=raypar(rayp);

%% 2. input waveform

fs=4;

% % generate gauss function
% ln=4096;
% gauss=6;
% gauss_mean=gauss/2+50;
% gauss_sigma=gauss/6;
% [ti,wf,fs]=gen_wf(gauss_mean,gauss_sigma,fs,ln);

% load from axisem simulation
load p_cut_deg.mat
ti=p_cut_deg{end,3};
wf=p_cut_deg{end,4};
% wf=imag(hilbert(wf)); % Hilbert transform

%% 3. load model
refd=800; % km
min_thick=5.0;

% % prem model from shearer 2009
% load('../earth_model/prem_uneft.mat'); % for prem
% prem_cut=cut_model(prem,0,refd);
% prem_eft=eft(prem_cut);
% prem_cake_eft=gen_cake(prem_eft,min_thick);
% em=prem_cake_eft;

% prem model from axisem-v1.3
load('../earth_model/prem_uneft_axisem.mat');
prem_cut=cut_model(prem_axisem,0,refd);
prem_eft=eft(prem_cut);
prem_cake_eft=gen_cake(prem_eft,min_thick);
em=prem_cake_eft;

% filter parameters
n_order=4;
min_period=15; % s
max_period=75; % s

[b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass');

%% 4. main part
deg_ppwf=cell(length(p),4);
for i_p=1:length(p)
    % 4.1 calculate reflection waveform
    [t,pp_wf]=ppwf(em,p(i_p),wf,fs);
%     pp_wf=imag(hilbert(pp_wf)); % hilbert transform
    
    % 4.2 filter
    ppwf_fil=filter(b,a,pp_wf);
    ppwf_fil=imag(hilbert(ppwf_fil)); % Hilbert transform
    
    % 4.2 aligh with peak of PP phase (reference time 0)
    [~,max_ind]=max(ppwf_fil);
    max_t=t(max_ind);
    t_align=t-max_t;
    
    % 4.3 normalized
%     ppwf_fil=ppwf_fil./max(abs(ppwf_fil));
    ppwf_fil=ppwf_fil./max(ppwf_fil);
    
    % 4.3 save
    deg_ppwf{i_p,1}=deg(i_p);
    deg_ppwf{i_p,2}=rayp(i_p);
    deg_ppwf{i_p,3}=t_align;
    deg_ppwf{i_p,4}=ppwf_fil;
end

%% 5 plot record section
% figure;
hold on;
deg=80:140;
amp_coef=20;
for i_p=1:5:length(p)
    t_align=deg_ppwf{i_p,3};
    ppwf_fil=deg_ppwf{i_p,4};
%     plot(t_align,ppwf_fil*amp_coef+deg(i_p),'k');
    [~,ind_p]=min(abs(t_align-(-30)));
    plot(t_align(1:ind_p),ppwf_fil(1:ind_p)*amp_coef+deg(i_p),'r');
    plot(t_align(ind_p+1:end),ppwf_fil(ind_p+1:end)*amp_coef*0.1+deg(i_p),'r');
end
hold off;
xlim([-180 50]);
ylim([60 160]);
% ylim('auto');
xlabel('Time to PP (s)');ylabel('Distance (^o)');

%% 6 cut and save
t_s=-180;
t_e=50;
deg_ppwf_cut=deg_ppwf;

for i_p=1:length(p)
    t_align=deg_ppwf{i_p,3};
    ppwf_fil=deg_ppwf{i_p,4};
    
    [t_cut,ppwf_cut]=cut_seismogram(t_align,ppwf_fil,t_s,t_e);
%     ind_s=find(t_align==t_s);
%     ind_e=find(t_align==t_e);
%     t_cut=t_align(ind_s:ind_e);
%     ppwf_cut=ppwf_fil(ind_s:ind_e);
    
    deg_ppwf_cut{i_p,3}=t_cut;
    deg_ppwf_cut{i_p,4}=ppwf_cut;
end

ppwf_mat=cell2mat(deg_ppwf_cut(:,4));

%% plot
figure;hold on;
imagesc(t_cut,deg,ppwf_mat);
c_lim=[-0.02 0.02];

nc=32;

cmap=[linspace(0.5,1,nc)',linspace(0,1,nc)',linspace(0,1,nc)';...
    linspace(1,0,nc)',linspace(1,0,nc)',linspace(1,0.5,nc)'];
set(gca,'CLim',c_lim,'Colormap',cmap);
axis xy;
hold off;
colorbar;
xlim([-180 50]);ylim([80 140]);
xlabel('Time to PP (s)');ylabel('Distance (^o)');
view(90,-90);

%% 7 slant stack
dk=linspace(0,-1,40); % unit with s/deg
slant_stack=cell(length(dk),3);

t_s=-150;
t_e=50;
t_80=deg_ppwf{1,3};
ppwf_80=deg_ppwf{1,4};

[t_cut,ppwf_cut]=cut_seismogram(t_80,ppwf_80,t_s,t_e);

for i_dk=1:length(dk) % number of dk
    dki=dk(i_dk);

    sum_ppwf=ppwf_cut;
    for i_deg=2:length(deg) % number of stations
        t=deg_ppwf{i_deg,3};
        ppwf=deg_ppwf{i_deg,4};
        
        dt=dki*(deg(i_deg)-deg(1));
        t_si=t_s+dt;
        t_ei=t_e+dt;
        
        [t_cuti,ppwf_cuti]=cut_seismogram(t,ppwf,t_si,t_ei);
        
        sum_ppwf=sum_ppwf+ppwf_cuti;
    end
%     sum_ppwf=sum_ppwf/length(dk);
    
    slant_stack{i_dk,1}=dki;
    slant_stack{i_dk,2}=t_cut;
    slant_stack{i_dk,3}=sum_ppwf;
    
end

slant_stack_mat=cell2mat(slant_stack(:,3));

%% plot vespagram
figure;subplot(3,1,[1,2]);hold on;
imagesc(t_cut,dk',slant_stack_mat);
% colorbar;
colormap jet;
caxis([-1.5 1.5]);
% xlabel('Time to PP (s)');
ylabel('Slowness to PP (s/deg)');
xlim([-150 25]);

text(-53,-0.2,'220');
text(-86,-0.3,'410');
text(-118,-0.54,'660');

% the dash line
% gen_dts;
% plot(dts(:,2),dts(:,3),'k--');

% dts_deuss
load dts_deuss.mat;
plot(dts_deuss(:,1),dts_deuss(:,2),'k--');

hold off;

axis ij;
ylim([-1 0]);

% plot seismogram
% figure;
subplot(3,1,3);hold on;
tmp_t=slant_stack{1,2};
tmp_ppwf=slant_stack{1,3};
tmp_ind=find(tmp_t==-25);

tmp_t1=tmp_t(1:tmp_ind);
tmp_ppwf1=tmp_ppwf(1:tmp_ind);
tmp_t2=tmp_t(tmp_ind:end);
tmp_ppwf2=tmp_ppwf(tmp_ind:end);

plot(tmp_t1,tmp_ppwf1./max(abs(tmp_ppwf1)),'k');
plot(tmp_t2,tmp_ppwf2./max(abs(tmp_ppwf2)),'k');
xlim([-150 25]);
ylim([-1.4 1.4]);

yl=get(gca,'Ylim');
plot([-25,-25],yl,'k--');

text(-53,1.2,'220');
text(-86,0.6,'410');
text(-118,0.6,'660');

hold off;
xlabel('Time to PP (s)');ylabel('Norm. ampl.');
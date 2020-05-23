function []=batch_ppwf(scpu,ncpu,dis,phase,varargin)
%% parameters
% scpu=1; % serial numver of CPU
% ncpu=6; % number of CPU for simulation
% dis=110; % in degree

if nargin == 0
    scpu=1;
    ncpu=6;
    dis=110;
    phase='P^660P';
end

addpath('./subfunctions/');

gauss=6;

fs=4;
ln=4096;

%% generate input waveform
gauss_mean=gauss/2+50;
gauss_sigma=gauss/6;
[ti,wf,fs]=gen_wf(gauss_mean,gauss_sigma,fs,ln);

%% slowness
p=raypar_r(deg2rayp(dis,phase),0);

%% compute reflect waveform with global model
list=dir('../earth_model/rem_eft/*.mat');
nl=size(list,1);
% list=dir('./hem_eft/*.mat');
folder='../earth_model/rem_eft/';

outdir=['./wf_rem_eft_',phase,'_',num2str(dis)];
outdir=strrep(outdir,'^','');
if ~exist(outdir,'dir')
    mkdir(outdir)
end

start_n=(nl/ncpu)*(scpu-1)+1;
end_n=(nl/ncpu)*scpu;
% end_n=start_n+10;

for i_model=start_n:end_n %length(list)
    % for i_model=1:length(list)
    tic
    disp(strcat(num2str(i_model),'/',num2str(length(list))));
    %     ff=fullfile(list(i_model).folder,list(i_model).name);
    ff=fullfile(folder,list(i_model).name); % modified for matlab 2015b
    load(ff);
    [t,pp_wf]=ppwf_fast(earth_model,p,wf,fs);
    
    out_pp=[t',pp_wf'];
    save(strcat(outdir,'/wf_',num2str(lon),'_',num2str(lat),'_.mat'),...
        'out_pp','lon','lat');
    toc
end

end
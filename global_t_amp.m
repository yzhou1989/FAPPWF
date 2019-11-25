% compute global t and amp
%
% Yong ZHOU
% 2017-12-13

load('input_wf_.mat');

list=dir('./pp_wf_0075/*.mat');

tamp=NaN*ones(length(list),8);

for i_mat=1:length(list)
    tic;
    disp(i_mat);
    ff=fullfile(list(i_mat).folder,list(i_mat).name);
    load(ff);
    
    [t220,amp220,t410,amp410,t660,amp660]=get_t_com(inp_wf(:,2),out_pp(:,2),2);
    
    tamp(i_mat,:)=[lon,lat,t220,amp220,t410,amp410,t660,amp660];
    
    toc;
end
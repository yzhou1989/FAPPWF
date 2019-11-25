function [out]=comfirm_tamp(lon,lat,pind)
% comfirm_tamp
% comfirm measured t and amp
% example: confirm_tamp(-99.5,89.5,'0075') 
%
% Yong ZHOU
% 2017-12-19

load('input_wf_.mat');

mfile=strcat('pp_wf_',pind,'/pp_',num2str(lon),'_',num2str(lat),'_.mat');
load(mfile);

[t220_1,amp220_1,t410_1,amp410_1,t660_1,amp660_1]=get_t_com(inp_wf(:,2),out_pp(:,2),2);

figure;plot(out_pp(:,1),out_pp(:,2),'r');
hold on;
xlabel('Time (s)');

load(['pp_prem_',pind,'_.mat']);

[t220_2,amp220_2,t410_2,amp410_2,t660_2,amp660_2]=get_t_com(inp_wf(:,2),out_pp(:,2),2);

plot(out_pp(:,1),out_pp(:,2),'k');
xlim([180,240]);
legend(['pp\_',num2str(lon),'\_',num2str(lat)],'pp\_prem');
hold off;

out=[t220_1,amp220_1,t410_1,amp410_1,t660_1,amp660_1;
     t220_2,amp220_2,t410_2,amp410_2,t660_2,amp660_2];
out(3,:)=out(1,:)-out(2,:);

end
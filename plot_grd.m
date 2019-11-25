% plot_grd
% plot grd file
%
% Yong ZHOU

load input_wf_.mat
load pp_prem_0075_.mat
load tamp_0075.mat

fs=2;

[t220,amp220,t410,amp410,t660,amp660]=get_t_com(inp_wf(:,2),out_pp(:,2),2);

% t220_mat=tamp(:,[1,2,3]);
% t220_mat(:,3)=t220_mat(:,3)-t220;
% save t220.txt t220_mat -ascii;
% system('surface -R-180/180/-90/90 -I0.2/0.2 -Gt220.grd t220.txt');
% system('sh plot_t_grd t220.grd');

t410_mat=tamp(:,[1,2,5]);
t410_mat(:,3)=t410_mat(:,3)-t410;
save t410.txt t410_mat -ascii;
system('surface -R-180/180/-90/90 -I0.2/0.2 -Gt410.grd t410.txt');
system('sh plot_t_grd t410.grd');

t660_mat=tamp(:,[1,2,7]);
t660_mat(:,3)=t660_mat(:,3)-t660;
save t660.txt t660_mat -ascii;
system('surface -R-180/180/-90/90 -I0.2/0.2 -Gt660.grd t660.txt');
system('sh plot_t_grd t660.grd');

a410_mat=tamp(:,[1,2,6]);
% a410_mat(:,3)=(a410_mat(:,3)-amp410)./amp410;
a410_mat(:,3)=a410_mat(:,3)-amp410;
save a410.txt a410_mat -ascii;
system('surface -R-180/180/-90/90 -I0.2/0.2 -Ga410.grd a410.txt');
system('sh plot_amp_grd a410.grd');

a660_mat=tamp(:,[1,2,8]);
% a660_mat(:,3)=(a660_mat(:,3)-amp660)/amp660;
a660_mat(:,3)=a660_mat(:,3)-amp660;
save a660.txt a660_mat -ascii;
system('surface -R-180/180/-90/90 -I0.2/0.2 -Ga660.grd a660.txt');
system('sh plot_amp_grd a660.grd');
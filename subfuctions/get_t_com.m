function [dt220,damp220,dt410,damp410,dt660,damp660]=get_t_com(wf1,wf2,fs)
% get_t_com
% get differential time and amplitude ratio
%
% Yong ZHOU
% 2017-12-13

leng=1600;

win_660=zeros(leng,1);
win_410=zeros(leng,1);
win_220=zeros(leng,1);
win_surf=zeros(leng,1);
win_660(1:100)=1;
win_410(101:200)=1;
win_220(201:300)=1;
win_surf(301:450)=1;

[tsurf,ampsurf]=corr_t_amp(wf1,wf2.*win_surf,fs);
[t220,amp220]=corr_t_amp(wf1,wf2.*win_220,fs);
[t410,amp410]=corr_t_amp(wf1,wf2.*win_410,fs);
[t660,amp660]=corr_t_amp(wf1,wf2.*win_660,fs);

dt220=tsurf-t220;
dt410=tsurf-t410;
dt660=tsurf-t660;

damp220=amp220/ampsurf;
damp410=amp410/ampsurf;
damp660=amp660/ampsurf;

end
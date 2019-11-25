% generate earth model based on PREM and mantle discontinuity by Houser 2008
%
% Yong ZHOU
% 2018-05-07

refd=800;
min_thick=5;

% PREM
load('../earth_model/prem_uneft.mat'); % for prem

% mantle discontinuity
d410=importdata('d410.all07.c2.vel6.head.dat',' ',5);
d410=d410.data;
d410(:,6)=d410(:,5)-d410(:,3);

d660=importdata('d660.all07.c2.vel6.head.dat',' ',5);
d660=d660.data;
d660(:,6)=d660(:,5)-d660(:,3);

for i_p=1:size(d410,1)
    
    prem_cut=cut_model(prem,0,refd);
    
    lon=d410(i_p,1);
    lat=d410(i_p,2);
    
    disc_410=d410(i_p,6);
    disc_660=d660(i_p,6);
    
    prem_cut(16,1)=disc_410;
    prem_cut(17,1)=disc_410;
    
    prem_cut(22,1)=disc_660;
    prem_cut(23,1)=disc_660;
    
    prem_cut=rearrange(prem_cut);
    
    prem_eft=eft(prem_cut);
    prem_cake_eft=gen_cake(prem_eft,min_thick);
    earth_model=prem_cake_eft;
    
    fn=strcat('./hem_eft/','hem_eft_',num2str(lon),'_',...
        num2str(lat));
    save(strcat(fn,'_.mat'),'earth_model','lon','lat');
    
end

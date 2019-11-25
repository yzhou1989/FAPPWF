% stack_region
%
% Yong ZHOU
% zhouy3@sustc.edu.cn
% 2018-05-08

lon_lat=NaN*ones(180*90,2);
ill=0;

for lon=-179.5+180:179.5+180
    for lat=89.5:-1:-89.5
        ill=ill+1;
        lon_lat(ill,1)=lon;
        lon_lat(ill,2)=lat;
    end
end

regionA=[...
    105 70;...
    105 20;...
    115 20;...
    165 60;...
    180 60;...
    180 70;...
    105 70;...
    ];

regionB=[...
    115 20;...
    180 20;...
    190 40;...
    190 60;...
    165 60;...
    115 20;...
    ];

regionC=[...
    190 60;...
    190 40;...
    180 20;...
    255 20;...
    220 60;...
    190 60;...
    ];

regionD=[...
    180 60;...
    220 60;...
    255 20;...
    265 20;...
    295 50;...
    295 70;...
    180 70;...
    180 60;...
    ];

regionAll=[105,70;105,20;265,20;295,50;295,70;105,70;];

in_A=inarea(lon_lat,regionA);
in_B=inarea(lon_lat,regionB);
in_C=inarea(lon_lat,regionC);
in_D=inarea(lon_lat,regionD);

[wfpp_A,tpp]=stack(in_A);
wfpp_B=stack(in_B);
wfpp_C=stack(in_C);
wfpp_D=stack(in_D);
wfpp_all=[wfpp_A;wfpp_B;wfpp_C;wfpp_D];

figure;hold on;
plot_stack(tpp,wfpp_all,1,0.0);
plot_stack(tpp,wfpp_D,1,1.5);
plot_stack(tpp,wfpp_C,1,3.0);
plot_stack(tpp,wfpp_B,1,4.5);
plot_stack(tpp,wfpp_A,1,6.0);

text(-190,6.2,'Region A');
text(-190,4.7,'Region B');
text(-190,3.2,'Region C');
text(-190,1.7,'Region D');
text(-190,0.2,'All Regions');

ylabel('');
set(gca,'XMinorTick','on','YTickLabel',[],'YColor','w');
% set(gca,'YMinorTick','on','YColor','k');

function [lon_lat_in]=inarea(lon_lat,region)
% inarea
%
% Yong ZHOU
% 2018-05-08

in_ind=inpolygon(lon_lat(:,1),lon_lat(:,2),region(:,1),region(:,2));
lon_lat_in=lon_lat(in_ind,:);

end

function [wfpp_all,tpp]=stack(ll)
% stack
%
% Yong ZHOU
% 2018-05-08

fs=4;
n_order=4;
min_period=16; % s
max_period=75; % s

n_list=size(ll,1);
t_range=[-200,600];
n_t=(t_range(2)-t_range(1))*fs+1;

wfpp_all=NaN*ones(n_list,n_t);

for i_list=1:n_list
    
    disp(strcat(num2str(i_list),'/',num2str(n_list)));
    
    % load data
    lon=ll(i_list,1);
    lat=ll(i_list,2);
    
    if lon>=180
        lon=lon-360;
    end
    
    ff=strcat('./wf_eft_4096_110/wf_',num2str(lon),'_',num2str(lat),'_.mat');
    pp=load(ff);
    
    pp_t=pp.out_pp(:,1);
    pp_wf=pp.out_pp(:,2);
    
    % filter
    [b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass');
    ppwf_fil=filter(b,a,pp_wf);
    
    % shift time
    [~,ind_t]=max(ppwf_fil);
    t_p=pp_t-pp_t(ind_t);
    
    [tpp,wfpp]=shift_pp(t_p,ppwf_fil,0,t_range);
    wfpp_all(i_list,:)=wfpp;
    wfpp_all(i_list,:)=wfpp./max(abs(wfpp));
    
end

end

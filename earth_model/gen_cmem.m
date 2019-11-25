% gen_sem
% generate earth model based on Crust1.0
%
% Yong ZHOU
% 2017-09-18

refd=800; % reference depth in km

ind_del=[5 22 33 50];

bd1=load('xyz-bd1');
bd2=load('xyz-bd2');
bd3=load('xyz-bd3');
bd4=load('xyz-bd4');
bd5=load('xyz-bd5');
bd6=load('xyz-bd6');
bd7=load('xyz-bd7');
bd8=load('xyz-bd8');
bd9=load('xyz-bd9');

vp1=load('xyz-vp1');
vp2=load('xyz-vp2');
vp3=load('xyz-vp3');
vp4=load('xyz-vp4');
vp5=load('xyz-vp5');
vp6=load('xyz-vp6');
vp7=load('xyz-vp7');
vp8=load('xyz-vp8');
vp9=load('xyz-vp9');

vs1=load('xyz-vs1');
vs2=load('xyz-vs2');
vs3=load('xyz-vs3');
vs4=load('xyz-vs4');
vs5=load('xyz-vs5');
vs6=load('xyz-vs6');
vs7=load('xyz-vs7');
vs8=load('xyz-vs8');
vs9=load('xyz-vs9');

ro1=load('xyz-ro1');
ro2=load('xyz-ro2');
ro3=load('xyz-ro3');
ro4=load('xyz-ro4');
ro5=load('xyz-ro5');
ro6=load('xyz-ro6');
ro7=load('xyz-ro7');
ro8=load('xyz-ro8');
ro9=load('xyz-ro9');

sdep=ncread('GYPSUMS_kmps.nc','depth');
vs=ncread('GYPSUMS_kmps.nc','vs');
pdep=ncread('GYPSUMP_kmps.nc','depth');
vp=ncread('GYPSUMP_kmps.nc','vp');

n_line=size(bd1,1);

tic;
parfor i_line=1:n_line
    lon=bd1(i_line,1)-0.5;
    lat=bd1(i_line,2)+0.5;
    fid=fopen(strcat('./cmem/cmem_',num2str(lon),'_',num2str(lat)),'w');

    crust=[...
        -bd1(i_line,3),vp1(i_line,3),vs1(i_line,3),ro1(i_line,3);...
        -bd2(i_line,3),vp2(i_line,3),vs2(i_line,3),ro2(i_line,3);...
        -bd3(i_line,3),vp3(i_line,3),vs3(i_line,3),ro3(i_line,3);...
        -bd4(i_line,3),vp4(i_line,3),vs4(i_line,3),ro4(i_line,3);...
        -bd5(i_line,3),vp5(i_line,3),vs5(i_line,3),ro5(i_line,3);...
        -bd6(i_line,3),vp6(i_line,3),vs6(i_line,3),ro6(i_line,3);...
        -bd7(i_line,3),vp7(i_line,3),vs7(i_line,3),ro7(i_line,3);...
        -bd8(i_line,3),vp8(i_line,3),vs8(i_line,3),ro8(i_line,3);...
        -bd9(i_line,3),vp9(i_line,3),vs9(i_line,3),ro9(i_line,3);...
        ];
    crust(end,:)=[];
    
    i_lon=lon-(-180)+1;
    i_lat=lat-(-90)+1;
    
    mvp=vp(i_lon,i_lat,:);
    mvp=mvp(:);
    
    mvs=vs(i_lon,i_lat,:);
    mvs=mvs(:);
    
    mpdep=pdep;
    msdep=sdep;

    mpdep(ind_del,:)=[];
    mvp(ind_del,:)=[];
    mrho=vp2rho(mvp);
    
    mantle=[msdep,mvp,mvs,mrho];
    
    mantle(mantle(:,1)<crust(end,1),:)=[];
    mantle(mantle(:,1)>refd,:)=[];
    
    model=[crust;mantle];
    model(:,1)=conv(model(:,1),[1,-1],'same');
    model(end,1)=model(end,1)+refd;
    model(model(:,1)==0,:)=[];
    
    for i_model=1:size(model,1)
        fprintf(fid,'%.2f %.2f %.2f %.2f\n',model(i_model,1),model(i_model,2),...
            model(i_model,3),model(i_model,4));
    end
    
    fclose(fid);
end
toc;
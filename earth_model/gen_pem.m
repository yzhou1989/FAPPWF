% gen_pem
% generate earth model based on Crust1.0 and PREM
%
% Yong ZHOU
% 2017-12-05
%
% need files of curst1.0 and prem_thk.em

tic;

t=cputime;

refd=800; % reference depth in km

th1=load('xyz-th1');
th2=load('xyz-th2');
th3=load('xyz-th3');
th4=load('xyz-th4');
th5=load('xyz-th5');
th6=load('xyz-th6');
th7=load('xyz-th7');
th8=load('xyz-th8');

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

bd9=load('xyz-bd9');

n_line=size(th1,1);
lon_all=th1(:,1);
lat_all=th1(:,2);

prem_file=load('prem_thk.em');

toc;

for i_line=n_line:-1:1 %1:n_line
    
    disp(i_line);
    tic;
    
    lon=lon_all(i_line);
    lat=lat_all(i_line);
    
    fn=strcat('./pem/','pem_',num2str(lon),'_',...
        num2str(lat));
    
%     if exist(fn,'file')==0
        
        crust=[...
            th1(i_line,3),vp1(i_line,3),vs1(i_line,3),ro1(i_line,3);...
            th2(i_line,3),vp2(i_line,3),vs2(i_line,3),ro2(i_line,3);...
            th3(i_line,3),vp3(i_line,3),vs3(i_line,3),ro3(i_line,3);...
            th4(i_line,3),vp4(i_line,3),vs4(i_line,3),ro4(i_line,3);...
            th5(i_line,3),vp5(i_line,3),vs5(i_line,3),ro5(i_line,3);...
            th6(i_line,3),vp6(i_line,3),vs6(i_line,3),ro6(i_line,3);...
            th7(i_line,3),vp7(i_line,3),vs7(i_line,3),ro7(i_line,3);...
            th8(i_line,3),vp8(i_line,3),vs8(i_line,3),ro8(i_line,3);...
            ];...
        crust(crust(:,1)==0,:)=[];
        
        prem=prem_file;
        
        % top of mantle
        dep=cumsum(prem(:,1));
        ind_layer=find(dep>-bd9(i_line,3),1);
        prem(1:ind_layer-1,:)=[];
        prem(1,1)=dep(ind_layer)+bd9(i_line,3);
        
        % bottom of mantle
        refdep=refd+bd9(i_line,3);
        dep=cumsum(prem(:,1));
        ind_layer=find(dep>refdep,1);
        prem(ind_layer+1:end,:)=[];
        prem(end,1)=refdep-dep(ind_layer-1);
        
        prem_end=[0,prem(end,2),prem(end,3),prem(end,4)];
        
        earth_model=[crust;prem;prem_end];
        
        save(strcat(fn,'_.mat'),'earth_model','lon','lat');
%     end
    toc;
end

e=cputime-t
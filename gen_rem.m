% gen_rem
% generate earth model based on Crust1.0 and PREM
%
% Yong ZHOU
% 2018-03-14
%
% need files of curst1.0 and prem_uneft.m

tic;

t=cputime;

refd=800; % reference depth in km
min_thick=5; % minimam cake thick in km

th1=load('../earth_model/xyz-th1');
th2=load('../earth_model/xyz-th2');
th3=load('../earth_model/xyz-th3');
th4=load('../earth_model/xyz-th4');
th5=load('../earth_model/xyz-th5');
th6=load('../earth_model/xyz-th6');
th7=load('../earth_model/xyz-th7');
th8=load('../earth_model/xyz-th8');

vp1=load('../earth_model/xyz-vp1');
vp2=load('../earth_model/xyz-vp2');
vp3=load('../earth_model/xyz-vp3');
vp4=load('../earth_model/xyz-vp4');
vp5=load('../earth_model/xyz-vp5');
vp6=load('../earth_model/xyz-vp6');
vp7=load('../earth_model/xyz-vp7');
vp8=load('../earth_model/xyz-vp8');
vp9=load('../earth_model/xyz-vp9');

vs1=load('../earth_model/xyz-vs1');
vs2=load('../earth_model/xyz-vs2');
vs3=load('../earth_model/xyz-vs3');
vs4=load('../earth_model/xyz-vs4');
vs5=load('../earth_model/xyz-vs5');
vs6=load('../earth_model/xyz-vs6');
vs7=load('../earth_model/xyz-vs7');
vs8=load('../earth_model/xyz-vs8');
vs9=load('../earth_model/xyz-vs9');

ro1=load('../earth_model/xyz-ro1');
ro2=load('../earth_model/xyz-ro2');
ro3=load('../earth_model/xyz-ro3');
ro4=load('../earth_model/xyz-ro4');
ro5=load('../earth_model/xyz-ro5');
ro6=load('../earth_model/xyz-ro6');
ro7=load('../earth_model/xyz-ro7');
ro8=load('../earth_model/xyz-ro8');
ro9=load('../earth_model/xyz-ro9');

bd1=load('../earth_model/xyz-bd1');
bd9=load('../earth_model/xyz-bd9');

n_line=size(th1,1);
lon_all=th1(:,1);
lat_all=th1(:,2);

prem_file=load('prem_uneft.mat');

toc;

for i_line=n_line:-1:1 %1:n_line
    
    disp(i_line);
    tic;
    
    lon=lon_all(i_line);
    lat=lat_all(i_line);
    
    fn=strcat('./rem_eft/','rem_eft_',num2str(lon),'_',...
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
    
    crust_line=cake2line(crust,-bd1(i_line,3));
    
    prem=prem_file.prem;
    
    prem_cut=cut_model(prem,-bd9(i_line,3),refd);
    
    earth_model_line=[crust_line;prem_cut];
    
    % earth flattening transform
    earth_model_line=eft(earth_model_line);
    
    earth_model=gen_cake(earth_model_line,min_thick);
    
    save(strcat(fn,'_.mat'),'earth_model','lon','lat');
    %     end
    toc;
end

e=cputime-t
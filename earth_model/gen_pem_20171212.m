% gen_pem
% generate earth model based on Crust1.0 and PREM
%
% Yong ZHOU
% 2017-12-05
%
% need files of curst1.0 and prem_thk.em

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
lon=th1(:,1);
lat=th1(:,2);

for i_line=n_line:-1:1 %1:n_line
    
    disp(i_line);
    tic;
    
    fn=strcat('pem_',num2str(lon(i_line)),'_',...
        num2str(lat(i_line)));
    
    if exist(fn,'file')==0
    
        fid=fopen(fn,'w');
        if th1(i_line,3) ~= 0
            fprintf(fid,'%.2f %.2f %.2f %.2f\n',th1(i_line,3),vp1(i_line,3),...
                vs1(i_line,3),ro1(i_line,3));
        end
        if th2(i_line,3) ~= 0
            fprintf(fid,'%.2f %.2f %.2f %.2f\n',th2(i_line,3),vp2(i_line,3),...
                vs2(i_line,3),ro2(i_line,3));
        end
        if th3(i_line,3) ~= 0
            fprintf(fid,'%.2f %.2f %.2f %.2f\n',th3(i_line,3),vp3(i_line,3),...
                vs3(i_line,3),ro3(i_line,3));
        end
        if th4(i_line,3) ~= 0
            fprintf(fid,'%.2f %.2f %.2f %.2f\n',th4(i_line,3),vp4(i_line,3),...
                vs4(i_line,3),ro4(i_line,3));
        end
        if th5(i_line,3) ~= 0
            fprintf(fid,'%.2f %.2f %.2f %.2f\n',th5(i_line,3),vp5(i_line,3),...
                vs5(i_line,3),ro5(i_line,3));
        end
        if th6(i_line,3) ~= 0
            fprintf(fid,'%.2f %.2f %.2f %.2f\n',th6(i_line,3),vp6(i_line,3),...
                vs6(i_line,3),ro6(i_line,3));
        end
        if th7(i_line,3) ~= 0
            fprintf(fid,'%.2f %.2f %.2f %.2f\n',th7(i_line,3),vp7(i_line,3),...
                vs7(i_line,3),ro7(i_line,3));
        end
        if th8(i_line,3) ~= 0
            fprintf(fid,'%.2f %.2f %.2f %.2f\n',th8(i_line,3),vp8(i_line,3),...
                vs8(i_line,3),ro8(i_line,3));
        end
        
        prem=load('prem_thk.em');
        
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
        
        for i_prem=1:size(prem,1)
            fprintf(fid,'%.2f %.2f %.2f %.2f\n',prem(i_prem,1),prem(i_prem,2),...
                prem(i_prem,3),prem(i_prem,4));
        end
        
        fprintf(fid,'%.2f %.2f %.2f %.2f\n',0,prem(end,2),...
            prem(end,3),prem(end,4));
        
        fclose(fid);
    end
    toc;
end

e=cputime-t
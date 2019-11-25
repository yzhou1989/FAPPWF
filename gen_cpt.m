% gen_cpt
%
% Yong ZHOU
% zhouy3@sustc.edu.cn
% 2018-05-05

fname='houser.cpt';

vsect=[-20:3:-2,2:3:20];
ssect=vsect(1:end-1);
esect=vsect(2:end);

nline=length(vsect)-1;

rgb=[...
    52,100,173;...
    29,93,170;...
    22,128,196;...
    64,196,242;...
    146,217,245;...
    173,223,229;...
    255,255,255;...
    245,244,194;...
    248,239,153;...
    249,219,109;...
    250,181,83;...
    236,42,46;...
    202,77,75;...
    ];

fid=fopen(fname,'w+');

fprintf(fid,'%s\n','#GMT palette houser.cpt');
fprintf(fid,'%s\n','#');
fprintf(fid,'%s\n','#This product generated by gen_cpt.m');
fprintf(fid,'%s\n','#');
fprintf(fid,'%s\n','#For Houser 2008');
fprintf(fid,'%s\n','#');
fprintf(fid,'%s\n','#COLOR_MODEL=RGB');

for i_nl=1:nline
    fprintf(fid,'%0.2f %d %d %d %.2f %d %d %d\n',ssect(i_nl),rgb(i_nl,1),rgb(i_nl,2),rgb(i_nl,3),...
        esect(i_nl),rgb(i_nl,1),rgb(i_nl,2),rgb(i_nl,3));
end

fprintf(fid,'%s %d %d %d\n','B',rgb(1,1),rgb(1,2),rgb(1,3));
fprintf(fid,'%s %d %d %d\n','F',rgb(end,1),rgb(end,2),rgb(end,3));
fprintf(fid,'%s %d %d %d\n','N',rgb(1,1),rgb(1,2),rgb(1,3));

fclose(fid);
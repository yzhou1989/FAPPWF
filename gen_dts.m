% gen_dts
% generate_dep_time_slowness

dep=0:10:1200;

dts=NaN*ones(length(dep),3); % dep_time_slowness
dts(:,1)=dep';

for i_dep=1:length(dep)
    [~,out]=system(['taup_time -model prem -ph P -deg 40 -h ',num2str(dep(i_dep))]);
    ind=strfind(out,' P ');
    tt_str=out(ind+6:ind+16);
    tt=str2double(tt_str);
    rayp_str=out(ind+17:ind+27);
    rayp=str2double(rayp_str);
    
    dts(i_dep,2)=tt;
    dts(i_dep,3)=rayp;
end

dts(:,2)=2*(dts(:,2)-dts(1,2));
dts(:,3)=dts(:,3)-dts(1,3);
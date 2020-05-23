ddeg_vec=80:10:140;
res_tt=NaN*ones(length(ddeg_vec),3);

for i_ddeg=1:length(ddeg_vec)
    ddeg=ddeg_vec(i_ddeg);
    th410=deg2ttime(ddeg,'PP')-deg2ttime(ddeg,'P^410P');
    th660=deg2ttime(ddeg,'PP')-deg2ttime(ddeg,'P^660P');
    
    res_tt(i_ddeg,1:3)=[ddeg,th410,th660];
end

hold on;plot(res_tt(:,1),res_tt(:,2),'k--');
legend('PP','P410P','P660P','Taup');

hold on;plot(res_tt(:,1),res_tt(:,3),'k--');
legend('PP','P410P','P660P','Taup');
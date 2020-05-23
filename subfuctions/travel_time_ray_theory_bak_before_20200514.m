ind_410=89;
ind_660=30;

% slowness
dis=110; % in degree

switch dis
    case 80
        p_d=8.293;
    case 110
        p_d=7.221;
    case 140
        p_d=6.129;
end

p=raypar(p_d);

list=dir('../earth_model/rem_eft/*.mat');

n_list=size(list,1);

out_tt=NaN*ones(n_list,4);

for i_model=1:n_list
    ff=fullfile(list(i_model).folder,list(i_model).name);
    load(ff);
    
%     if earth_model(1,3)==0
%         earth_model_ttpp=earth_model(2:end,:);
%     else
%         earth_model_ttpp=earth_model;
%     end

    earth_model_ttpp=earth_model;
    
    tt_pp=travel_time(earth_model_ttpp,p);
    tt_p410p=travel_time(earth_model(end-ind_410:end,:),p);
    tt_p660p=travel_time(earth_model(end-ind_660:end,:),p);
    
    dt_410=tt_pp-tt_p410p;
    dt_660=tt_pp-tt_p660p;
    
    out_tt(i_model,:)=[lon,lat,dt_410,dt_660];
end

% save(strcat('./travel_time_noocean_',num2str(dis),'.mat'),'out_tt');

function [tt]=travel_time(earth_model,p)

tt=0;
for i_em=1:size(earth_model,1)-1
    thickness=earth_model(i_em,1);
    alpha=earth_model(i_em,2);
    eta=sqrt(1/alpha^2-p^2);
    ti=thickness*eta;
    tt=tt+ti;
end

tt=2*tt;

end
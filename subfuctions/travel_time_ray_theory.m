ind_410=89;
ind_660=30;

% slowness
ddeg=110;
p=raypar_r(deg2rayp(ddeg,'P^660P'),0);

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

%     earth_model_ttpp=earth_model;
%     
%     tt_pp=travel_time(earth_model_ttpp,p);
%     tt_p410p=travel_time(earth_model(end-ind_410:end,:),p); % wrong code
%     tt_p660p=travel_time(earth_model(end-ind_660:end,:),p); % wrong code
%     
%     dt_410=tt_pp-tt_p410p;
%     dt_660=tt_pp-tt_p660p;
    [dt_410,dt_660]=travel_time_ray_theory_point(em,p);
    
    out_tt(i_model,:)=[lon,lat,dt_410,dt_660];
end

% save(strcat('./travel_time_noocean_',num2str(dis),'.mat'),'out_tt');

function [dt410,dt660,varargout]=travel_time_ray_theory_point(em,p)

if em(1,3)==0
    em=em(2:end,:);
end

ind_410=find(abs(em(:,2)-9.5069)<1e-4);
ind_660=find(abs(em(:,2)-11.477)<1e-4);

at_pp=travel_time(em,p);
em_410=em(ind_410+1:end,:);
at_p410p=travel_time(em_410,p);
em_660=em(ind_660+1:end,:);
at_p660p=travel_time(em_660,p);

dt410=at_pp-at_p410p;
dt660=at_pp-at_p660p;

if nargout == 5
    varargout{1}=at_pp;
    varargout{2}=at_p410p;
    varargout{3}=at_p660p;
end

end

function [tt]=travel_time(earth_model,p)

tt=0;
for i_em=1:size(earth_model,1)
    thickness=earth_model(i_em,1);
    alpha=earth_model(i_em,2);
    eta=sqrt(1/alpha^2-p^2);
    ti=thickness*eta;
    tt=tt+ti;
end

tt=2*tt;

end
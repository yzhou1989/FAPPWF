function [wfpp_region]=stack_region_cph(region,lon_lat_all,wfpp_all)
% region: regionA;
% y_shift: 0;

inr=inpolygon(lon_lat_all(:,1),lon_lat_all(:,2),region(:,1),region(:,2));
n_list=size(lon_lat_all,1);
sinr=inr.*(1:n_list)';
sinr=sinr(sinr>0);

% nsinr=size(sinr,1);
wfpp_region=wfpp_all(sinr,:);
% 
% wfpp_region_stack=sum(wfpp_region)./nsinr;
% 
% indp=170*4;
% mag_f=10;
% 
% for i_r=1:nsinr
%     plot(tpp(1:indp),wfpp_region(i_r,1:indp)*mag_f+y_shift,'color',[127,127,127]/255);
%     plot(tpp(indp+1:end),wfpp_region(i_r,indp+1:end)+y_shift,'color',[127,127,127]/255);
% end
% 
% plot(tpp(1:indp),wfpp_region_stack(1:indp)*mag_f+y_shift,'k','LineWidth',2);
% plot(tpp(indp+1:end),wfpp_region_stack(indp+1:end)+y_shift,'k','LineWidth',2);

end
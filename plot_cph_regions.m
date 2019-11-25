lon_lat_all=ones(size(n_list,2))*NaN;

for i_list=1:n_list
        ff=fullfile(list(i_list).folder,list(i_list).name);
    load(ff);
    if lon<0
        lon=lon+360;
    end
    
    lon_lat_all(i_list,1)=lon;
    lon_lat_all(i_list,2)=lat;
end

wfpp_A=stack_region_cph(regionA,lon_lat_all,wfpp_all);
wfpp_B=stack_region_cph(regionB,lon_lat_all,wfpp_all);
wfpp_C=stack_region_cph(regionC,lon_lat_all,wfpp_all);
wfpp_D=stack_region_cph(regionD,lon_lat_all,wfpp_all);
wfpp_All=stack_region_cph(regionAll,lon_lat_all,wfpp_all);

figure;hold on;
plot_stack(tpp,wfpp_All,1,0.0);
plot_stack(tpp,wfpp_D,1,1.5);
plot_stack(tpp,wfpp_C,1,3.0);
plot_stack(tpp,wfpp_B,1,4.5);
plot_stack(tpp,wfpp_A,1,6.0);

yLim=get(gca,'YLim');
plot([tpp(indp),tpp(indp)],yLim,'k--');
xlim([-200 35]);
xlabel('Time (s)');ylabel('Amplitude');
ylabel('');
set(gca,'XMinorTick','on','YTickLabel',[],'YColor','w');

text(-190,6.2,'Region A');
text(-190,4.7,'Region B');
text(-190,3.2,'Region C');
text(-190,1.7,'Region D');
text(-190,0.2,'All Regions');
% hold off;
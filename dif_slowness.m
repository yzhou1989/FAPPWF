lon=-9.5;
lat=46.5;

figure;hold on;
load pp_wf_0/pp_-9.5_46.5_.mat
plot(out_pp(:,1),out_pp(:,2));
load pp_wf_0055/pp_-9.5_46.5_.mat
plot(out_pp(:,1),out_pp(:,2)+1);
load pp_wf_0065/pp_-9.5_46.5_.mat
plot(out_pp(:,1),out_pp(:,2)+2);
load pp_wf_0075/pp_-9.5_46.5_.mat
plot(out_pp(:,1),out_pp(:,2)+3);

load ../earth_model/pem/pem_-9.5_46.5_.mat

emf='PREM_1s_IDV.csv';
em=importdata(emf,',',2);
emd=em.data;
% plot_em(emd);

emc=gen_cake(emd(:,[2,4,6,3]));
emc_d=del_same_layer(emc);
eml=cake2line(emc_d);
% plot_em(emd);

emdd=[cumsum(emc_d(:,1)),emc_d];

prem_410=emdd(43:62,:);
prem_410(1,2)=prem_410(1,1);
prem_410(end,2)=0;
earth_model=prem_410(:,2:end);
earth_model=num2cell(earth_model);

omiga=0.05; %Hz

ddeg=110;
p=raypar(deg2rayp(ddeg));

pprcm(p,2*pi*omiga,earth_model)


function []=plot_em(emd)
% plot earth_model

figure;
hold on;
plot(emd(:,2),emd(:,3),'k');
plot(emd(:,2),emd(:,4)),'r';
plot(emd(:,2),emd(:,6)),'b';

legend('rho (g/cm^3)','Vp (km/s)','Vs (km/s)');
xlim([0,6371]);
xlabel('Depth (km)');
hold off;

end

function [emc_d]=del_same_layer(emc)
% delete layer with same parameters

size_x=size(emc,1);
index_x=zeros(size_x,1);

emc_d=emc;

for i_x=1:size_x-1
   if emc_d(i_x,[2:4])==emc_d(i_x+1,[2:4])
       emc_d(i_x+1,1)=emc_d(i_x,1)+emc_d(i_x+1,1);
       index_x(i_x)=i_x;
   end
end

index_x=index_x(index_x>0);
emc_d(index_x,:)=[];

end
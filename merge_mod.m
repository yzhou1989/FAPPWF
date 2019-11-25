iasp91_rude=load('IASP91.csv');
iasp91=simplify_model(iasp91_rude);
ak135=load('AK135F_AVG.csv');

%plot
figure;hold on;
plot(ak135(:,1),ak135(:,3));
plot(iasp91(:,1),iasp91(:,3),'r--');

figure;hold on;
plot(ak135(:,1),ak135(:,4));
plot(iasp91(:,1),iasp91(:,4),'r--');

mod_ak135=ak135(:,1:4);
mod_ak135([23,24,25,26,29],:)=[];

rho_570=interp1(mod_ak135(22:23,1),mod_ak135(22:23,2),570);
vp_570=interp1(mod_ak135(22:23,1),mod_ak135(22:23,3),570);
vs_570=interp1(mod_ak135(22:23,1),mod_ak135(22:23,4),570);
v_570=[570,rho_570,vp_570,vs_570];

mod_ak135=[mod_ak135(1:22,:);v_570;mod_ak135(23:end,:)];

%plot
figure;hold on;
plot(ak135(:,1),ak135(:,3));
plot(mod_ak135(:,1),mod_ak135(:,3),'r--');

figure;hold on;
plot(ak135(:,1),ak135(:,4));
plot(mod_ak135(:,1),mod_ak135(:,4),'r--');

ek1_ak135=mod_ak135;
ek1_ak135(24,3)=10.38;
ek1_ak135(25,3)=10.64;

%plot
figure;hold on;
plot(mod_ak135(:,1),mod_ak135(:,3));
plot(ek1_ak135(:,1),ek1_ak135(:,3),'r--');
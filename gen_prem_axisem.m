discont=[6371,6356,6346.6,6291,6151,5971,5771,5701,5600 3630];
depth=6371-discont;

prem_axisem=[depth(1:end-1);depth(2:end)];
prem_axisem=reshape(prem_axisem,[],1);

%% idom=1
% depth=0
prem_axisem(1,2)=5.8;
prem_axisem(1,3)=3.2;
prem_axisem(1,4)=2.6;
% depth=15
prem_axisem(2,2)=5.8;
prem_axisem(2,3)=3.2;
prem_axisem(2,4)=2.6;

%% idom=2
% depth=15
prem_axisem(3,2)=6.8;
prem_axisem(3,3)=3.9;
prem_axisem(3,4)=2.9;
% depth=24.4
prem_axisem(4,2)=6.8;
prem_axisem(4,3)=3.9;
prem_axisem(4,4)=2.9;

%% idom=3
% depth=24.4
x_prem=discont(3)/6371;
prem_axisem(5,2)=4.1875 + 3.9382 * x_prem;
prem_axisem(5,3)=2.1519 + 2.3481 * x_prem;
prem_axisem(5,4)=2.691  + 0.6924 * x_prem;
% depth=80
x_prem=discont(4)/6371;
prem_axisem(6,2)=4.1875 + 3.9382 * x_prem;
prem_axisem(6,3)=2.1519 + 2.3481 * x_prem;
prem_axisem(6,4)=2.691  + 0.6924 * x_prem;

%% idom=4
% depth=80
x_prem=discont(4)/6371;
prem_axisem(7,2)=4.1875 + 3.9382 * x_prem;
prem_axisem(7,3)=2.1519 + 2.3481 * x_prem;
prem_axisem(7,4)=2.691  + 0.6924 * x_prem;
% depth=220
x_prem=discont(5)/6371;
prem_axisem(8,2)=4.1875 + 3.9382 * x_prem;
prem_axisem(8,3)=2.1519 + 2.3481 * x_prem;
prem_axisem(8,4)=2.691  + 0.6924 * x_prem;

%% idom=5
% depth=220
x_prem=discont(5)/6371;
prem_axisem(9,2)=20.3926 - 12.2569 * x_prem;
prem_axisem(9,3)=8.9496 -  4.4597 * x_prem;
prem_axisem(9,4)=7.1089 -  3.8045 * x_prem;
% depth=400
x_prem=discont(6)/6371;
prem_axisem(10,2)=20.3926 - 12.2569 * x_prem;
prem_axisem(10,3)=8.9496 -  4.4597 * x_prem;
prem_axisem(10,4)=7.1089 -  3.8045 * x_prem;

%% idom=6
% depth=400
x_prem=discont(6)/6371;
prem_axisem(11,2)=39.7027 - 32.6166 * x_prem;
prem_axisem(11,3)=22.3512 - 18.5856 * x_prem;
prem_axisem(11,4)=11.2494 -  8.0298 * x_prem;
% depth=600
x_prem=discont(7)/6371;
prem_axisem(12,2)=39.7027 - 32.6166 * x_prem;
prem_axisem(12,3)=22.3512 - 18.5856 * x_prem;
prem_axisem(12,4)=11.2494 -  8.0298 * x_prem;


%% idom=7
% depth=600
x_prem=discont(7)/6371;
prem_axisem(13,2)=19.0957 - 9.8672 * x_prem;
prem_axisem(13,3)=9.9839 - 4.9324 * x_prem;
prem_axisem(13,4)=5.3197 - 1.4836 * x_prem;
x_prem=discont(8)/6371;
prem_axisem(14,2)=19.0957 - 9.8672 * x_prem;
prem_axisem(14,3)=9.9839 - 4.9324 * x_prem;
prem_axisem(14,4)=5.3197 - 1.4836 * x_prem;

% depth=670
%% idom=8
% depth=670
x_prem=discont(8)/6371;
prem_axisem(15,2)=29.2766 - 23.6027 * x_prem + 5.5242 * x_prem^2 - 2.5514 * x_prem^3;
prem_axisem(15,3)=22.3459 - 17.2473 * x_prem - 2.0834 * x_prem^2 + 0.9783 * x_prem^3;
prem_axisem(15,4)=7.9565 -  6.4761 * x_prem + 5.5283 * x_prem^2 - 3.0807 * x_prem^3;
% depth=771
x_prem=discont(9)/6371;
prem_axisem(16,2)=29.2766 - 23.6027 * x_prem + 5.5242 * x_prem^2 - 2.5514 * x_prem^3;
prem_axisem(16,3)=22.3459 - 17.2473 * x_prem - 2.0834 * x_prem^2 + 0.9783 * x_prem^3;
prem_axisem(16,4)=7.9565 -  6.4761 * x_prem + 5.5283 * x_prem^2 - 3.0807 * x_prem^3;
%% idom=9
% depth=771
x_prem=discont(9)/6371;
prem_axisem(17,2)=24.9520 - 40.4673 * x_prem + 51.4832 * x_prem^2 - 26.6419 * x_prem^3;
prem_axisem(17,3)=11.1671 - 13.7818 * x_prem + 17.4575 * x_prem^2 -  9.2777 * x_prem^3;
prem_axisem(17,4)=7.9565 -  6.4761 * x_prem +  5.5283 * x_prem^2 -  3.0807 * x_prem^3;
% depth=2741
x_prem=discont(10)/6371;
prem_axisem(18,2)=24.9520 - 40.4673 * x_prem + 51.4832 * x_prem^2 - 26.6419 * x_prem^3;
prem_axisem(18,3)=11.1671 - 13.7818 * x_prem + 17.4575 * x_prem^2 -  9.2777 * x_prem^3;
prem_axisem(18,4)=7.9565 -  6.4761 * x_prem +  5.5283 * x_prem^2 -  3.0807 * x_prem^3;

%% compare
load('../earth_model/prem_uneft.mat');
figure;hold on;
plot(prem(:,1),prem(:,2),'k');plot(prem_axisem(:,1),prem_axisem(:,2),'r');
plot(prem(:,1),prem(:,3),'k');plot(prem_axisem(:,1),prem_axisem(:,3),'r');
plot(prem(:,1),prem(:,4),'k');plot(prem_axisem(:,1),prem_axisem(:,4),'r');

plot([800 800],[0 15],'b--');

xlim([0 900]);
xlabel('Depth (km)');

save ../earth_model/prem_uneft_axisem.mat prem_axisem;
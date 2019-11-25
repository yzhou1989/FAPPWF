function [em]=get_em(longitude,latitude)
% get_em
% get earth model based on Crust1.0 of specified longitude and latitude
%
% Yong ZHOU
% 2017-08-30

th1=load('xyz-th1');
th2=load('xyz-th2');
th3=load('xyz-th3');
th4=load('xyz-th4');
th5=load('xyz-th5');
th6=load('xyz-th6');
th7=load('xyz-th7');
th8=load('xyz-th8');

vp1=load('xyz-vp1');
vp2=load('xyz-vp2');
vp3=load('xyz-vp3');
vp4=load('xyz-vp4');
vp5=load('xyz-vp5');
vp6=load('xyz-vp6');
vp7=load('xyz-vp7');
vp8=load('xyz-vp8');
vp9=load('xyz-vp9');

vs1=load('xyz-vs1');
vs2=load('xyz-vs2');
vs3=load('xyz-vs3');
vs4=load('xyz-vs4');
vs5=load('xyz-vs5');
vs6=load('xyz-vs6');
vs7=load('xyz-vs7');
vs8=load('xyz-vs8');
vs9=load('xyz-vs9');

ro1=load('xyz-ro1');
ro2=load('xyz-ro2');
ro3=load('xyz-ro3');
ro4=load('xyz-ro4');
ro5=load('xyz-ro5');
ro6=load('xyz-ro6');
ro7=load('xyz-ro7');
ro8=load('xyz-ro8');
ro9=load('xyz-ro9');

long=round(longitude-0.5)+0.5;
lat=round(latitude-0.5)+0.5; % need more test.

index=find((th1(:,1)==long).*(th1(:,2)==lat)==1);

em=[...
    th1(index,3),vp1(index,3),vs1(index,3),ro1(index,3);...
    th2(index,3),vp2(index,3),vs2(index,3),ro2(index,3);...
    th3(index,3),vp3(index,3),vs3(index,3),ro3(index,3);...
    th4(index,3),vp4(index,3),vs4(index,3),ro4(index,3);...
    th5(index,3),vp5(index,3),vs5(index,3),ro5(index,3);...
    th6(index,3),vp6(index,3),vs6(index,3),ro6(index,3);...
    th7(index,3),vp7(index,3),vs7(index,3),ro7(index,3);...
    th8(index,3),vp8(index,3),vs8(index,3),ro8(index,3);...
    0,vp9(index,3),vs9(index,3),ro9(index,3);...
    ];
em(em(:,1)==0,:)=[];
end
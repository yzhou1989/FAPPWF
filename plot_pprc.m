% period=1:100;
% omiga=2*pi./period;
omiga=0:0.01:7;

p=0.075;

earth_model=load('water.em');earth_model=num2cell(earth_model);

n_omiga=size(omiga,2);

f=NaN*ones(size(omiga));
a=NaN*ones(size(omiga));
w=NaN*ones(size(omiga));

for i_omiga=1:n_omiga
    [fi,ai,wi]=pprcm(p,omiga(i_omiga),earth_model);
    f(i_omiga)=fi;
    a(i_omiga)=ai;
    w(i_omiga)=wi;
end

omiga_dl=omiga*earth_model{1,1}/earth_model{1,2};
% omiga_dl=omiga;

figure;hold on;
plot(omiga_dl,abs(f),'k');
plot(omiga_dl,abs(a),'r');
plot(omiga_dl,abs(w),'b');
hold off;

figure;hold on;
plot(omiga_dl,angle(f),'k');
plot(omiga_dl,angle(a),'r');
plot(omiga_dl,angle(w),'b');
hold off;
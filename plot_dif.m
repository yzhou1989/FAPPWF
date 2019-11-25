p=0.055:0.0001:0.075;
t=NaN*ones(size(p));
amp=NaN*ones(size(p));
for i_p=1:length(p)
    [t(i_p),amp(i_p)]=tamp('crust.em',p(i_p),5.3,'no');
end

figure;plot(p,t);
figure;plot(p,amp);
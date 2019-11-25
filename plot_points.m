figure;hold on;

latlim=[-90 90];
lonlim=[-180 180];

axesm('hammer','MapLatLimit',latlim,'MapLonLimit',lonlim,...
    'Frame','on','Grid','on','MeridianLabel','off','ParallelLabel','off');
axis off;

setm(gca,'MLabelLocation',30);

load coastlines;
plotm(coastlat,coastlon,'k');

d410=importdata('d410.all07.c2.vel6.head.dat',' ',5);
d410=d410.data;

plotm(d410(:,2),d410(:,1),'r.');
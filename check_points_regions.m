figure;hold on;

plot(regionA(:,1),regionA(:,2));
plot(regionB(:,1),regionB(:,2));
plot(regionC(:,1),regionC(:,2));
plot(regionD(:,1),regionD(:,2));
plot(regionAll(:,1),regionAll(:,2));

plot(lon_lat_all(:,1),lon_lat_all(:,2),'r.');

xlabel('Longitude (degree)');ylabel('Latitude (degree)');
hold off;
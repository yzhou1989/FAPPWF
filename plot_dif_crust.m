figure;
plot(0:8,tamp_c10(:,1),'k--');hold on;plot(0:8,tamp_c7(:,1),'k');
plot(0:8,tamp_c10(:,2),'r--');hold on;plot(0:8,tamp_c7(:,2),'r');
legend('PP-P410P with 10 km crust','PP-P410P with 7 km crust','PP-P660P with 10 km crust','PP-P660P with 7 km crust');
xlabel('Ocean depth (km)');ylabel('Traveltime difference (s)');
legend('box','off');


figure;
plot(0:8,100*tamp_c10(:,3),'k--');hold on;plot(0:8,100*tamp_c7(:,3),'k');
plot(0:8,100*tamp_c10(:,4),'r--');hold on;plot(0:8,100*tamp_c7(:,4),'r');
legend('P410P/PP with 10 km crust','P410P/PP with 7 km crust','P660P/PP with 10 km crust','P660P/PP with 7 km crust');
xlabel('Ocean depth (km)');ylabel('Amplitude ratio (%)');
legend('box','off');
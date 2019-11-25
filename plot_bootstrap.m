figure;hold on;
plot(tpp,wfpp_stack,'k');
plot(tpp,ci(1,:),'r--');
plot(tpp,ci(2,:),'r--');

xlim([-200 35]);
ylim([-0.1 0.1]);
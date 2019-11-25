leng=1600;

win_660=zeros(leng,1);
win_410=zeros(leng,1);
win_220=zeros(leng,1);
win_surf=zeros(leng,1);
win_660(1:100)=1;
win_410(101:200)=1;
win_220(201:300)=1;
win_surf(301:400)=1;

figure;hold on;
plot(win_660,'r');
plot(win_410,'b');
plot(win_220,'m');
plot(win_surf,'k');
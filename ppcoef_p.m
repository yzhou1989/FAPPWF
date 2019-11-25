p_vec=0:0.001:0.075;

% PP
% em=[3.00070654734708,5.80273241206030,3.20150753768844,2.60000000000000];
em=[3,5.80000000000000,3.20000000000000,2.60000000000000];
alpha=em(2);
beta=em(3);

pp_coef=NaN*ones(size(p_vec));
for i_p=1:length(p_vec)
    p=p_vec(i_p);
    rpp=pp_free(alpha,beta,p);
    pp_coef(i_p)=rpp;
end

% P410P
% em=...
%     [413.108544903257,9.50688494389550,5.08954446491375,3.54000000000000;...
%     413.108544903257,9.74162284374477,5.26026293753140,3.72000000000000];

em=[400,8.91000000000000,4.77000000000000,3.54000000000000;
    400,9.13000000000000,4.93000000000000,3.72000000000000];

p410p_coef=NaN*ones(size(p_vec));
for i_p=1:length(p_vec)
    p=p_vec(i_p);
    [r1,r2,r3,r4]=pupdc(em,p);
    p410p_coef(i_p)=r2;
end

% P660P
% em=...
%     [707.912678035938,11.4769636905806,6.22460445535871,3.99000000000000;...
%     707.912678035938,12.0133748465182,6.64926328714261,4.38000000000000];

em=...
    [670,10.2700000000000,5.57000000000000,3.99000000000000;...
    670,10.7500000000000,5.95000000000000,4.38000000000000];

p660p_coef=NaN*ones(size(p_vec));
for i_p=1:length(p_vec)
    p=p_vec(i_p);
    [r1,r2,r3,r4]=pupdc(em,p);
    p660p_coef(i_p)=r2;
end

figure;hold on;
plot(p_vec,pp_coef);
title('PP reflection coefficient');

figure;hold on;
plot(p_vec,p410p_coef);
plot(p_vec,p660p_coef);
xlabel('slowness (s/km)');
ylabel('reflection coefficient');
legend('P410P','P660P');
title('P410P and P660P reflection coefficient');

figure;hold on;
plot(p_vec,p410p_coef./pp_coef);
plot(p_vec,p660p_coef./pp_coef);
xlabel('slowness (s/km)');
ylabel('amplitude ratio');
legend('P410P/PP','P660P/PP');
title('P410P/PP and P660P/PP amplitude ratio');





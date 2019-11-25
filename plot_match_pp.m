% for check batch_match_pp

% figure 1
figure;hold on;
plot(pp_t,pp_wf);

% figure 2
figure;hold on;
plot(pp_t,ppwf_fil);

% figure 3
figure;hold on;
plot(tp410p+t410,wfp410p./max(abs(wfp410p)));
plot(tpp410,wfpp410./max(abs(wfpp410)));

% figure 4
figure; hold on;
plot(tp660p+t660,wfp660p./max(abs(wfp660p)));
plot(tpp660,wfpp660./max(abs(wfpp660)));
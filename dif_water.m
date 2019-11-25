source_len=5.3;

gauss_mean=source_len/2;
gauss_sigma=source_len/6;

p=0; % s/km

[t,f,a,w]=ppwf('prem.em',p,gauss_mean,gauss_sigma,'simple');
w0=f;
w3=w;

[t,f,a,w]=ppwf('prem_6.em',p,gauss_mean,gauss_sigma,'simple');
w6=w;

figure;
subplot(3,1,1),plot(t-gauss_mean,w0);xlim([-5,50]);
subplot(3,1,2),plot(t-gauss_mean,w3);xlim([-5,50]);ylabel('Amplitude');
subplot(3,1,3),plot(t-gauss_mean,w6);xlim([-5,50]);xlabel('Time (s)');

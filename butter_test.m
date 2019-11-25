% butter_test
% 
% Yong ZHOU
% 2017-12-21

seis=readsac('seis.sac');
x=seis.DATA1;

fs=100;
t=(0:length(x)-1)/fs;

n_order=4;

[b,a]=butter(n_order,[2 10]/(fs/2),'bandpass'); % 2-10 Hz
y=filter(b,a,x);

figure;plot(t,x);hold on;plot(t,y);
xlabel('Time (s)');ylabel('Amplitude');
legend('original','2-10 Hz filter');
title([num2str(n_order),' order butterworth filter']);

xf=fft(x);
yf=fft(y);
freq=fs/2*linspace(0,1,length(x)/2+1);

figure;plot(freq,abs(xf(1:length(x)/2+1)));
hold on;plot(freq,abs(yf(1:length(x)/2+1)));
xlabel('Frequency (Hz)');ylabel('Amplitude');
legend('original','2-10 Hz filter');
title([num2str(n_order),' order butterworth filter']);
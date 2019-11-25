%dif_fil
% based on single_point_tamp

figure;hold on;

plot(t_p,pp_wf);

for n_order=1:6
    
    [b,a]=butter(n_order,[1/max_period 1/min_period]/(fs/2),'bandpass');
    ppwf_fil=filter(b,a,pp_wf);
%     plot(t_p,ppwf_fil);
    plot(t_p,ppwf_fil+0.6*n_order);
    
%     pause;
    
end

legend('origion','1','2','3','4','5','6');
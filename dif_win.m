% dif_win
%
% use single_point_tamp simulate waveform
%
% Yong ZHOU
% 20180423

lwin_vec=15:15:90;
tamp_win=NaN*ones(length(lwin_vec),2);

for i_lwin=1:length(lwin_vec)
    lwin=lwin_vec(i_lwin);
    
    [t,amp,ts,tpdp,wfpdp,tpp,wfpp]=tamp_corr(t_p,ppwf_fil,theo_at(3),0,lwin,'y');
    tamp_win(i_lwin,1)=t;
    tamp_win(i_lwin,2)=amp;
    
    tt=strcat('win length ',num2str(lwin),' s');
    
    figure; hold on;
    plot(t_p,ppwf_fil);
    plot(tpp,wfpp);
    plot(tpdp,wfpdp);
    xlabel('Time (s)');ylabel('Amplitude');
    title(tt);
    
    figure; hold on;
    plot(tpp,wfpp./max(abs(wfpp)));
    plot(tpdp+t,wfpdp./max(abs(wfpdp)));
    xlabel('Time (s)');ylabel('Normalized amplitude');
    title(tt);
    
end

figure;hold on;plot(lwin_vec,tamp_win(:,1),'-o');
xlabel('Window length (s)');ylabel('Differential time (s)');

figure;hold on;plot(lwin_vec,tamp_win(:,2),'-o');
xlabel('Window length (s)');ylabel('Amplitude ratio');
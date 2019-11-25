function []=plot_stack(tpp,wfpp_all,ind,varargin)

n_list=size(wfpp_all,1);


if ind >= 1
    % plot_stack 1
    
    if nargin > 3
        yshift=varargin{1};
    else
        figure;hold on;
        yshift=0;
    end
    
    indp=170*4;
    for i_list=1:n_list
        plot(tpp(1:indp),yshift+wfpp_all(i_list,1:indp)*10,'color',[127,127,127]/255);
        plot(tpp(indp+1:end),yshift+wfpp_all(i_list,indp+1:end),'color',[127,127,127]/255);
    end
    
    % plot stacked seismogram
    wfpp_stack=sum(wfpp_all)./n_list;
    plot(tpp(1:indp),yshift+wfpp_stack(1:indp)*10,'k','LineWidth',2);
    plot(tpp(indp+1:end),yshift+wfpp_stack(indp+1:end),'k','LineWidth',2);
    
    % plot 95% confidence intervals
    ci=bootci(300,@(x)mean(x),wfpp_all);
    plot(tpp(1:indp),yshift+ci(1,1:indp)*10,'k--','LineWidth',1);
    plot(tpp(1:indp),yshift+ci(2,1:indp)*10,'k--','LineWidth',1);
    plot(tpp(indp+1:end),yshift+ci(1,indp+1:end),'k--','LineWidth',1);
    plot(tpp(indp+1:end),yshift+ci(2,indp+1:end),'k--','LineWidth',1);
    
    % t_amp
    twin=30;
    at410=-80.4;
    at660=-120.2;
    t_pp=0;
    [t410,amp410]=tamp_corr(tpp,wfpp_stack,at410,t_pp,twin,'y');
    [t660,amp660]=tamp_corr(tpp,wfpp_stack,at660,t_pp,twin,'y');
    
    [c1_t410,c1_amp410]=tamp_corr(tpp,ci(1,:),at410,t_pp,twin,'y');
    [c1_t660,c1_amp660]=tamp_corr(tpp,ci(1,:),at660,t_pp,twin,'y');
    
    [c2_t410,c2_amp410]=tamp_corr(tpp,ci(2,:),at410,t_pp,twin,'y');
    [c2_t660,c2_amp660]=tamp_corr(tpp,ci(2,:),at660,t_pp,twin,'y');
    
%     text(-190,yshift-0.3,strcat(num2str(t410),'/',num2str(amp410),'/',num2str(c1_t410),'/',num2str(c1_amp410),'/',num2str(c2_t410),'/',num2str(c2_amp410)));
%     text(-190,yshift-0.7,strcat(num2str(t660),'/',num2str(amp660),'/',num2str(c1_t660),'/',num2str(c1_amp660),'/',num2str(c2_t660),'/',num2str(c2_amp660)));
    text(-190,yshift-0.3,strcat(' ',num2str(t410,'%3.2f'),' s / ',num2str(amp410*100,'%2.2f'),'[',num2str(c1_amp410*100,'%2.2f'),',',num2str(c2_amp410*100,'%2.2f'),'] %'));
    text(-190,yshift-0.7,strcat(num2str(t660,'%3.2f'),' s / ',num2str(amp660*100,'%2.2f'),'[',num2str(c1_amp660*100,'%2.2f'),',',num2str(c2_amp660*100,'%2.2f'),'] %'));

    % text(-t410,yshift-0.2,strcat(num2str(ceil(amp410*1000)/1000)));
    % text(-t660,yshift-0.5,strcat(num2str(ceil(amp660*1000)/1000)));
    
    yLim=get(gca,'YLim');
    plot([tpp(indp),tpp(indp)],yLim,'k--');
    
    plot(-t410*ones(1,2),[yshift-0.5,yshift+0.5],'k-');
    plot(-t660*ones(1,2),[yshift-0.5,yshift+0.5],'k-');
    
    xlim([-200,35]);
    xlabel('Time (s)');ylabel('Amplitude');
    
end

if ind >= 2
    
    % plot_stack 2
    
    if nargin < 4
        figure;hold on;
    end
    
    for i_list=1:n_list
        plot(tpp,yshift+wfpp_all(i_list,:),'color',[127,127,127]/255);
    end
    wfpp_stack=sum(wfpp_all)./n_list;
    plot(tpp,yshift+wfpp_stack,'k','LineWidth',2);
    xlim([-200,35]);
    xlabel('Time (s)');ylabel('Amplitude');
    
end

end
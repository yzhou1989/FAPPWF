% com_tamp
% compute time and amplitude of PP reflection waveform
% Yong ZHOU
% zhouy3@sustc.edu.cn
% 2017-08-31

for p=0.055:0.01:0.075 % slowness
    t_start=datestr(now);
    
    % incident waveform
    gauss_mean=5.3/2;
    gauss_sigma=5.3/6;
    
%     file=strcat('tamp_s',num2str(p),'.txt');
    
    lon=-180:1:179;
    lat=-89:1:90;
    
    n_lon=size(lon,2);
    n_lat=size(lat,2);
    
    n_point=n_lon*n_lat;
%     tamp=NaN*ones(n_point,8);
    
    parfor i_p=1:n_point
        i_lon=fix((i_p-1)/n_lat)+1;
        i_lat=mod((i_p-1),n_lat)+1;
        
        loni=lon(i_lon);
        lati=lat(i_lat);
        tic;
        [t,pp]=ppwf(gauss_mean,gauss_sigma,p,strcat('../earth_model/cmem/cmem_',num2str(loni),'_',num2str(lati)),...
            'no');
%         save(strcat(num2str(loni),'_',num2str(lati),'.mat'),t,pp);
        fid=fopen(strcat('wf_',num2str(p),'_',num2str(loni),'_',num2str(lati),'.txt'),'w');
        fprintf(fid,'%0.3f %0.6f\r\n',[t;pp']);
        fclose(fid);
        toc;
%         tamp(i_p,:)=[loni,lati,...
%             t(f==min(f))-gauss_mean,min(f),...
%             t(a==min(a))-gauss_mean,min(a),...
%             t(w==min(w))-gauss_mean,min(w)...
%             ];
    end
    
%     save(file,'tamp','-ascii');
    t_end=datestr(now);
    
end
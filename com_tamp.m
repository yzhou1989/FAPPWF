% com_tamp
% compute time and amplitude of PP reflection waveform
% Yong ZHOU
% zhouy3@sustc.edu.cn
% 2017-08-31

for p=0.055:0.005:0.075 % slowness
    t_start=datestr(now);
    
    % incident waveform
    gauss_mean=5.3/2;
    gauss_sigma=5.3/6;
    
    file=strcat('tamp_2_',num2str(p),'.txt');
    
    lon=-179.5:1:179.5;
    lat=-89.5:1:89.5;
    
    n_lon=size(lon,2);
    n_lat=size(lat,2);
    
    n_point=n_lon*n_lat;
    tamp=NaN*ones(n_point,8);
    
    parfor i_p=1:n_point
        i_lon=fix((i_p-1)/n_lat)+1;
        i_lat=mod((i_p-1),n_lat)+1;
        
        loni=lon(i_lon);
        lati=lat(i_lat);
        tic;
        [t,f,a,w]=ppwf(strcat('../earth_model/em/em_',num2str(loni),'_',num2str(lati)),p,...
            gauss_mean,gauss_sigma,'no');
        toc;
        
        tamp(i_p,:)=[loni,lati,...
            t(f==min(f))-gauss_mean,min(f),...
            t(a==min(a))-gauss_mean,min(a),...
            t(w==min(w))-gauss_mean,min(w)...
            ];
    end
    
    save(file,'tamp','-ascii');
    t_end=datestr(now);
    
end
function [rayp]=deg2rayp(ddeg,varargin)
% distance to slowness
% 
% Yong ZHOU
% 2020-04-25
% zhouyong@scsio.ac.cn

if nargin == 1
    phaseName='PP';
    depth=0;
elseif nargin == 2
    phaseName=varargin{1};
    depth=0;
elseif nargin == 3
    phaseName=varargin{1};
    depth=varargin{2};
else
    
end

if isvector(ddeg)
    rayp=NaN*ones(size(ddeg));
    for i_d=1:length(ddeg)
        rayp(i_d)=s_deg2rayp(ddeg(i_d),phaseName,depth);
    end
elseif isscalar(ddeg)
    rayp=s_deg2rayp(ddeg,phaseName,depth);
else
    warning('Only support input type with scalar and vector.');
    rayp=NaN;
end

end

function [rayp]=s_deg2rayp(ddeg,phaseName,depth)

[status,output]=system(['taup_time -model prem -h ',num2str(depth),' -ph ',phaseName,' --rayp -deg ',num2str(ddeg)]);
if status == 0
    rayp=min(str2num(output));
end

end
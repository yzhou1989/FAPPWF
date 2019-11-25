function [ttime]=deg2ttime(ddeg,varargin)

if nargin == 1
    phase_name='PP';
elseif nargin == 2
    phase_name=varargin{1};
end

if isvector(ddeg)
    ttime=NaN*ones(size(ddeg));
    for i_d=1:length(ddeg)
        ttime(i_d)=s_deg2ttime(ddeg(i_d),phase_name);
    end
elseif isscalar(ddeg)
    ttime=s_deg2ttime(ddeg,phase_name);
else
    warning('Only support input type with scalar and vector.');
    ttime=NaN;
end

end

function [ttime]=s_deg2ttime(ddeg,phase_name)

[status,output]=system(['taup_time -model prem -h 0 -ph ',phase_name,' --time -deg ',num2str(ddeg)]);
if status == 0
    ttime=min(str2num(output));
    if isempty(ttime)
        ttime=NaN;
    end
end

end
function [rayp]=deg2rayp(ddeg)

if isvector(ddeg)
    rayp=NaN*ones(size(ddeg));
    for i_d=1:length(ddeg)
        rayp(i_d)=s_deg2rayp(ddeg(i_d));
    end
elseif isscalar(ddeg)
    rayp=s_deg2rayp(ddeg);
else
    warning('Only support input type with scalar and vector.');
    rayp=NaN;
end

end

function [rayp]=s_deg2rayp(ddeg)

[status,output]=system(['taup_time -model prem -h 0 -ph PP --rayp -deg ',num2str(ddeg)]);
if status == 0
    rayp=min(str2num(output));
end

end
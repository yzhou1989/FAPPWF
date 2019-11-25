function [out_mod]=simplify_model(in_mod)
% simplify_model
%
% Yong ZHOU
% 2018-05-11

del_line=[];

i_line=1;

while i_line<=size(in_mod,1)-1
    e_line=i_line+1;
    while in_mod(i_line,3)==in_mod(e_line,3) && in_mod(i_line,4)==in_mod(i_line,4)
        e_line=e_line+1;
    end
    
    if i_line<=e_line-2
        del_line=[del_line,i_line+1:e_line-2];
    end
    
    i_line=e_line;
end

out_mod=in_mod;
out_mod(del_line,:)=[];

end
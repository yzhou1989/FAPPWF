function [model]=rearrange(model)

del_line=zeros(1,5);

if model(15,1)>model(16,1)
    del_line(1)=1;
end

if model(18,1)<model(17,1)
    del_line(2)=1;
end

if model(21,1)>model(22,1)
    del_line(3:4)=1;
end

if model(24,1)<model(21,1)
    del_line(5)=1;
end

del_line=del_line.*[15,18,20,21,24];
del_line=del_line(del_line>0);

if ~isempty(del_line)
    model(del_line,:)=[];
end

end
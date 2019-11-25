function [model_thk]=dep2thk(model_dep)
% change model based on depth to thickness
%
% Yong ZHOU
% 2017-12-04

nlay=size(model_dep,1);
i_thk=1;
for i_lay=1:nlay-1
    if model_dep(i_lay,1) ~= model_dep(i_lay+1,1)
        model_thk(i_thk,1)=model_dep(i_lay+1,1)-model_dep(i_lay,1);
        model_thk(i_thk,2)=0.5*(model_dep(i_lay,2)+model_dep(i_lay+1,2));
        model_thk(i_thk,3)=0.5*(model_dep(i_lay,3)+model_dep(i_lay+1,3));
        model_thk(i_thk,4)=0.5*(model_dep(i_lay,4)+model_dep(i_lay+1,4));
        i_thk=i_thk+1;
    end
end

end
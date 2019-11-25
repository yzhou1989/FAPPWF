function [line]=cake2line(cake,varargin)
% cake2line
% Yong ZHOU
% 20180314

if nargin>1
    top=varargin{1};
else
    top=0;
end

line=[];
i_line=0;
dep=top;

for i_cake=1:size(cake,1)
    i_line=i_line+1;
    line(i_line,:)=[dep,cake(i_cake,2),cake(i_cake,3),cake(i_cake,4)];
    dep=dep+cake(i_cake,1);
    
    i_line=i_line+1;
    line(i_line,:)=[dep,cake(i_cake,2),cake(i_cake,3),cake(i_cake,4)];
end

end
function [cake]=gen_cake(model,varargin)
% gen_cake
% Yong ZHOU
% 2018-03-12

if nargin <2
    min_thick=6371;
else
    min_thick=varargin{1};
end

cake=[];

for i_layer=1:size(model,1)-1
    if model(i_layer,1)~=model(i_layer+1,1)
        if model(i_layer,2)==model(i_layer+1,2)
            thick=model(i_layer+1,1)-model(i_layer,1);
            vp=model(i_layer,2);
            vs=model(i_layer,3);
            rho=model(i_layer,4);
            cake=[cake;thick,vp,vs,rho];
        else
            max_thick=model(i_layer+1,1)-model(i_layer,1);
            n_layer=floor(max_thick/min_thick);
            thick=ones(n_layer,1)*min_thick;
            
            if n_layer==0
                cake=[cake;max_thick,0.5*(model(i_layer,2)+model(i_layer+1,2)),...
                    0.5*(model(i_layer,3)+model(i_layer+1,3)),...
                    0.5*(model(i_layer,4)+model(i_layer+1,4))];
                continue;
            end
            
            mod_thick=mod(max_thick,min_thick);
            if mod_thick/min_thick > 0.5
                n_layer=n_layer+1;
                thick=[thick;mod_thick];
            else
                thick(end)=thick(end)+mod_thick;
            end
            vp=gen_vec(n_layer,model(i_layer,2),model(i_layer+1,2));
            vs=gen_vec(n_layer,model(i_layer,3),model(i_layer+1,3));
            rho=gen_vec(n_layer,model(i_layer,4),model(i_layer+1,4));
            cake=[cake;thick,vp,vs,rho];
        end
    else
        continue;
    end
end

cake=[cake;cake(end,:)];
cake(end,1)=0;

end

function [vector]=gen_vec(n,firstv,endv)
% gen_vec
% Yong ZHOU
% 2018-03-12

vector=linspace(firstv,endv,n)';
end
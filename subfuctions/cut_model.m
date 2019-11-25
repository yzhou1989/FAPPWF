function [model_cut]=cut_model(model,top,depth)
% cut_model
% Yong ZHOU
% 2018-03-13

%% depth
ind_e=find(model(:,1)==depth);

if size(ind_e,1)>=1
    model_cut=model(1:ind_e(end),:);
else
    ind_eg=find(model(:,1)>depth);
    lt=ind_eg(1)-1;
    gt=ind_eg(1);
    
    e_vp=interp1([model(lt,1),model(gt,1)],[model(lt,2),model(gt,2)],depth);
    e_vs=interp1([model(lt,1),model(gt,1)],[model(lt,3),model(gt,3)],depth);
    e_rho=interp1([model(lt,1),model(gt,1)],[model(lt,4),model(gt,4)],depth);
    
    model_cut=model(1:lt,:);
    model_cut=[model_cut;depth,e_vp,e_vs,e_rho];
end

%% top
if top>0
    ind_s=find(model(:,1)==top);
    
    if size(ind_s)>=1
        model_cut=model_cut(ind_s(end):end,:);
    else
        ind_sg=find(model(:,1)>top);
        lt=ind_sg(1)-1;
        gt=ind_sg(1);
        
        e_vp=interp1([model(lt,1),model(gt,1)],[model(lt,2),model(gt,2)],top);
        e_vs=interp1([model(lt,1),model(gt,1)],[model(lt,3),model(gt,3)],top);
        e_rho=interp1([model(lt,1),model(gt,1)],[model(lt,4),model(gt,4)],top);
        
        model_cut=model_cut(gt:end,:);
        model_cut=[top,e_vp,e_vs,e_rho;model_cut];
        
    end
end

end
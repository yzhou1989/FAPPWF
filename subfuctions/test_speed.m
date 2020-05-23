%%
num=1e6;

em=(1:4);
emc=num2cell(em);

tic;
for i_n=1:num
   [a,b,c,d]=emc{1,:}; 
end
toc;

tic;
for i_n=1:num
    a=em(1,1);
    b=em(1,2);
    c=em(1,3);
    d=em(1,4);
end
toc;

%%
tic;
n_layer=200;
for i_n=1:num
    E=NaN*ones(n_layer,16);
    E_inv=E;
    Lambda_inv=E(:,1:4);
end
toc;

tic;
n_layer=200;
for i_n=1:num
    E=NaN*ones(n_layer,16);
    E_inv=NaN*ones(n_layer,16);
    Lambda_inv=NaN*ones(n_layer,4);
end
toc;

tic;
n_layer=200;
for i_n=1:num
    E=NaN*ones(n_layer,16);
    E_inv=E;
    Lambda_inv=NaN*ones(n_layer,4);
end
toc;

tic;
n_layer=200;
for i_n=1:num
    E=zeros(n_layer,16);
    E_inv=E;
    Lambda_inv=zeros(n_layer,4);
end
toc;

%%
num=2e4;
tic;
for i_n=1:num
    E=gen_E(1,0.1,2,5,3);
    E_inv=inv(E);
end
toc;

tic;
for i_n=1:num
    E=gen_E(1,0.1,2,5,3);
    E_inv=gen_E_inv(1,0.1,2,5,3);
end
toc;

%%
num=1e7;
a=rand(10);
tic;
for i_n=1:num
    b=a*10;
end
toc;

tic;
for i_n=1:num
    b=a.*10;
end
toc;
load tamp_db.mat

crust_thk_vec=0:10:70;

i_var=4;

figure;hold on;
for i_ocean=1:6
    plot(crust_thk_vec,tamp_db(i_ocean,:,i_var));
end
xlabel('Crust Thickness (km)');

switch i_var
    case 1
        tt='t410';
    case 2
        tt='t660';
    case 3
        tt='amp410';
    case 4
        tt='amp660';
end
title(tt);
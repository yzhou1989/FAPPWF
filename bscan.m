ocean_thk_vec=0:2:10;
crust_thk_vec=0:10:70;
for i_ocean=5:length(ocean_thk_vec)
    for i_crust=1:length(crust_thk_vec)
        ocean_thk=ocean_thk_vec(i_ocean);
        crust_thk=crust_thk_vec(i_crust);
        fn=strcat('o',num2str(ocean_thk),'c',num2str(crust_thk));
        emfn=strcat('./pics/wfuf_',fn,'.fig'); % waveform filtered
        open(emfn);
    end
end
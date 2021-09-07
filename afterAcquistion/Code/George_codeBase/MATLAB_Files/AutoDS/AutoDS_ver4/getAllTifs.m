function d_tif = getAllTifs(Exs_llsm_dir)
d_tif=struct();
for ii = 1:length(Exs_llsm_dir)
    d_tif_Ex = dir([char(Exs_llsm_dir{ii}{1}) filesep '*.tif']);
    d_tif(ii).dir = d_tif_Ex;
    d_tif(ii).meta = getMeta2_AO(Exs_llsm_dir{ii}{1});
    d_tif(ii).source = char(Exs_llsm_dir{ii});
end
end
%% section 1
load_data
main_var
main_lp



%% section 2 

cf = 0.68;
Hkeep = 30;

plot_lp_vs_var( cirf_first, cirfboot_first, ...
                  squeeze(irf_yt_spec_1), squeeze(se_yt_spec_1), cf, Hkeep, ...
                  squeeze(irf_ht_spec_1), squeeze(se_ht_spec_1) );

plot_lp_vs_var( cirf_second, cirfboot_second, ...
                  squeeze(irf_yt_spec_2), squeeze(se_yt_spec_2), cf, Hkeep, ...
                  squeeze(irf_ht_spec_2), squeeze(se_ht_spec_2) );

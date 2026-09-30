%% Data load 
load_data


%% Estimate a Var(4)
%we decide the function VARTopicOLS the same function we use 
%in the problem set on the var part


first_model_par = VARTopicOLS([delta_yt, delta_ht], 4);

%model parameter
cl = 0.68;
Maxboot = 1000;
constant =1; 
H = 60;
p = 4;

%% First model specification 
wt_first_specification = [delta_yt, delta_ht];

[irf_first, irfboot_first, cirf_first, cirfboot_first] = ... 
    long_run_chol_boot(wt_first_specification, p, H, constant ,Maxboot,cl,[1 2],0);

%% Second model specification 

wt_second_specification = [delta_yt, ht( 2:end , : ) ];

[irf_second, irfboot_second, cirf_second, cirfboot_second] = ... 
    long_run_chol_boot(wt_second_specification, p, H, constant ,Maxboot,cl,[1],0);


%% EX 2 Plot

varNames   = {'y_t','h_t'};
shockNames = {'shock-\Delta y_t','shock-\Delta h_t'};   % usually same order as VAR variables
plot_irf_boot(irf_first, irfboot_first, cl, varNames, shockNames, 'IRF First Specification' , [1 2]);

varNames   = {'y_t','h_t'};
shockNames = {'shock-\Delta y_t',' shock-h_t'};   % usually same order as VAR variables
plot_irf_boot(irf_second, irfboot_second, cl, varNames, shockNames, 'IRF Second Specification' , [1 2]);

%% Ex 3 Plot 
%first specification

varNames   = {'y_t','h_t'};
shockNames = {'Tech Shock','Non-Tech Shock'};   % usually same order as VAR variables

plot_irf_boot(cirf_first, cirfboot_first, cl, varNames, shockNames, "First Specification");

plot_irf_boot(cirf_first, cirfboot_first, cl, varNames, shockNames, ...
              'First Specification', 1);


%second speicficaiton 

varNames   = {'Y_t','H_t'};
shockNames = {'Tech Shock','Non-Tech Shock'};   % usually same order as VAR variables

plot_irf_boot(cirf_second, cirfboot_second, cl, varNames, shockNames, "Second Specification");

plot_irf_boot(cirf_second, cirfboot_second, cl, varNames, shockNames, ...
              'Second Specification', 1);

%% Ex 4  Variance decomposition
hor = [1,5,9,60];
[irf_first_variance, irfboot_first_variance, cirf_first_variance, cirfboot_first_variance] = ... 
    long_run_chol_boot(wt_first_specification, p, H, constant ,1,cl,[],0);

[irf_second_variance, irfboot_second_variance, cirf_second_variance, cirfboot_second_variance] = ... 
    long_run_chol_boot(wt_second_specification, p, H, constant ,1,cl,[],0);

[vd_first, vdk_first] = TopicsVD(cirf_first_variance, hor);
[vd_second, vdk_second] = TopicsVD(cirf_second_variance, hor);

vdk_first(:,:,1)
vdk_second(:,:,1)

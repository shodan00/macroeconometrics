%to load_data you can simply run the matlab script or uncomment the
%following section
%% Data load 
load_data

%% LP Model Parameter 
H_long = 60;
H_max = 30;
c = 1; %CONSTANT 
yt1 = yt(2:end);
ht1 = ht(2:end);
p = 4; %12 16



%% First specification : ut in delta 
%step1 
wt_spec_1 = [delta_yt, delta_ht]; %controls in delta 

beta_spec_1 = lp_function_hac(yt1, wt_spec_1, wt_spec_1, c, H_long, p);
%build the schock

shock = wt_spec_1 * beta_spec_1(2:3, :, H_long+1);   % (T-1)×1 %create the shock

%standardize the shokck to 1 std 
shock = ((shock)-mean(shock))./std(shock);

%step2 
[irf_spec_1, se_spec_1] = lp_function_hac([yt1, ht1], shock, wt_spec_1, c, H_max, p);

irf_yt_spec_1 = squeeze(irf_spec_1(2,1,:));
irf_ht_spec_1 = squeeze(irf_spec_1(2,2,:));
se_yt_spec_1 = squeeze(se_spec_1(2,1,:));
se_ht_spec_1 = squeeze(se_spec_1(2,2,:));

plot_lp_two_hac(irf_yt_spec_1, se_yt_spec_1, ...
                irf_ht_spec_1, se_ht_spec_1, ...
                0.68, ...
                'LP IRF of y_t to tech shock - First Specification', ...
                'LP IRF of h_t to tech shock - First Specification');

%% Non linearity 
%define the non linear shock
shock_pos = shock .* (shock > 0);          
ShockNL   = [shock shock_pos];       

[beta_nl, se_nl, V_nl] = lp_function_hac([yt1 ht1], ShockNL, wt_spec_1, c, H_max, p);

% coefficients for y response (column 1 of LHS)
beta_y   = squeeze(beta_nl(2,1,:));   % (H_max+1)x1
betaP_y  = squeeze(beta_nl(3,1,:));   % (H_max+1)x1

% coefficients for h response (column 2 of LHS)
beta_h   = squeeze(beta_nl(2,2,:));   % (H_max+1)x1
betaP_h  = squeeze(beta_nl(3,2,:));   % (H_max+1)x1

pospart = @(x) max(x,0);
delta = 1;  % 1-std

Epos = mean( pospart(shock + delta) - pospart(shock) );   % scalar
Eneg = mean( pospart(shock - delta) - pospart(shock) );   % scalar  (delta=-1)

% Nonlinear IRFs for y
irf_y_pos = beta_y  * (+delta) + betaP_y * Epos;
irf_y_neg = beta_y  * (-delta) + betaP_y * Eneg;

% Nonlinear IRFs for h
irf_h_pos = beta_h  * (+delta) + betaP_h * Epos;
irf_h_neg = beta_h  * (-delta) + betaP_h * Eneg;

[se_y_pos, se_y_neg, se_h_pos, se_h_neg] = nl_se_from_hacV(V_nl, 2, 3, delta, Epos, Eneg);

plot_lp_nl_two(irf_y_pos, irf_y_neg, irf_h_pos, irf_h_neg, 0.68, ...
    'NonLinear LP IRFs First Specification', ...
    se_y_pos, se_y_neg, se_h_pos, se_h_neg);

%% Second specification : ht in levels 

%step1 
wt_spec_2 = [delta_yt, ht1];
beta_spec_2 = lp_function_hac(yt1, wt_spec_2, wt_spec_2, c, H_long, p);
%build the schock
shock = wt_spec_2 * beta_spec_2(2:3, :, H_long+1);   % (T-1)×1
%we want 1std 
%shock = shock/std(shock);
shock = ((shock)-mean(shock))./std(shock);
%step2 
[irf_spec_2, se_spec_2] = lp_function_hac([yt1, ht1], shock, wt_spec_2, c, H_max, p);
%irf_spec_2_test = lp_function_hac([yt1, ht1], shock, wt_spec_2, c, H_max, p);
irf_yt_spec_2 = squeeze(irf_spec_2(2,1,:));
irf_ht_spec_2 = squeeze(irf_spec_2(2,2,:));
se_yt_spec_2 = squeeze(se_spec_2(2,1,:));
se_ht_spec_2 = squeeze(se_spec_2(2,2,:));

plot_lp_two_hac(irf_yt_spec_2, se_yt_spec_2, ...
                irf_ht_spec_2, se_ht_spec_2, ...
                0.68, ...
                'LP IRF of y_t to tech shock - Second Specification', ...
                'LP IRF of h_t to tech shock - Second Specification');

%% Non-Linearity Case 

%define the non linear shock
shock_pos = shock .* (shock > 0);          
ShockNL   = [shock shock_pos];       

[beta_nl, se_nl, V_nl] = lp_function_hac([yt1 ht1], ShockNL, wt_spec_2, c, H_max, p);

% coefficients for y response (column 1 of LHS)
beta_y   = squeeze(beta_nl(2,1,:));   % (H_max+1)x1
betaP_y  = squeeze(beta_nl(3,1,:));   % (H_max+1)x1

% coefficients for h response (column 2 of LHS)
beta_h   = squeeze(beta_nl(2,2,:));   % (H_max+1)x1
betaP_h  = squeeze(beta_nl(3,2,:));   % (H_max+1)x1

pospart = @(x) max(x,0);

delta = 1;  % 1-std

Epos = mean( pospart(shock + delta) - pospart(shock) );   % scalar
Eneg = mean( pospart(shock - delta) - pospart(shock) );   % scalar  (delta=-1)

% Nonlinear IRFs for y
irf_y_pos = beta_y  * (+delta) + betaP_y * Epos;
irf_y_neg = beta_y  * (-delta) + betaP_y * Eneg;

% Nonlinear IRFs for h
irf_h_pos = beta_h  * (+delta) + betaP_h * Epos;
irf_h_neg = beta_h  * (-delta) + betaP_h * Eneg;

[se_y_pos, se_y_neg, se_h_pos, se_h_neg] = nl_se_from_hacV(V_nl, 2, 3, delta, Epos, Eneg);

plot_lp_nl_two(irf_y_pos, irf_y_neg, irf_h_pos, irf_h_neg, 0.68, ...
    'NonLinear LP IRFs Second Specification', ...
    se_y_pos, se_y_neg, se_h_pos, se_h_neg);
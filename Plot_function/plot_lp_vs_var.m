
function plot_lp_vs_var(irf_mat, irfboot_4d, lp11, se11, cf, Hkeep, lp21, se21)
% irf_mat      : 2x2xH
% irfboot_4d   : 2x2xH xB
% lp11,se11    : LP + SE for (1,1)
% cf           : conf level
% Hkeep        : horizons to plot from VAR (e.g. 30)
% lp21,se21    : optional LP + SE for (2,1)

if nargin < 5 || isempty(cf), cf = 0.90; end
if nargin < 6 || isempty(Hkeep), Hkeep = size(irf_mat,3); end
if nargin < 7, lp21 = []; end
if nargin < 8, se21 = []; end

H = min(Hkeep, size(irf_mat,3));
x = (1:H)';

lbp = 100*(1-cf)/2;
ubp = 100 - lbp;
z   = sqrt(2)*erfinv(cf);

figure();

subplot(2,1,1); hold on; plot_one(1,1, lp11, se11); title('Response of y_t to technology shock');;
subplot(2,1,2); hold on; plot_one(2,1, lp21, se21); title('Response of h_t to technology shock');;

    function plot_one(i,j, lp, se_lp)
        irf  = squeeze(irf_mat(i,j,1:H));      irf  = irf(:);
        boot = squeeze(irfboot_4d(i,j,1:H,:)); % HxB (after squeeze)

        if size(boot,1) ~= H && size(boot,2) == H
            boot = boot.'; % enforce HxB
        end

        ci = prctile(boot, [lbp ubp], 2);
        irf_lb = ci(:,1); irf_ub = ci(:,2);

        fill([x; flipud(x)], [irf_lb; flipud(irf_ub)], [0 0 0], ...
            'FaceAlpha',0.12,'EdgeColor','none');
        plot(x, irf, 'k-', 'LineWidth', 1.8);

        if ~isempty(lp) && ~isempty(se_lp)
            lp = lp(:); se_lp = se_lp(:);
            Hlp = min([numel(lp), numel(se_lp), H]);
            xl = (1:Hlp)';

            lp_lb = lp(1:Hlp) - z*se_lp(1:Hlp);
            lp_ub = lp(1:Hlp) + z*se_lp(1:Hlp);

            fill([xl; flipud(xl)], [lp_lb; flipud(lp_ub)], [0 0 1], ...
                'FaceAlpha',0.10,'EdgeColor','none');
            plot(xl, lp(1:Hlp), 'b-', 'LineWidth', 1.8);

            %legend({'VAR CI','VAR','LP CI','LP'}, 'Location','best');
        else
            %legend({'VAR CI','VAR'}, 'Location','best');
        end

        yline(0,'k-','LineWidth',0.8);
        grid on; axis tight;
        xlabel('Horizon'); ylabel('Response');
        legend off
    end
end

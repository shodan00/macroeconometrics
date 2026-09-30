function fig = plot_lp_two_hac(irf1, se1, irf2, se2, cf, title1, title2, ylims1, ylims2)
%PLOT_LP_TWO_HAC  Two LP IRFs with HAC CI in one figure (2 rows, 1 column).

    if nargin < 5 || isempty(cf), cf = 0.68; end
    if nargin < 6 || isempty(title1), title1 = 'IRF 1 (HAC CI)'; end
    if nargin < 7 || isempty(title2), title2 = 'IRF 2 (HAC CI)'; end
    if nargin < 8, ylims1 = []; end
    if nargin < 9, ylims2 = []; end

    irf1 = irf1(:); se1 = se1(:);
    irf2 = irf2(:); se2 = se2(:);

    if numel(irf1) ~= numel(se1), error('irf1 and se1 must have same length.'); end
    if numel(irf2) ~= numel(se2), error('irf2 and se2 must have same length.'); end

    p = 0.5 + cf/2;
    z = -sqrt(2) * erfcinv(2*p);

    lo1 = irf1 - z*se1; hi1 = irf1 + z*se1;
    lo2 = irf2 - z*se2; hi2 = irf2 + z*se2;

    h1 = 0:(numel(irf1)-1);
    h2 = 0:(numel(irf2)-1);

    fig = figure('Color','w');

    subplot(2,1,1);
    plot(h1, irf1, 'k', 'LineWidth', 1.5); hold on;
    yline(0,'k-','LineWidth',0.75);
    plot(h1, lo1, 'r--', 'LineWidth', 1.0);
    plot(h1, hi1, 'r--', 'LineWidth', 1.0);
    grid on; axis tight;
    if ~isempty(ylims1), ylim(ylims1); end
    title(title1, 'Interpreter','tex');
    xlabel('h');

    subplot(2,1,2);
    plot(h2, irf2, 'k', 'LineWidth', 1.5); hold on;
    yline(0,'k-','LineWidth',0.75);
    plot(h2, lo2, 'r--', 'LineWidth', 1.0);
    plot(h2, hi2, 'r--', 'LineWidth', 1.0);
    grid on; axis tight;
    if ~isempty(ylims2), ylim(ylims2); end
    title(title2, 'Interpreter','tex');
    xlabel('h');
end

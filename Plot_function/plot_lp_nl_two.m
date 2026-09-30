function fig = plot_lp_nl_two(irf_y_pos, irf_y_neg, irf_h_pos, irf_h_neg, cf, figTitle, ...
                              se_y_pos, se_y_neg, se_h_pos, se_h_neg, ylims1, ylims2)
%PLOT_LP_NL_TWO  Nonlinear LP IRFs (pos vs neg) in one figure (2x1).
% If SEs are provided, adds two-sided Gaussian CI bands.

    if nargin < 5 || isempty(cf), cf = 0.68; end
    if nargin < 6 || isempty(figTitle), figTitle = 'Nonlinear LP IRFs'; end
    if nargin < 7,  se_y_pos = []; end
    if nargin < 8,  se_y_neg = []; end
    if nargin < 9,  se_h_pos = []; end
    if nargin < 10, se_h_neg = []; end
    if nargin < 11, ylims1 = []; end
    if nargin < 12, ylims2 = []; end

    irf_y_pos = irf_y_pos(:); irf_y_neg = irf_y_neg(:);
    irf_h_pos = irf_h_pos(:); irf_h_neg = irf_h_neg(:);

    p = 0.5 + cf/2;
    z = -sqrt(2) * erfcinv(2*p);

    H1 = numel(irf_y_pos); h1 = 0:(H1-1);
    H2 = numel(irf_h_pos); h2 = 0:(H2-1);

    fig = figure('Color','w');

    % ----- y -----
    subplot(2,1,1);
    plot(h1, irf_y_pos, 'k', 'LineWidth', 1.5); hold on;
    plot(h1, irf_y_neg, 'b', 'LineWidth', 1.5);
    yline(0,'k-','LineWidth',0.75);

    if ~isempty(se_y_pos)
        se_y_pos = se_y_pos(:);
        lo = irf_y_pos - z*se_y_pos; hi = irf_y_pos + z*se_y_pos;
        plot(h1, lo, 'k--', 'LineWidth', 1.0);
        plot(h1, hi, 'k--', 'LineWidth', 1.0);
    end
    if ~isempty(se_y_neg)
        se_y_neg = se_y_neg(:);
        lo = irf_y_neg - z*se_y_neg; hi = irf_y_neg + z*se_y_neg;
        plot(h1, lo, 'b--', 'LineWidth', 1.0);
        plot(h1, hi, 'b--', 'LineWidth', 1.0);
    end

    grid on; axis tight;
    if ~isempty(ylims1), ylim(ylims1); end
    title('y_t: positive vs negative shock', 'Interpreter','tex');
    xlabel('h');
    legend({'pos','neg'}, 'Location','best');

    % ----- h -----
    subplot(2,1,2);
    plot(h2, irf_h_pos, 'k', 'LineWidth', 1.5); hold on;
    plot(h2, irf_h_neg, 'b', 'LineWidth', 1.5);
    yline(0,'k-','LineWidth',0.75);

    if ~isempty(se_h_pos)
        se_h_pos = se_h_pos(:);
        lo = irf_h_pos - z*se_h_pos; hi = irf_h_pos + z*se_h_pos;
        plot(h2, lo, 'k--', 'LineWidth', 1.0);
        plot(h2, hi, 'k--', 'LineWidth', 1.0);
    end
    if ~isempty(se_h_neg)
        se_h_neg = se_h_neg(:);
        lo = irf_h_neg - z*se_h_neg; hi = irf_h_neg + z*se_h_neg;
        plot(h2, lo, 'b--', 'LineWidth', 1.0);
        plot(h2, hi, 'b--', 'LineWidth', 1.0);
    end

    grid on; axis tight;
    if ~isempty(ylims2), ylim(ylims2); end
    title('h_t: positive vs negative shock', 'Interpreter','tex');
    xlabel('h');
    legend({'pos','neg'}, 'Location','best');

    if exist('sgtitle','file')
        sgtitle(figTitle, 'Interpreter','tex');
    else
        annotation(fig,'textbox',[0 0.94 1 0.06], 'String', figTitle, ...
            'EdgeColor','none', 'HorizontalAlignment','center', 'FontWeight','bold');
    end
end

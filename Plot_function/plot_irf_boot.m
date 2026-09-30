function plot_irf_boot(irf, irfboot, cf, varNames, shockNames, figTitle, shockIdx)
% shockIdx (optional): which shocks to plot. Example: 1 (tech only) or [1 2] (both)

    if nargin < 3 || isempty(cf), cf = 0.68; end
    if nargin < 6, figTitle = ''; end

    [nvar, nshock, H] = size(irf);

    if nargin < 7 || isempty(shockIdx)
        shockIdx = 1:nshock;
    end
    shockIdx = shockIdx(:)';  % row vector

    if any(shockIdx < 1) || any(shockIdx > nshock)
        error('shockIdx out of bounds.');
    end

    if nargin < 4 || isempty(varNames)
        varNames = arrayfun(@(i) sprintf('y%d', i), 1:nvar, 'UniformOutput', false);
    end

    % If user passes fewer shockNames than nshock, auto-fill
    if nargin < 5 || isempty(shockNames)
        shockNamesAll = arrayfun(@(j) sprintf('shock%d', j), 1:nshock, 'UniformOutput', false);
    else
        shockNamesAll = shockNames;
        if numel(shockNamesAll) < nshock
            auto = arrayfun(@(j) sprintf('shock%d', j), (numel(shockNamesAll)+1):nshock, 'UniformOutput', false);
            shockNamesAll = [shockNamesAll(:)' auto];
        end
    end

    hasBoot = ~isempty(irfboot);
    if hasBoot
        if ndims(irfboot) ~= 4
            error('irfboot must be nvar x nshock x H x nboot');
        end
        lb = (1 - cf)/2 * 100;
        ub = 100 - lb;
        band = prctile(irfboot, [lb ub], 4);  % nvar x nshock x H x 2
    end

    t = 1:H;

    nplotShock = numel(shockIdx);
    fig = figure('Color','w');
    k = 0;

    for i = 1:nvar
        for jj = 1:nplotShock
            j = shockIdx(jj);
            k = k + 1;
            subplot(nvar, nplotShock, k);

            y = squeeze(irf(i,j,:));
            plot(t, y, 'k', 'LineWidth', 1.5); hold on;
            yline(0,'k-','LineWidth',0.75);

            if hasBoot
                lo = squeeze(band(i,j,:,1));
                hi = squeeze(band(i,j,:,2));
                plot(t, lo, 'r--', 'LineWidth', 1.0);
                plot(t, hi, 'r--', 'LineWidth', 1.0);
            end

            grid on; axis tight;
            title(sprintf('%s  \\leftarrow  %s', varNames{i}, shockNamesAll{j}), 'Interpreter','tex');
        end
    end

    if ~isempty(figTitle)
        if exist('sgtitle','file')
            sgtitle(figTitle, 'Interpreter','tex');
        end
    end
end

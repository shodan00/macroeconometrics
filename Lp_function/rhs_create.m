function X = rhs_create(cflag, Shock, Control, H, p)

    [T, ~] = size(Shock);
    [~, k] = size(Control);

    idx_base = (p+1):(T-H);
    T_eff = numel(idx_base);

    Shock_now = Shock(idx_base, :);

    Control_lags = zeros(T_eff, k*p);
    for LAG = 1:p
        cols = (LAG-1)*k + (1:k);
        Control_lags(:, cols) = Control(idx_base - LAG, :);
    end

    if cflag == 1
        X = [ones(T_eff,1), Shock_now, Control_lags];
    else
        X = [Shock_now, Control_lags];
    end
end

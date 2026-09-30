function [beta, se, V] = lp_function_hac(lhs, shock, control, c, H, p)
% beta: K x N x (H+1)
% se  : K x N x (H+1)
% V   : K x K x N x (H+1)   (HAC cov for coefficients)

    % dimensions (compute K at h=0)
    lhs0 = lhs_create(lhs, 0, p);
    X0   = rhs_create(c, shock, control, 0, p);
    [T_eff, K] = size(X0);
    N = size(lhs0, 2);

    beta = nan(K, N, H+1);
    se   = nan(K, N, H+1);
    V    = nan(K, K, N, H+1);

    for h = 0:H
        yH = lhs_create(lhs, h, p);           % (T_eff_h) x N
        XH = rhs_create(c, shock, control, h, p); % (T_eff_h) x K

        BW = h + 1; % Newey–West: maxLag = h  => Bandwidth = h+1

        for j = 1:N
            y = yH(:, j);

            [Cov, se_j, b] = hac(XH, y, ...
                Intercept=false, Type="HAC", Weights="BT", Bandwidth=BW, ...
                Display="off");

            beta(:, j, h+1) = b;
            se(:,   j, h+1) = se_j;
            V(:, :, j, h+1) = Cov;
        end
    end
end

%% This create lhs for lp with lhs = yt+h - yt-1 
function lhs = lhs_create(Y, H, p)
    % Y: T×N (levels of N variables)
    [T,N] = size(Y);
    T_eff = T - p - H;

    lhs = zeros(T_eff, N);

    for s = 1:T_eff
        t = p + s;
        lhs(s, :) = Y(t + H, :) - Y(t - 1, :);
    end
end

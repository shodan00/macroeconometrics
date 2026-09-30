function [se_y_pos, se_y_neg, se_h_pos, se_h_neg] = nl_se_from_hacV(V_nl, shockRow, posRow, delta, Epos, Eneg)
%NL_SE_FROM_HACV  Standard errors for nonlinear IRFs built from (shock, shock_pos).
%
% Inputs
%   V_nl     : K x K x N x (H+1)  HAC covariance of LP coefficients
%   shockRow : row index of coefficient on shock (usually 2 if constant included)
%   posRow   : row index of coefficient on shock_pos (usually 3)
%   delta    : scalar (1 if shock standardized)
%   Epos     : scalar  mean(max(shock+delta,0)-max(shock,0))
%   Eneg     : scalar  mean(max(shock-delta,0)-max(shock,0))
%
% Outputs (all (H+1)x1):
%   se_y_pos, se_y_neg, se_h_pos, se_h_neg

    K = size(V_nl,1);
    N = size(V_nl,3);
    nH = size(V_nl,4);

    if shockRow < 1 || shockRow > K || posRow < 1 || posRow > K
        error('shockRow/posRow out of bounds.');
    end
    if N < 2
        error('This function expects N>=2 (y and h).');
    end

    wpos = [ delta; Epos ];
    wneg = [ -delta; Eneg ];

    se_y_pos = nan(nH,1); se_y_neg = nan(nH,1);
    se_h_pos = nan(nH,1); se_h_neg = nan(nH,1);

    for hh = 1:nH
        % --- y (varIdx = 1) ---
        S_y = V_nl([shockRow posRow],[shockRow posRow], 1, hh); % 2x2
        se_y_pos(hh) = sqrt( wpos' * S_y * wpos );
        se_y_neg(hh) = sqrt( wneg' * S_y * wneg );

        % --- h (varIdx = 2) ---
        S_h = V_nl([shockRow posRow],[shockRow posRow], 2, hh); % 2x2
        se_h_pos(hh) = sqrt( wpos' * S_h * wpos );
        se_h_neg(hh) = sqrt( wneg' * S_h * wneg );
    end
end

%% OLS estimation of VAR(p)
function [para,res] = VARTopicOLS(data,p)

y = data(p+1:end,:); %take all the columns with :
T = size(y,1);
x = size(y,2);
X = [ones(T,1), zeros(T,p*x)];
for j=1:p   
    ii = (x*(j-1)+2):(x*j + 1);
    X(:, ii) = data(p+1-j:end-j,:); %takes all the columns of this matrix
end
%para = inv(X'*X)*X'*y;
para = (X'*X)\(X'*y);
res = y - X*para;

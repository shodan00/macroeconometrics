function [irf_s, irfBoot_s, bqirf,bqBoot] = long_run_chol_boot(y,p,H,c,MaxBoot,cl,ind,opt)
if nargin<8
    opt=0;
end
n=size(y,2); 
lb=(100-cl*100)/2;
ub=100-lb;

%_____________________________________
% OLS estimates
%_____________________________________
[Y X] = VarStr(y,c,p);    % yy and XX all the sample
T=size(Y,1);
Bols=inv(X'*X)*X'*Y;
B=[Bols(2:end,:)';eye(n*(p-1)) zeros(n*(p-1),n)];
C=Bols(1,:)';
u=Y-X*Bols;
CovU=cov(u);
u=u';

for h=1:3*H
    irf=B^(h-1);
    wirf(:,:,h)=irf(1:n,1:n);
end

c1=sum(wirf,3);
c1inv=inv(c1);
S=chol(c1*CovU*c1')';
K=c1inv*S;

% impulse response functions
for h=1:H
    irf=B^(h-1);
    irf_s(:,:,h) = irf(1:n,1:n);
    bqirf(:,:,h)=irf(1:n,1:n)*K;
end
cholu=u'*inv(chol(CovU)')';

%_____________________________________
% Bootstrapping
%_____________________________________
for i=1:MaxBoot
    
    % generate new series
    for t=1:T+1
        if t==1
            YB(:,1)=X(1,2:end)';
        else
            a=randi(size(u,2),1);
            uu=u(:,a);
            YB(:,t)=[C;zeros(n*p-n,1)]+B*YB(:,t-1)+[uu;zeros(n*p-n,1)];
        end
    end

    % estimate the new VAR
    yb=[y(1:p,:);YB(1:n,2:end)'];
    [Yn Xn] = VarStr(yb,c,p);     % yy and XX all the sample
    T=size(Yn,1);
    Bolsn=inv(Xn'*Xn)*Xn'*Yn;
    CovUBoot(:,:,i)=cov(Yn-Xn*Bolsn);
    Bn=[Bolsn(2:end,:)';eye(n*(p-1)) zeros(n*(p-1),n)];
    for h=1:3*H
        irfBoot=Bn^(h-1);
        % cholesky
        wirfboot(:,:,h)=irfBoot(1:n,1:n);
    end
    
    c1boot=sum(wirfboot,3);
    c1invboot=inv(c1boot);
    Sboot=chol(c1boot*CovUBoot(:,:,i)*c1boot')';
    Kboot=c1invboot*Sboot;

    % impulse response functions
    for h=1:H
        irfBoot=Bn^(h-1);
        % cholesky
        irfBoot_s(:,:,h,i) = irfBoot(1:n,1:n);
        bqBoot(:,:,h,i)=irfBoot(1:n,1:n)*Kboot;
    end
end

irf_s(ind,:,:)=cumsum(irf_s(ind,:,:),3);
irfBoot_s(ind,:,:,:)=cumsum(irfBoot_s(ind,:,:,:),3);

bqirf(ind,:,:)=cumsum(bqirf(ind,:,:),3);
bqBoot(ind,:,:,:)=cumsum(bqBoot(ind,:,:,:),3);

if opt==1
    k=0;
    figure(2)
    for ii=1:n
        for jj=1:n
            k=k+1;
            %subplot(n,n,k),plot(1:H,squeeze(bqirf(ii,jj,:)),'k',...
            %1:H,squeeze(prctile(bqBoot(ii,jj,:,:),[lb ub],4)),'--r', ...
            %1:H,squeeze((mean(bqBoot(ii,jj,:,:),4)),'--r','LineWidth',1.5)),axis tight

            subplot(n,n,k),plot(1:H,squeeze(bqirf(ii,jj,:)),'k',...
            1:H,squeeze(prctile(bqBoot(ii,jj,:,:),[lb ub],4)),'--r',...
            1:H,squeeze(mean(bqBoot(ii,jj,:,:),4)),':b', 'LineWidth', 1.5), axis tight
        end
    end
end

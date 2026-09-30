function [vd, vdk] = TopicsVD(irf,hor)
n = size(irf,2);
totvar=sum(sum(irf.^2,3),2);
explvar = sum(irf.^2,3);
vd = 100*explvar./totvar; 

totvark=squeeze(sum(cumsum(irf.^2,3),2));
explvark = cumsum(irf.^2,3);
for j = 1:n 
    tempvd(:,:,j)=squeeze(explvark(:,j,:))./totvark*100;
end
vdk = tempvd(:,hor,:);

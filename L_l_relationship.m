%%%%Finding the relationship between L and l
%clear all
%close all
clc

filename='Delta_0.4.txt';
X=dlmread(filename);
L=X(:,1);
l=X(:,2);
ratio=l./L;
delta=X(:,3);
rho=X(:,4);
kappa=X(:,5);

figure(1);
delta_txt='0.4';
txt = ['Delta= ',delta_txt];
scatter3(l,L,kappa,'g*','DisplayName',txt, 'LineWidth',2)
hold on
plot3(l,L,kappa,'g')
xlabel('l')
ylabel('L')
zlabel('Kappa=k/n')
hold on
title('Phase transition boundary based on logistic regression when Delta=m/n is equal to 0.2, 0.3, 0.4')
legend show

figure(2);
plot(ratio,kappa,'*','DisplayName',txt, 'LineWidth',2)
xlabel('l/L')
ylabel('Kappa=k/n')
hold on
title('Phase transition boundary based on logistic regression when Delta=m/n is equal to 0.2, 0.3, 0.4')
legend show

%%%%finding the average of the kappa for each value of ratio=l/L 
ratio_unique_values=unique(ratio);
[r1,c1]=size(ratio_unique_values);
Kappa_mean=zeros(r1,1);
for i=1:r1
    [r2,c2]=find(ratio==ratio_unique_values(i,:));
    Kappa_mean(i,1)=mean(kappa(r2,1));
end
figure(3);
plot(ratio_unique_values,Kappa_mean,'g*','DisplayName',txt, 'LineWidth',2)
hold on
plot(ratio_unique_values,Kappa_mean,'g','DisplayName',txt, 'LineWidth',1)
xlabel('l/L')
ylabel('Mean of Kappa=k/n')
hold on
title('Phase transition boundary based on logistic regression when Delta=m/n is equal to 0.2, 0.3, 0.4')
legend show

%%%%Linear regression
figure(4);
x1=l./L;
x2=L;
x_total=[ones(length(x1),1),x1,x2];
y=kappa;
b =regress(log(y),x_total);
bb=[0.039411,0.017487,0.341699];
%scatter3(x1,x2,y,'filled')
%hold on
x1fit=linspace(min(x1),max(x1),100);
x2fit=linspace(min(x2),max(x2),100);
[X1FIT,X2FIT] = meshgrid(x1,x2);
%YFIT = b(1) + b(2)*X1FIT + b(3)*X2FIT;
YFIT2 = bb(1,3) + bb(1,1)*X1FIT + bb(1,2)*X2FIT;%%R

txt = ['Delta= ',delta_txt]; 
h3=mesh(X1FIT,X2FIT,YFIT2);%%%change to h1, h2, h3
%hold on
%scatter3(l./L,L,kappa,'r*','DisplayName',txt, 'LineWidth',2)
xlabel('l/L')
ylabel('L')
zlabel('Kappa')
title('Multiple Linear Regression Fit for Delta=0.4')%%fixed Delta=(0.2,0.3,0.4)')
view(50,10)
hold on

%legend([h1, h2, h3], {'Delta=0.2', 'Delta=0.3', 'Delta=0.4'});


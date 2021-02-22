%%%%Plot the logistic regression curves 
clear
clc
close all

filename1='Logit_L10.txt';
filename2='Clean_L10.txt';

X1=csvread(filename1);
[m1,n1]=size(X1);
delta1=X1(:,3);
rho1=X1(:,4);
kappa1=X1(:,5);
[r1,c1]=find(rho1<=1 & rho1>=0);
[r2,c2]=find(kappa1<=1 & kappa1>=0);
Rho_half=rho1(r1,:);
Delta_rho=delta1(r1,:);
Kappa_half=kappa1(r2,:);
Delta_kappa=delta1(r2,:);
l=unique(X1(:,2));

X2=csvread(filename2);
[m2,n2]=size(X2);
delta2=X2(:,6);
rho2=X2(:,7);
kappa2=X2(:,8);
srate=X2(:,9);

[r1,c1]=find(rho2<=1 & rho2>=0);
[r2,c2]=find(kappa2<=1 & kappa2>=0);

Rho=rho2(r1,:);
Delta_rho2=delta2(r1,:);
Kappa=kappa2(r2,:);
Delta_kappa2=delta2(r2,:);
Srate_kappa=srate(r2,:);
Srate_rho=srate(r1,:);

[r3,c3]=find(Srate_kappa>=0.49 & Srate_kappa<=0.51);
[r4,c4]=find(Srate_rho>=0.49 & Srate_rho<=0.51);

Rho=Rho(r4,:);
Delta_rho2=Delta_rho2(r4,:);
Kappa=Kappa(r3,:);
Delta_kappa2=Delta_kappa2(r3,:);
Srate_kappa=Srate_kappa(r3,:);
Srate_rho=Srate_rho(r4,:);

for i=l

figure(1);
plot(Delta_rho,Rho_half,'r')
hold on
plot(Delta_rho,Rho_half,'ro')
plot(Delta_rho2,Rho,'b*')

xlabel('Delta=m/n')
ylabel('Rho=k/m')
title('Phase Transition for n=100, L=1')
figure(2);
plot(Delta_kappa,Kappa_half,'r')
hold on
plot(Delta_kappa,Kappa_half,'ro')
plot(Delta_kappa2,Kappa,'b*')

xlabel('Delta=m/n')
ylabel('Kappa=k/n')
title('Phase Transition for n=100, L=1')

end

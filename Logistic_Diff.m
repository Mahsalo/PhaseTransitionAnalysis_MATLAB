%%%%In this script we find the difference of each logistic curve with the
%%%%reference curve when L=1
close all
clc
clear all

filename='Logit_half_ratio.txt';

filename2='Logit_L1.txt';%%this is the reference curve when L=1
Data=csvread(filename);
Ref=csvread(filename2);
Delta=Ref(:,3);
Rho=Ref(:,4);
Kappa=Ref(:,5);
L=unique(Data(:,1));
%[r2,c2]=find(Kappa>1 | Kappa<0 | Rho>1 | Rho<0);
%Ref(r2,:)=0;
%Rho=Ref(:,4);
%Kappa=Ref(:,5);

for i=L'
    
    [row,col]=find(Data(:,1)==i);
    data=Data(row,:);

    rho=data(:,4);
    kappa=data(:,5);
    rho_diff=Rho-rho;
    kappa_diff=Kappa-kappa;
    [r1,c1]=find(kappa_diff>10^(-2) | kappa_diff<=-1);
    kappa_diff(r1,:)=0;
    
    [r2,c2]=find(rho_diff>10^(-2) | rho_diff<=-1);
    rho_diff(r2,:)=0;
    
    figure(1);
    txt = ['L = ',num2str(i)];
    plot(Delta,kappa_diff,'DisplayName',txt, 'LineWidth',2);
    hold on
    xlabel('Delta=m/n');
    ylabel('Difference between the Kappas (k/n) with the reference Kappa of L=1');
    title('The Difference between varying L curves with reference curve L=1 ')
    
    figure(2);
    txt = ['L = ',num2str(i)];
    plot(Delta,rho_diff,'DisplayName',txt, 'LineWidth',2);
    hold on
    xlabel('Delta=m/n');
    ylabel('Difference between the Rhos (k/m) with the reference Rho of L=1');
    title('The Difference between varying L curves with reference curve L=1 ')
    end
    legend show
    
    
    
    



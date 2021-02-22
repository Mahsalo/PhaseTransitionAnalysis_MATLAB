%%%%%%Finding the difference between Kappas when we have different
%%%%%%Gaussians and the same Gaussians
clear all
close all
clc

%X=dlmread("All_logits_Gaussian_DifferentGaussians.txt");
X=dlmread("All_Logits_Diff_Same.txt");

[r1,c1]=size(X);
[r2,c2]=find(X(:,6)==1);
r3=setdiff([1:r1],r2);
Same_Gaussian_dataset=X(r2,:);
Delta=Same_Gaussian_dataset(:,3);
Different_Gaussian_dataset=X(r3,:);
Diff=Different_Gaussian_dataset(:,5)-Same_Gaussian_dataset(:,5);
Y=[Same_Gaussian_dataset(:,[1,2,3,5]),Different_Gaussian_dataset(:,5),Diff];
[r4,c4]=find(Y(:,4)>=0 & Y(:,5)>=0 & Y(:,4)<=1 & Y(:,5)<=1);
Z=Y(r4,:);
dlmwrite('Kappa_difference.txt',Z,'delimiter',' ')


  




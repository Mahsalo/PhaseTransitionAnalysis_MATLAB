function [rho_half,kappa_half]=EmpiricalPTCurve(Delta,Rho,Kappa,Srate)
% EmpiricalPTCurve This function fits an empirical curve to the data points
% using Logistic Regression (Logit) for a fixed delta=m/n
% in this function for each fixed Delta=m/n and returns the empirical curve
% for varying sparsity levels when the success rate is equal to 1/2

Y=Srate;%Response success rate in PT
X1=Rho;%Data points are Rho values 
X2=Kappa;%Data points are Kappa values

b1 = glmfit(X1,Y,'binomial','link','logit');
b2 = glmfit(X2,Y,'binomial','link','logit');

rho_half=-b1(1,1)/b1(2,1);%%when PI=1/2 we find the zeros of the polynomial with 'b' coeffs.
kappa_half=-b2(1,1)/b2(2,1);




%%test by plotting
% figure;
% yfit = glmval(b2,X2,'logit');
% plot(X2, Y,'o',X2,yfit,'*','LineWidth',2)
% hold on
% yfit1 = glmval(b2,kappa_half,'logit');
% plot(kappa_half,yfit1,'g*')
% 
% str=sprintf('Logistic Regression Fitting, L=2 and l=1 and Delta equal to %f',Delta);
% title(str)
% xlabel('Kappa=k/n')
% ylabel('Success rate for a fixed Delta=m/n')

end

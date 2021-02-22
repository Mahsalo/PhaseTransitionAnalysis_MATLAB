%%%%% In  this Matlab  script we fit a Logistic Regression curve to the
%%%%% data points for each fixed delta=m/n
clear all
close all
clc

%filename='out.txt';
%[L,l,Delta,Rho,Kappa,Srate,Data_cleaned]=FileRead(filename);


%filename= 'l9l1n100.txt';
filename = 'l9l1n200.txt';
X=csvread(filename);
L = X(:,1);
l=X(:,2);
Kappa=X(:,6);
Delta=X(:,7);
Srate=X(:,8);
%L,l,k,m,Monte-Carlos,kappa,delta,success_rate


count=length(Delta);
n=200;
OUTPUT=zeros(n-1,5);
Ind=1;
filename2='Logit_Half_Points1.txt';
Rho = X(:,3)/n;


%filename3='Cleaned_Data.txt';
%[row_size,col_size]=size(Data_cleaned);
%dlmwrite(filename3,Data_cleaned)%%%repeated data was deleted


for i=1:n:count%%%for each fixed Delta, fit a logistic regression model to different K values
    i
    delta=Delta(i:i+n-1,1);
    rho=Rho(i:i+n-1,1);
    kappa=Kappa(i:i+n-1,1);
    srate=Srate(i:i+n-1,1); 
    [rho_half,kappa_half]=EmpiricalPTCurve(Delta(i,1),rho,kappa,srate);
    OUTPUT(Ind,:)=[L(1,1),l(1,1),Delta(i,1), rho_half, kappa_half];
    
    fid = fopen(filename2,'at');
    fprintf(fid, '%i,%i,%f,%f,%f\n',OUTPUT(Ind,:));
    fprintf(fid,'\n');
    fclose(fid);
    Ind=Ind+1;

end


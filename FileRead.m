function [L,l,Delta,Rho,Kappa,Srate,Data]=FileRead(filename)

fid = fopen(filename,'r');
cell1 = cell(100000,1);
ii=1;

while ~feof(fid)
     cell1(ii) = {fgetl(fid)}; 
     ii=ii+1;
end

n=100;
numLines = ii;
fclose(fid);

data=zeros(numLines,  10);
Data=zeros(n*(n-1),10);

for ind=1:numLines-1
    cell2=cell1{ind};
    cell3 = textscan(cell2,'%f');
    X=cell3{1};
    data(ind,:)=X; 
end

%%%delete the repetitions in the delta and k
Ind=1;

for i=2:n%%%for each delta starting from m/n=2/n to 1
    delta_test=i/n;
    [x1,y1]=find(data(:,6)==delta_test);
    data_test=data(x1,:);%%%data with the same delta are grouped together
    [C,ia,ib]=unique(data_test(:,7));%%find the unique Rho values which also show unique 'k' values
    
    data_test2=data_test(ia,:);%%Just get the unique rows with unique 'k' values
    [m3,n3]=size(data_test2);
    if m3~=n%%% Once this happened in L=20 l=10
       data_test3=[data_test2;zeros(n-m3,10)];
       data_test2=data_test3;
    end
    Data(Ind:Ind+n-1,:)=data_test2;
    Ind=Ind+n;
end

[m2,n2]=size(Data);
Delta=zeros(m2,1);
Rho=zeros(m2,1);
Kappa=zeros(m2,1);
Srate=zeros(m2,1);
L=zeros(m2,1);
l=zeros(m2,1);

for ind2=1:m2
    L(ind2,1)=Data(ind2,2);
    Delta(ind2,1)=Data(ind2,6);
    Rho(ind2,1)=Data(ind2,7);
    Kappa(ind2,1)=Data(ind2,8);
    Srate(ind2,1)=Data(ind2,9);
    l(ind2,1)=Data(ind2,10);
end

end
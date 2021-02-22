function P=FindPrimes(a,b)
p=zeros(length(a:b),1);
C=a:b;
i=1;
    for j=C
        if isprime(j)==1
            p(i)=j;
            i=i+1;
        end
    end
    P=p(1:i-1);
    
    
end
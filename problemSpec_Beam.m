function Spec=problemSpec_Beam(start_value,ind)
%%General Properties
Spec.M=30;%%number of Monte-Carlo trials
Spec.threshold= 10^(-2);
Spec.L=6;%%%number of sample vectors
Spec.mask_flag='non-binomial';%%%unknown
Spec.p=0.2;%%%p={0.1,0.7,1/L}
Spec.l=4;%%%number of ones in each row of the mask B, (2,4,6,8) for L=10
Spec.flag='Different_Gaussians';%'Different_Gaussians';%%% Either 'Gaussian' or 'Different_Gaussians', It must be Gaussian for Signed version 
Spec.data_sign='Positive';%%%This could be either 'Positive' or 'Signed' 
Spec.sanity_flag=0;%%%Not a sanity check this time 0
Spec.dense_flag=1; %if dense_flag is 1, it shows that the "Different Gaussian" problem is solved when C is a dense, non-block diagonal matrix

if start_value==1

    if strcmp(ind,'devore')==1
       Spec.n=800;
       q=FindPrimes(ceil(nthroot(Spec.n,3)),floor(sqrt(Spec.n)));
       Spec.q=q;
       Spec.m=Spec.q.^2;
    
    else if strcmp(ind,'array-pc')==1
            Spec.n=43*43;
            q=sqrt(Spec.n);
            if ~mod(q,1)==1%%integer 'q'
                if isprime(q)==1%%prime 'q' 
                    j=3:q-1;
                    Spec.m=j.*q; 
                    Spec.q=q;
                else
                    disp('Choose a n=q^2 such that q is a prime number')
                end
            else
                    disp('Choose a n=q^2 such that q is an integer')
            end

         else if strcmp(ind,'PETF')==1
                Spec.n=1022;%%1022%%510%%258
                m1=[2:Spec.n];
                m2=zeros(length(m1),1);
                for i1=1:length(m1)
                    p1=2*m1(1,i1)-1;
                    p2=Spec.n-1;
                    if Spec.n<2*m1(1,i1) && isprime(p1)==1 && mod(p1,4)==1 
                        m2(i1,1)=m1(1,i1);
                        
                    else if  m1(1,i1)<= Spec.n/2 && isprime(p2)==1 && mod(p2,4)==1
                            m2(i1,1)=m1(1,i1);
                        end
                    end      
                end
                
                [ind1,ind2]=find(m2~=0);         
                Spec.m=m2(ind1,1);
                                    
             else if strcmp(ind,'DG')==1
                     Spec.n=2048;%%it must be dyadic 2^m, m is an odd integer
                     m1=[2:Spec.n];
                     m2=zeros(1,length(m1));
                     
                     for j=1:length(m1)%%since n/m=L is an integer
                         
                        if ~mod(Spec.n/m1(j),1)==1%%if the division results in integer quotient
                            m2(1,j)=m1(j);
                        end
                        
                     end
                     
                     [j1,j2]=find(m2~=0);
                     Spec.m=m2(1,j2);
                 else if strcmp(ind, 'GF')==1
                     Spec.n=2036;%388;%1028;%% n=m.L, m=prime, n<m^2, 0<L<n
                     
                     m1=FindPrimes(2,Spec.n);
                     m2=zeros(1,length(m1));

                     for j=1:length(m1)%%since n/m=L is an integer
                         
                        if  ~mod(Spec.n/m1(j),1)==1 && Spec.n < m1(j)^2 && m1(j)>=5 %%if the division results in integer quotient
                            %%%~mod(Spec.n/m1(j),1)==1 
                            m2(1,j)=m1(j);
                        end
                        
                     end
                     
                     [j1,j2]=find(m2~=0);
                     Spec.m=m2(1,j2);
                                                  
                     else if strcmp(ind, 'Gaussian')==1
                             Spec.n=400;%1024;
                             Spec.m=[2:Spec.n];
                         else if strcmp(ind, 'LC')==1
                                     Spec.n=47*22;%% n=m.L, m=prime, n<m^2, 1<L<n
                                     m1=[2:Spec.n-1];
                                     m2=zeros(1,length(m1));
                     
                                     for j=1:length(m1)%%since n/m=L is an integer
                         
                                        if  isprime(m1(j))==1%%if the division results in integer quotient
                                           %%% ~mod(Spec.n/m1(j),1)==1 
                                              m2(1,j)=m1(j);
                                        end
                        
                                     end
                     
                                     [j1,j2]=find(m2~=0);
                                     Spec.m=m2(1,j2);
                                 
                             end
                         end
                     end
                 end
             end
                     
                     
         end
    end

end


end
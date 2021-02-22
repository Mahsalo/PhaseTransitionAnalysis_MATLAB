%%%Iterative L1-optimization
function [success_rate,binary_monte_carlo]=Iterative_OPT_Beam(A,M,k,threshold,ind,mask_flag,problem_flag)
    frame_ind='Gaussian';%'array-pc';%'PETF';%'devore';'GF';
    Spec=problemSpec_Beam(1,frame_ind);
    n=Spec.n;
    data_sign=Spec.data_sign;
    sum=0;
    binary_monte_carlo = zeros(M,1);
    for i=1:M
        x=XGenBeam(Spec.n,k);
        Xi=ones(n,1);
        %%Kesi is designed in order to generate signed vectors
        %%Kesi would make half of the nonzeros in the object negative
        %%If k=1 that would become negative (Kesi does that!)
        [row1,col1]=find(x~=0);
        if k>1
             half_nonz=floor(length(row1)/2);
             neg_index=randperm(k,half_nonz);
             Xi(row1(neg_index))=-1;
        else
            Xi(row1,:)=-1;
        end
        
        [xbar,Y,w]=sampleGen_Beam(A,x,Xi,ind,mask_flag,problem_flag);
        
        if strcmp(data_sign,'Signed')
            error=norm(Xi.*x-xbar,2)/norm(Xi.*x,2);
        else
            error=norm(x-xbar,2)/norm(x,2);
        end
        
        if error <threshold
            binary_monte_carlo(i,1) = 1;
            sum=sum+1;
        end
        
    end
    
    success_rate=sum/M;
    
end


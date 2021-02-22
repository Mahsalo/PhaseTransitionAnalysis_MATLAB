%%%%This modeule is called in order to find the sparsity of the mask (kind of quantization)

function [binary_least, binary_most,p_least,p_most]=maskSparsity(w,xbar)
    [n,L]=size(w);
    binary_least=zeros(n,L);%%least sparse mask
    binary_most=zeros(n,L);%%most sparse mask

    B=zeros(n,L);
    for i=1:n
            if abs(xbar(i,1))>10^(-3)
                B(i,:)=w(i,:)./xbar(i,1);
            end
    end
    
    for i=1:n
        for j=1:L
            if B(i,j)>0.5
                binary_least(i,j)=1;
                binary_most(i,j)=1;
            end
        end
    end
     
    for i=1:n
        if xbar(i,1)<=10^(-3)
             
            binary_most(i,:)=zeros(1,L);%%%most sparse
            binary_least(i,:)=ones(1,L);%%%least sparse
        
        end
    end

    p_most=sum(sum(binary_most));
    p_least=sum(sum(binary_least));

end

function c=nlcon(X,n,L,A,Y)

x=X(1:n,1);
W=X(n+1:n*(L+1),1);%%%w was rasterized with w'(:), row-wise
w=Vec2Mat(W,L);%%This is the W matrix with dimensions n*L

c=[];
for i=1:n
    for j=1:L
        c1=w(i,j)-abs(x(i,1));
        c2=-w(i,j)-abs(x(i,1));
        c(end+1)=c1;
        c(end+1)=c2;
    end
end

 c3=Y-A*w;
 c3=c3(:);
 c3=c3';
 
 c(end+1:end+length(c3))=c3;
 c4=0.001-norm(x,1);%% x is not all zeros
 c(end+1)=c4;

end
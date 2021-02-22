function M=Vec2Mat(vec,ncol)
%%V2M This function converts a vector into a matrix by having the number of the columns.
nrow=length(vec)/ncol;
M=zeros(nrow,ncol);
for j=1:length(vec)
   r=floor(j/ncol)+1;
   col=mod(j,ncol);
   if col==0
      col=ncol;
      r=r-1;
   end
   M(r,col)=vec(j);
end
end
%%%Generating random conditioned X values
function x=XGenBeam(n,k)

loc = randperm(n,k);
xval = abs(10*rand(k,1));
x = zeros(n,1) ;
x(loc) = xval; 

end






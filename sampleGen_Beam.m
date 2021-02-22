%%Finding samples Y=AX

function [z,Y,w]=sampleGen_Beam(A,X,Xi,ind,mask_flag,problem_flag)

Spec=problemSpec_Beam(1,ind);
n=Spec.n;
m=Spec.m;
p=Spec.p;
data_sign=Spec.data_sign;
z=zeros(n,1);
if strcmp(ind, 'Gaussian')==1
    if strcmp(problem_flag,'Gaussian')==1
    
      if strcmp(mask_flag, 'known')%%known B mask
        B=binornd(1,p,[n,Spec.L]);%%dimensions are n*L         
        Y1=zeros(n,Spec.L);
        for i=1:Spec.L
            Y1(:,i)=B(:,i).*X;
        end
        Y=A*Y1;
        cvx_begin
            warning('off')
            expression Y2(n,Spec.L)
            variable z(n) nonnegative
            minimize norm(z,1)
            subject to          
                for i=1:Spec.L
                    Y2(:,i)=B(:,i).*z;
                end
                Y==A*Y2
            w=B;%%%binary and already given                
        cvx_end
        
    else
        if strcmp(mask_flag, 'unknown')%%unknown B mask
        
%             w_0=zeros(n,Spec.L);
%             for i1=1:n
%                up=X(i1);
%                w_0(i1,:) = (up).*rand(Spec.L,1);    
%             end
%             for i2=1:n%%%force at least one of the samples to be on the border, this is a MUST!
%                 loc=randperm(Spec.L,1);
%                 w_0(i2,loc)=X(i2);
%             end
%            Y=A*w_0;

             B=binornd(1,p,[n,Spec.L]);%%dimensions are n*L                
             Y1=zeros(n,Spec.L);
             [m1,n1]=size(B);
             for ind1=1:m1
                if sum(B(ind1,:))==0
                    loc1=randi(Spec.L,1);
                    B(ind1,loc1)=1;
                end
             end
             
             for i1=1:Spec.L
                    Y1(:,i1)=B(:,i1).*X;
             end
             
             Y=A*Y1;
            
             cvx_begin
                warning('off')
                variable x(n) nonnegative
                variable W(n,Spec.L) 
                minimize norm(x,1)
                subject to
                    Y==A*W
                    for i=1:n
                        for j=1:Spec.L
                             x(i,1)-W(i,j) >=0
                             W(i,j) >= 0
                        end
                    end
             cvx_end
             z=x;
             w=W;
             
        else
            
            if strcmp(mask_flag, 'non-binomial')
                B=zeros(n, Spec.L);
                Y1=zeros(n,Spec.L);
                for ind1=1:n
                    loc1=randperm(Spec.L,Spec.l);
                    B(ind1,loc1)=1;
                end
                
                if strcmp(data_sign,'Positive')
                    for i1=1:Spec.L
                        Y1(:,i1)=B(:,i1).*X;
                    end
                    
                    
                    Y=A*Y1;
                    
                    cvx_begin
                    %%cvx_solver gurobi
                    warning('off')
                    variable x(n) 
                    variable W(n,Spec.L) 
                    minimize norm(x,1)
                    subject to
                        Y==A*W
                        for i=1:n
                            for j=1:Spec.L
                                x(i,1)-W(i,j) >=0
                                W(i,j) >= 0
                            end
                        end
                    cvx_end
                    z=x;
                    w=W;
                    print(w)
                    
                else
                    if strcmp(data_sign,'Signed')
                        True_object=Xi.*X;%%% 'X' is the True envelope here

                        for i1=1:Spec.L
                           Y1(:,i1)=B(:,i1).*True_object;
                        end
 
                        Y=A*Y1;

                        %%%Yalmip
                        M=100000;%%%for big M
                        x_pos=sdpvar(n,1);
%                         y1=binvar(n,Spec.L);
%                         y2=binvar(n,Spec.L);
                        W_var=sdpvar(n,Spec.L);
                        constraints= Y==A*W_var;
                        constraints =[constraints, x_pos>=0];
                        for i=1:n
                                for j=1:Spec.L
%                                     constraints=[constraints, -M*(1-y1(i,j)) <= W_var(i,j)<= x_pos(i,1)+M*(1-y1(i,j))]
%                                     constraints=[constraints, -M*(1-y2(i,j))-x_pos(i,1) <= W_var(i,j)<= M*(1-y2(i,j))]
%                                     constraints=[constraints, W_var(i,j)+M*(1-y1(i,j))>=0]
%                                     constraints=[constraints, -W_var(i,j)+M*(1-y2(i,j))>=0]
%                                     constraints=[constraints, y1(i,j)+y2(i,j)==1]
                                      constraints=[constraints,-x_pos(i,1)<=W_var(i,j)<=x_pos(i,1)]
                                end
                        end
 
                        ops = sdpsettings('solver','GLPK','cachesolvers',1,'verbose',1);%%%bmibnb
                        optimize(constraints,sum(x_pos),ops)
                        w=value(W_var);
                        x_env=value(x_pos);
                        
%                         %%%CVX
%                         cvx_begin
%                         cvx_solver SDPT3
%                         warning('off')
%                         variable W(n,Spec.L)
%                         variable x_env(n) nonnegative
% 
%                         %variable delta binary
%                         %M=100;
%                         minimize norm(x_env,1)
%                         subject to 
%                             Y==A*W
%                             %%%x_neg==-x_neg1;
%                             for i=1:n
%                                 %x(i,1)>=-M*(1-delta)
%                                 %x(i,1)<=M*delta
%                                 
%                                 for j=1:Spec.L
% 
% %                                     W(i,j)>=-x1(i,1)-x2(i,1)
% %                                     W(i,j)<=x1(i,1)+x2(i,1)
% %                                     x1(i,1)-x2(i,1)>0.001+M*(1-delta)
% %                                     -x1(i,1)+x2(i,1)>0.01-M*delta
% 
% %                                     x(i,1)+M*(1-delta)>=W(i,j)  
% %                                     -x(i,1)+M*(delta)>=W(i,j)
% %                                     x(i,1)+M*(1-delta)>=-W(i,j)
% %                                     -x(i,1)+M*(delta)>=-W(i,j)
% %                                     W(i,j)+M*(1-delta)>0
% %                                     W(i,j)-M*delta<0
% 
%                                       %%%These are the most recent codes
%                                       W(i,j)>=-x_env(i,1)
%                                       W(i,j)<=x_env(i,1)
%                                 end
%                             end
%                          cvx_end

%                        w=W;
                        S=sum(w');%%%each row can give us the sign of the real x(n)
                       for i=1:n
                               if S(1,i)>=0
                                    z(i,1)=x_env(i,1);
                                else
                                    z(i,1)=-x_env(i,1);
                               end
                       end

                    end
                end
            end
        end
    end
             
    else if strcmp(problem_flag,'Different_Gaussians')==1
            
                B=zeros(n, Spec.L);
                for ind1=1:n
                    loc1=randperm(Spec.L,Spec.l);
                    B(ind1,loc1)=1;
                end
                B_vec=vec(B);%%%Column-wise vectorized    
                
                if strcmp(data_sign,'Positive')
                     
                     X_updated=kron(eye(Spec.L),diag(X));
                     Y1=A*X_updated*B_vec;%%%Y1 is diag(Y2), Y1 is the column-vectorize version of previous Y(m*L)

                     cvx_begin
                     warning('off')
                     variable x(n) nonnegative
                     variable W(n,Spec.L) 
                     minimize norm(x,1)
                     subject to
                            Y1==A*vec(W);
                     for i=1:n
                        for j=1:Spec.L
                             x(i,1)-W(i,j) >=0
                             W(i,j) >= 0
                        end
                     end
                     cvx_end
                     z=x;
                     w=W;
                     Y=Y1;
                else
                    if strcmp(data_sign,'Signed')
                         True_object=Xi.*X;%%% 'X' is the True envelope here
                         X_updated=kron(eye(Spec.L),diag(True_object));
                         Y1=A*X_updated*B_vec;

                         cvx_begin
                         cvx_solver SDPT3
                         warning('off')
                         variable W(n,Spec.L)
                         variable x_env(n) nonnegative
                         minimize norm(x_env,1)
                         subject to 
                            Y1==A*vec(W)
                            for i=1:n
                                for j=1:Spec.L
                                      W(i,j)>= -x_env(i,1)
                                      W(i,j)<= x_env(i,1)
                                end
                            end
                         cvx_end
                         
                         Y=Y1;
                         w=W;%%n*L
                         S=sum(w');%%%each row can give us the sign of the real x(n), w' L*n, S is of dimensions 1*n
                         [row1,col1]=size(S);
                         if row1==1%%%L=1
                            S=w';%%%1*n
                         end
                         for i=1:n
                                if S(1,i)>=0
                                    z(i,1)=x_env(i,1);
                                else
                                    z(i,1)=-x_env(i,1); 
                                end
                         end
                      
                    end
                end
                
        end
    end

end

%% Using FMINCON                        
%                         objective=@(x) norm(x(1:n,1),1);
%                         x0=0.001*ones(n*(Spec.L+1),1);
%                         A1=[];
%                         b1=[];
%                         Aeq=[];
%                         beq=[];
%                         lb=0;
%                         ub=0;
%                         nonlin=@(x) nlcon(x,n,Spec.L,A,Y)
%                         length(nonlin)
%                         output=fmincon(objective,x0,A1,b1,Aeq,beq,lb,ub,nonlin)
                        
%% Using Optimization Toolbox                        
%                         Optim=optimproblem;
%                         x=optimvar('x',n,1);
%                         x_env=optimvar('x_env',n,1,'LowerBound',0);
%                         W=optimvar('W',n,Spec.L);
%                         Optim.ObjectiveSense='minimize';
%                         %options = optimoptions('fmincon','Display','iter', 'ConstraintTolerance', 1e-12);
% 
%                         Optim.Objective=sum(x_env);
%                         index=1;
%                         LoopConstraints1=optimconstr(n*Spec.L,1);
%                         LoopConstraints2=optimconstr(n*Spec.L,1);
%                         for i=1:n
%                             for j=1:Spec.L
% 
%                                 LoopConstraints1(index,1)=W(i,j)-x_env(i,1) <= 0;
%                                 LoopConstraints2(index,1)=W(i,j)+x_env(i,1) >= 0;
% 
%                                 index=index+1;
%                             end
%                         end
%         
%                         cons_3= A*W == Y;
%                         cons_4= x_env >=x;
%                         cons_5= x_env>=-x;
%                         cons_6= sum(x)>=0.001
%                         Optim.Constraints.cons=LoopConstraints1;
%                         Optim.Constraints.cons2=LoopConstraints2;
% 
%                         Optim.Constraints.cons_3=cons_3;
%                         Optim.Constraints.cons_4=cons_4;
%                         Optim.Constraints.cons_5=cons_5;
%                         
%                         showproblem(Optim);
%                         [sol, fval, exitflag, output] = solve(Optim,'Options',options);
%                         z=sol.x;
%                         w=sol.W;
%                         xenvv=sol.x_env;
                        
                      


function inner_subroutine_Beam(m)


MM=m;
file = 'PTResults_Beam_2.txt';
file2 = 'Binary_monte_carlo_3d.txt';

frame_ind='Gaussian';%'devore';'array-pc';'Gaussian';
data_ind='R';
Spec=problemSpec_Beam(1,frame_ind);
n=Spec.n;
M=Spec.M;%%number of Monte-Carlo trials
L=Spec.L;
p=Spec.p;
l=Spec.l;

dense_flag=Spec.dense_flag;
problem_flag=Spec.flag;
sanity_check_flag=Spec.sanity_flag;
threshold=Spec.threshold;
m=MM;
C=zeros(m*L,n*L);
Replicated_a=makeA_Beam(frame_ind,data_ind,n,m);

%%%% Using just the zones %%%%
filename = "k_zones.txt";
Mat = readmatrix(filename);
delta_mat = Mat(:,1);
D = m/n;
[s1,s2]=find(delta_mat == D);

if length(s1) ~= 0 %%% this should also be commneted to go back to the prevous setting
K1_zone =Mat(s1,2);%%these are kappa values
K2_zone =Mat(s1,3);
K1 = ceil(K1_zone*n);%%%finding the sparsity values from kappas
K2 = ceil(K2_zone*n);
if K1==0
    K1=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %%%for k=1:n %%%%I should  uncomment this when 'm done with the zones
    for k = K1:K2
        if strcmp(problem_flag,'Gaussian')==1
            A=makeA_Beam(frame_ind,data_ind,n,m);
            %A=gpuArray(A);
        else 
            if strcmp(problem_flag,'Different_Gaussians')
                
                if dense_flag == 1 %%if all submatrices are iid Gaussian and C is a dense matrix 
                    for i1=1:L
                        for j1=1:L
                            c_rand=randn(m,n);
                            C((i1-1)*m+1:i1*m,(j1-1)*n+1:j1*n)=c_rand;
                        end
                    end
                     
                else
                     for i1=0:L-1
                        if sanity_check_flag==1
                            C(i1*m+1:(i1+1)*m,i1*n+1:(i1+1)*n)=Replicated_a;%%%same "A" matrix
                        else
                            a=makeA_Beam(frame_ind,data_ind,n,m);
                            C(i1*m+1:(i1+1)*m,i1*n+1:(i1+1)*n)=a;
                        end
                     end

                end
                A=C;
            end
        end
        [success_rate,binary_monte_carlo]=Iterative_OPT_Beam(A,M,k,threshold,frame_ind,Spec.mask_flag,problem_flag);%%we must have several Monte-carlo experiments
        rho=k/m;
        delta=m/n;
        kappa=k/n;
        success_rate
        OUTPUT = [M,L,p,m,k,delta,rho,kappa,success_rate,l];
        Binary_3d_monte_carlo = [kappa,delta,binary_monte_carlo'];
        
        fid = fopen(file,'at');
        fprintf(fid,strjoin([repmat({'%.8g'},1,numel(OUTPUT))]),OUTPUT);
        fprintf(fid,'\n');
		%fprintf(fid, '%i,%i,%f,%f,%f,%f\n',OUTPUT);
		fclose(fid);
        
        fid2 = fopen(file2,'at');
        fprintf(fid2,strjoin([repmat({'%.8g'},1,numel(Binary_3d_monte_carlo))]),Binary_3d_monte_carlo);
        fprintf(fid2,'\n');
        fclose(fid2);

    end
    
    
end
end
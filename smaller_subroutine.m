

function smaller_subroutine(m1,C,Replicated_a,k)
file = 'PTResults_Beam_2.txt';
frame_ind='Gaussian';%'devore';'array-pc';'Gaussian';
data_ind='R';
Spec=problemSpec_Beam(1,frame_ind);
n=Spec.n;
M=Spec.M;%%number of Monte-Carlo trials
L=Spec.L;
p=Spec.p;
l=Spec.l;
problem_flag=Spec.flag;
sanity_check_flag=Spec.sanity_flag;
threshold=Spec.threshold;

m=m1;

 if strcmp(problem_flag,'Gaussian')==1
            A=makeA_Beam(frame_ind,data_ind,n,m);
            %A=gpuArray(A);

        else 
            if strcmp(problem_flag,'Different_Gaussians')

                for i1=0:L-1
                    if sanity_check_flag==1
                        C(i1*m+1:(i1+1)*m,i1*n+1:(i1+1)*n)=Replicated_a;%%%same "A" matrix
                    else
                        a=makeA_Beam(frame_ind,data_ind,n,m);
                        C(i1*m+1:(i1+1)*m,i1*n+1:(i1+1)*n)=a;
                    end
                end
                A=C;
            end
        end
       
        [success_rate]=Iterative_OPT_Beam(A,M,k,threshold,frame_ind,Spec.mask_flag,problem_flag);%%we must have several Monte-carlo experiments
        rho=k/m;
        delta=m/n;
        kappa=k/n;
        OUTPUT=[M,L,p,m,k,delta,rho,kappa,success_rate,l];
        fid = fopen(file,'at');
        fprintf(fid,strjoin([repmat({'%.8g'},1,numel(OUTPUT))]),OUTPUT);
        fprintf(fid,'\n');
		%fprintf(fid, '%i,%i,%f,%f,%f,%f\n',OUTPUT);
		fclose(fid);

end
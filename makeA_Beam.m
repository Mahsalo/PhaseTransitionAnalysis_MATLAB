function A=makeA(ind,data_ind,n,m)


if strcmp(ind, 'devore')==1
        
    A = buildFrame(m,n,'devore',data_ind,0,sqrt(m));

else if strcmp(ind, 'array-pc')==1
        
        A = buildFrame(m,n,'array-pc',data_ind,0,m/sqrt(n));

    else if strcmp(ind, 'PETF')==1
            
            A = buildFrame(m,n,'PETF',data_ind,0);

        else if strcmp(ind, 'DG')==1
                
                A = buildFrame(m,n,'DG',data_ind,0);
                
            else if strcmp(ind,'GF')==1
                    
                    A = buildFrame(m,n,'GF',data_ind,0);
                    
                else if strcmp(ind,'Gaussian')==1
                        
                        A = buildFrame(m,n,'Gaussian',data_ind,0);

                    else if strcmp(ind, 'LC')==1
                            
                            A = buildFrame(m,n,'LC',data_ind,0);
                        end
                    end

                            
                end
            end
        end

end

end

end

%%% Main module to run Phase Transition Computations on the Cluster Using
%%% ClusterJob
    
frame_ind='Gaussian';%'array-pc';%'PETF';%'devore';'GF';
data_ind='R';
Spec=problemSpec_Beam(1,frame_ind);
m=Spec.m;
n=Spec.n;
M=Spec.M;%%number of Monte-Carlo trials
threshold=Spec.threshold;
m= [124,128,132,136,140,144,148,152,156,160,164,168,172,176,180,184,188,192,196,200,204,208,212,216,220,224,228,232,236,240,244,248,252,256,260,264,268,272,276,280];

for i=1:length(m) 
    inner_subroutine_Beam(m(i))
end




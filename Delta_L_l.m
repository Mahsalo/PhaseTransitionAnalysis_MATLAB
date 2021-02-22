%%%Choosing the specific fixed delta to find the relationship between l and L
clear all
close all
clc

filename='Logit_ALL.txt';
X=csvread(filename);
delta=0.6;%[0.2,0.3,0.4];
for Delta=delta
    [r1,c1]=find(X(:,3)==Delta);
    x_filtered=X(r1,:);
    fname = sprintf ( '%s%g%s', 'Delta_', Delta, '.txt' );
    fid=fopen(fname, 'at');
    for i=1:length(r1)
        fprintf(fid,strjoin([repmat({'%.8g'},1,numel(x_filtered(i,:)))]),x_filtered(i,:));
        fprintf(fid,'\n');
    end
    fclose(fid);
end

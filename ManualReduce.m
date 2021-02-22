
%% On Linux Shell
% %path1 = '/Users/mahsa/CJ_get_tmp/7e6c1a2554965961f9fbc76635f94793057e86d6/'
% count=10;%%how many runs we had?
% 
% system('touch ReducedFile.txt')
% 
% for i =1:count
%     path=path1(i);
%     system('cat PTResults1.txt >> ReducedFile.txt')
% end

%% On Matlab


path='/Users/mahsa/CJ_get_tmp/newFile/*/PTResults6.txt';
source='ReducedFile.txt';
files = dir(path);

for file = files'
    File = fopen (file.name, 'rt');
    Source=fopen(source,'at');
           newLines = textscan(File,'%s','delimiter','\n');
           matLines = cell2mat(newLines{1});
           [m1,n1]=size(matLines);

           for j1 =1:m1
                splittedLines=split(matLines(j1,:),',');
                l=length(splittedLines);
                v=zeros(1,l);

                for j2=1:l
                    v(1,j2)=str2num(splittedLines{j2});

                end
                dlmwrite('ReducedFile.txt',v,'-append');
           end

        fclose(File);
        fclose(Source);


end

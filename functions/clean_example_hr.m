function [data_new]=clean_example_hr(data)
% Contact: oliver.carr@eng.ox.ac.uk
% Originally written by Oliver Carr, 30-Nov-2017
N=0;
M=0;
for j=1:3
    for i=3:length(data)-1
        if data(i) > 2*data(i-1) || data(i)<0.333*data(i-1)
            data(i)=mean([data(i-1),data(i-2),data(i+1)]);
            N=N+1;
            M=M+1;
        else
            M=M+1;
        end
    end
end

for i=2:length(data)
    if data(i)>120
        data(i)=data(i-1);
    end
    if data(i)<50
        data(i)=data(i-1);
    end
end

data_new=data;
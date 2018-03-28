function [time,signal]=integrate_signal(time,signal,period)

% Inputs
% Time - vector of times in matlab date format
% Signal - vector of signal to integrate
% Period - time in hours to inegrate over
p=period*60;
for i=p/2:length(time)-(p/2)
    s(i-(p/2)+1)=trapz(time(i-(p/2)+1:i+(p/2)),signal(i-(p/2)+1:i+(p/2)));
    t(i-(p/2)+1)=time(i);
end

% Detrend the integration
flag=[];
ds=diff(s);
for j=2:length(ds)-1
    if abs(ds(j))>mean(abs(ds))+9*std(abs(ds))
        ds(j)=(ds(j-1)+ds(j+1))/2;
        flag=[flag,j];
    end
end
s=[s(1),cumsum(ds)+s(1)];

time=t;

signal=s;

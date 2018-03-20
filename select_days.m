function [time_now,signal_now]=select_days(time,signal,start_time,num_days)

st=start_time/24;
if st==1
    st=0;
end

t=time-floor(time(1));
if t(1)>st
    [~,ind1]=min(abs(t-1-st));
else
    [~,ind1]=min(abs(t-st));
end

if t(ind1)+num_days-t(end)>0.1
    error('Signal too short for required number of days')
else
    [~,ind2]=min(abs(t(ind1)+num_days-t));
end

time_now=time(ind1:ind2);
signal_now=signal(ind1:ind2);
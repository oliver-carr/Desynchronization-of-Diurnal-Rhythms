function [t,sin]=get_sinusoids(time,signal,start_time,num_days)

st=start_time/24;
if st==1
    st=0;
end
time_now=time-floor(time(1));
for i=1:num_days
    [~,ind1]=min(abs(time_now-(st+(i-1))));
    [~,ind2]=min(abs(time_now-(st+i)));
    
    t_now=time_now(ind1:ind2);
    s_now=signal(ind1:ind2);
    t_plot=time(ind1:ind2);
    
    [M,Amp,phi,~] = cosinor(t_now,s_now,2*pi,0.05);
    sin(i).signal = M + Amp*cos(2*pi.*(t_now)+phi);
    t(i).time=t_plot;
end
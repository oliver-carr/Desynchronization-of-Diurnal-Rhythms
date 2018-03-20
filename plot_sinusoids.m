function plot_sinusoids(t,sin,time,signal)

plot(time,signal)
for i=1:length(sin)
    hold on
    plot(t(i).time,sin(i).signal,'r')
end
    


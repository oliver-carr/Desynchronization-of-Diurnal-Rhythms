% Load the example file
[Acc_Time,Acc,VAcc_Time,VAcc,HR_Time,HR]=load_example_data();

% Set parameters
start_time=12; % Time to fit 24 hour sinusoids (0=midnight, 12=midday etc)
num_days=4; % Number of days to fit sinusoids
int_period=8; % Number of hours to integrate over

% Integrate acceleration signals
[IAcc_Time,IAcc]=integrate_signal(Acc_Time,Acc,int_period);
[IVAcc_Time,IVAcc]=integrate_signal(VAcc_Time,VAcc,int_period);

% Select days for analysis
[Acc_time_now,Acc_signal_now]=select_days(IAcc_Time,IAcc,start_time,num_days);
[VAcc_time_now,VAcc_signal_now]=select_days(IVAcc_Time,IVAcc,start_time,num_days);
[HR_time_now,HR_signal_now]=select_days(HR_Time,HR,start_time,num_days);

% Fit sinusoids (Cosinor) to 24 hour periods
[tAcc,sinAcc,AccParams]=get_sinusoids(Acc_time_now,Acc_signal_now,start_time,num_days,1);
[tVAcc,sinVAcc,VAccParams]=get_sinusoids(VAcc_time_now,VAcc_signal_now,start_time,num_days,1);
[tHR,sinHR,HRParams]=get_sinusoids(HR_time_now,HR_signal_now,start_time,num_days,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create Figure 1 from: 
% "Desynchronization of diurnal rhythms in bipolar disorder and borderline
% personality disorder."
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot data
figure
s1=subplot(3,2,1);
plot(Acc_Time,Acc)

s2=subplot(3,2,2);
plot(IAcc_Time,IAcc)

s3=subplot(3,2,3);
plot(VAcc_Time,VAcc)

s4=subplot(3,2,4);
plot(IVAcc_Time,IVAcc)

s5=subplot(3,2,5);
plot(HR_Time,HR)

linkaxes([s1 s2 s3 s4 s5],'x')
axis tight
% Plot sinusoids
figure
subplot(3,1,1)
plot_sinusoids(tAcc,sinAcc,Acc_time_now,Acc_signal_now)
subplot(3,1,2)
plot_sinusoids(tVAcc,sinVAcc,VAcc_time_now,VAcc_signal_now)
subplot(3,1,3)
plot_sinusoids(tHR,sinHR,HR_time_now,HR_signal_now)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the parameters from: 
% "Desynchronization of diurnal rhythms in bipolar disorder and borderline
% personality disorder."
% Parameters are shown in Table 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Average sinusoids
time=linspace(0,2,100);
% Acceleration
AccMesor=mean([AccParams.mesor]);
AccAmp=mean([AccParams.amplitude]);
AccPhi=mean([AccParams.phase]).*24; % Convert to hours
avAcc=AccMesor + AccAmp*cos(2*pi.*(time)-(2*pi*AccPhi/24));

% Vertical Acceleration (Sleep)
VAccMesor=mean([VAccParams.mesor]);
VAccAmp=mean([VAccParams.amplitude]);
VAccPhi=mean([VAccParams.phase]).*24; % Convert to hours;
avVAcc=VAccMesor + VAccAmp*cos(2*pi.*(time)-(2*pi*VAccPhi/24));

% Heart Rate
HRMesor=mean([HRParams.mesor]);
HRAmp=mean([HRParams.amplitude]);
HRPhi=mean([HRParams.phase]).*24; % Convert to hours;
avHR=HRMesor + HRAmp*cos(2*pi.*(time)-(2*pi*HRPhi/24));

% Phase differences
[avHRAcc,avHRVAcc,avAccVAcc]=get_phase_diff(HRParams,AccParams,VAccParams);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Create Figure 2 from: 
% "Desynchronization of diurnal rhythms in bipolar disorder and borderline
% personality disorder."
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
subplot(1,3,1)
plot(time,avAcc)
axis square
datetick
xlabel('Time')
title('Acceleration')

subplot(1,3,2)
plot(time,avVAcc)
axis square
datetick
xlabel('Time')
title('Sleep')

subplot(1,3,3)
plot(time,avHR)
axis square
datetick
xlabel('Time')
title('Heart Rate')



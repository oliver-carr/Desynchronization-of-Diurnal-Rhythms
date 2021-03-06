% Method of measuring desynchronization of diurnal rhythms and quantification 
% of circadian/diurnal variability
% 
% Released under the GNU General Public License
%
% Copyright (C) 2018 Oliver Carr
% University of Oxford, Insitute of Biomedical Engineering, CIBIM Lab - Oxford 2017
% oliver.carr@eng.ox.ac.uk
%
% 
% For more information visit: https://github.com/oliver-carr/Desynchronization-of-Diurnal-Rhythms
% 
% Referencing this work
%
% Carr O, Saunders KEA, Tsanas A, Bilderbeck AC, Palmius N, Geddes JR, Foster R,
% De Vos M, Goodwin GM. Desynchronization of Diurnal Rhythms in Bipolar Disorder
% and Borderline Personality Disorder. Translational Psychiatry [Internet]. In Press.
%
% Carr O, Saunders KEA, Tsanas A, Bilderbeck AC, Palmius N, Geddes JR, Foster R,
% Goodwin GM, De Vos M. Variability in phase and amplitude of diurnal rhythms is 
% related to variation of mood in bipolar and borderline personality disorder. 
% Scientific Reports [Internet]. 2018 Jan 26;8(1).
%
% Last updated : March 2018
% 
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% 
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.


slashchar = char('/'*isunix + '\'*(~isunix));
mainpath = (strrep(which(mfilename),[mfilename '.m'],''));
addpath(genpath(mainpath)) % add subfunctions folder to path

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
plot_sinusoids(tAcc,sinAcc,Acc_time_now-floor(Acc_time_now(1)),Acc_signal_now)
subplot(3,1,2)
plot_sinusoids(tVAcc,sinVAcc,VAcc_time_now-floor(VAcc_time_now(1)),VAcc_signal_now)
subplot(3,1,3)
plot_sinusoids(tHR,sinHR,HR_time_now-floor(HR_time_now(1)),HR_signal_now)

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
% (For one participant, can find average for cohort)
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Circadian/Diurnal variability measures from: 
% "Variability in phase and amplitude of diurnal rhythms is related to variation of mood
% in bipolar and borderline personality disorder."
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t_all_plot=start_time/24:0.001:num_days+start_time/24;

% Get the sinusoids fit to the entire signal
[M1,A1,p1,~] = cosinor(Acc_time_now,Acc_signal_now,2*pi,0.05);
Acc_sin = M1 + A1*cos(2*pi.*(t_all_plot)+p1);

[M2,A2,p2,~] = cosinor(VAcc_time_now,VAcc_signal_now,2*pi,0.05);
VAcc_sin = M2 + A2*cos(2*pi.*(t_all_plot)+p2);

[M3,A3,p3,~] = cosinor(HR_time_now,HR_signal_now,2*pi,0.05);
HR_sin = M3 + A3*cos(2*pi.*(t_all_plot)+p3);

figure
subplot(3,1,1)
plot_sinusoids(tAcc,sinAcc,t_all_plot,Acc_sin);
subplot(3,1,2)
plot_sinusoids(tVAcc,sinVAcc,t_all_plot,VAcc_sin);
subplot(3,1,3)
plot_sinusoids(tHR,sinHR,t_all_plot,HR_sin);

% Get the variability features
AccFeat=get_diurnal_variability(sinAcc,Acc_sin);
VAccFeat=get_diurnal_variability(sinVAcc,VAcc_sin);
HRFeat=get_diurnal_variability(sinHR,HR_sin);









function [avHRAcc,avHRVAcc,avAccVAcc]=get_phase_diff(HRParams,AccParams,VAccParams)

% Set phase between 0 and 1 (time of date in matlab format)
HRPhi=[HRParams.phase];
AccPhi=[AccParams.phase];
VAccPhi=[VAccParams.phase];

avHRAcc=mean(HRPhi-AccPhi).*24; % Convert to hours;
avHRVAcc=mean(HRPhi-VAccPhi).*24; % Convert to hours;
avAccVAcc=mean(AccPhi-VAccPhi).*24; % Convert to hours;
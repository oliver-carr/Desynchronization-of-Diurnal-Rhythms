function features=get_diurnal_variability(daily_sin,total_sin)

% Function to get variability of diurnal rhythms features from sinusoids
% fit to daily and total signals

feat_names={};
daily_sig=[];

% Cycle through daily sinusoids
for i=1:length(daily_sin)
    M(i)=mean(daily_sin(i).signal); % Get MESOR for each daily fit
    A(i)=max(daily_sin(i).signal)-M(i); % Get amplitude for each daily fit
    [~,p(i)]=findpeaks(daily_sin(i).signal); % Get phase for each daily fit
    if i==length(daily_sin)
        daily_sig=[daily_sig,daily_sin(i).signal(1:end)];
    else
        daily_sig=[daily_sig,daily_sin(i).signal(1:end-1)];
    end
end

% For total sinusoid
Mt=mean(total_sin);
At=max(total_sin)-Mt;
[~,pt]=findpeaks(total_sin);
pt=pt(1);

% Mesor features
features(1)=mean(M-Mt);
features(2)=std(M-Mt);
features(3)=mean(diff(M));
features(4)=std(diff(M));
feat_names=[feat_names, {'DW_Mean_Mesor','DW_Std_Mesor','Diff_Mean_Mesor','Diff_Std_Mesor'}];

% Amplitude features
features(5)=mean(A-At);
features(6)=std(A-At);
features(7)=mean(diff(A));
features(8)=std(diff(A));
feat_names=[feat_names, {'DW_Mean_Amp','DW_Std_Amp','Diff_Mean_Amp','Diff_Std_Amp'}];

% Phase features
features(9)=mean(p-pt);
features(10)=std(p-pt);
features(11)=mean(diff(p));
features(12)=std(diff(p));
feat_names=[feat_names, {'DW_Mean_Phase','DW_Std_Phase','Diff_Mean_Phase','Diff_Std_Phase'}];

% RMS
features(13)=sqrt(mean((daily_sig-total_sin).^2));
feat_names=[feat_names, {'RMS_Error'}];

features=array2table(features,'VariableNames',feat_names);




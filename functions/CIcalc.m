function [CI_Amp_min, CI_Amp_max, CI_phi_min, CI_phi_max] = CIcalc(X,T,Z,beta,gamma,n,sigma,Amp,phi,alpha)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Downloaded from: https://uk.mathworks.com/matlabcentral/fileexchange/20329-cosinor-analysis
%
% Confidence Interval Calculations
%
% Description: 
%   SubFuction of 'cosinor.m'. Finds individual confidence intervals for 
%   Amplitude and Acrophase and plots a polar plot representation of the
%   cosinor fit.
%
%   Follows cosinor analysis of a time series as outlined by
%   Nelson et al. "Methods for Cosinor-Rhythmometry" Chronobiologica.
%   1979. Please consult reference.
%
% Parent Function:
%   'cosinor.m'
%
% Example: Run Parent Function
%   Define time series: 
%       y = [102,96.8,97,92.5,95,93,99.4,99.8,105.5];
%       t = [97,130,167.5,187.5,218,247.5,285,315,337.5]/360;
%   Define cycle length and alpha:
%       w = 2*pi;
%       alpha = .05;
%   Run Code:
%       cosinor(t,y,w,alpha)
%
% Record of revisions:
%     Date           Programmmer        Description of change
%     =====          ===========        ======================
%     6/10/08        Casey Cox          Original Code
%     6/24/08        Casey Cox          Revisions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Find beta and gamma confidence region
F_distr = finv(1-alpha,2,n-3);

    A = X;
    B = 2*T;
    C = Z;
    D = -2*X*beta - 2*T*gamma;
    E = -2*T*beta - 2*Z*gamma;
    F = X*beta^2 + 2*T*beta*gamma + Z*gamma^2 - (2/n)*sigma^2*F_distr;

    g_max = -(2*A*E - D*B)/(4*A*C - B^2);

gamma_s = [g_max-Amp*2:Amp/1000:g_max+Amp*2];
beta_s1 = (-(B.*gamma_s + D) + sqrt((B.*gamma_s + D).^2 - 4*A*(C.*gamma_s.^2 + E.*gamma_s + F)))/(2*A);
beta_s2 = (-(B.*gamma_s + D) - sqrt((B.*gamma_s + D).^2 - 4*A*(C.*gamma_s.^2 + E.*gamma_s + F)))/(2*A);

%Isolate ellipse region
IND = find(real(beta_s1) ~= real(beta_s2));
gamma_s = gamma_s(IND); beta_s1 = beta_s1(IND); beta_s2 = beta_s2(IND);

%Determine if confidence region overlaps the pole.
if (range(gamma_s) >= max(gamma_s)) && ((range(beta_s1) >= max(beta_s1)) || (range(beta_s2) >= max(beta_s2)))
    disp('!! Confidence region overlaps the pole. Confidence limits for Amplitude and Acrophase cannot be determined !!');disp(' ');
    
    CI_Amp_max = [0];
    CI_Amp_min = [0];
    CI_phi_max = [0];
    CI_phi_min = [0];
else
    %Confidence Intervals for Amplitude
    CI_Amp_max = max(max([sqrt(beta_s1.^2 + gamma_s.^2); sqrt(beta_s2.^2 + gamma_s.^2)],[],2));
    CI_Amp_min = min(min([sqrt(beta_s1.^2 + gamma_s.^2); sqrt(beta_s2.^2 + gamma_s.^2)],[],2));
    
    %Confidence Intervals for Acrophase
    theta = cat(2,[atan(abs(gamma_s./beta_s1))], [atan(abs(gamma_s./beta_s2))]);
        a = sign(cat(2,[beta_s1],[beta_s2]));
        b = sign(cat(2,[gamma_s],[gamma_s]))*3;
        c = a + b;
        for ii = 1:length(c);
            if (c(ii) == 4 || c(ii) == 3)
                CIphi(ii) = -theta(ii);
                c(ii) = 1;
            elseif (c(ii) == 2 || c(ii) == -1) 
                CIphi(ii) = -pi + theta(ii);
                c(ii) = 2;
            elseif (c(ii) == -4 || c(ii) == -3)
                CIphi(ii) = -pi - theta(ii);
                c(ii) = 3;
            elseif (c(ii) == -2 || c(ii) == 1)
                CIphi(ii) = -2*pi + theta(ii);
                c(ii) = 4;
            end
        end
    if max(c) - min(c) == 3   
        CI_phi_max = min(CIphi(c == 1));
        CI_phi_min = max(CIphi(c == 4));
    else
        CI_phi_max = max(CIphi);
        CI_phi_min = min(CIphi);
    end
end


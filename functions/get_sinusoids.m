function [t,sin,params]=get_sinusoids(time,signal,start_time,num_days,acc)

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



st=start_time/24;
if st==1
    st=0;
end
time_now=time-floor(time(1));
for i=1:num_days
    [~,ind1]=min(abs(time_now-(st+(i-1))));
    [~,ind2]=min(abs(time_now-(st+i)));
    
    t_now=time_now(ind1:ind2)-(i-1);
    s_now=signal(ind1:ind2);
    t_plot=time(ind1:ind2);
    tp=-start_time/24+i:0.001:start_time/24+i;
    
    [M,Amp,phi,~] = cosinor(t_now,s_now,2*pi,0.05);
    sin(i).signal = M + Amp*cos(2*pi.*(tp)+phi);
    t(i).time=tp;
    
    f = M + Amp*cos(2*pi.*(t_now)+phi);
    [~,locs] = findpeaks(-f);
    
    if isempty(locs)
        phi=0;
    else
        phi=t_now(locs)-start_time/24;
    end
    
    if acc==1
        phi=phi-start_time/24;
        if phi<0
            phi=phi+1;
        end
    end
    
    params(i).mesor=M;
    params(i).amplitude=Amp;
    params(i).phase=phi;
end
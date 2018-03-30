function [time,signal]=integrate_signal(time,signal,period)

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

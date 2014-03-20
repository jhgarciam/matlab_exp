function [meandef]=cnm_auto_peaks()

% 	This function finds the peaks automatically. 
%
% [result]=cnm_auto_peaks()

%% 	Bands definition: this can be changed by setting new frequency bands. 
%%	But it has to keep the structure.

bands = [];
bands(1).def = [2,4]; 		%delta
bands(2).def = [4,8];		%theta
bands(3).def = [8,10.5];	%alpha1
bands(4).def = [10.5,13];	%alpha2
bands(5).def = [13,30];		%beta
bands(6).def = [35,55];		%gamma

%% Since the excel file has frequencies up to 300HZ, we define a band of interest, usually 1 to 59 Hz.

BOI = [1 30];

%% load files into matlab
powerFiles = dir('*_all_excel.csv'); %% if we have a differente file standard this has to change
numberOfFiles = length(powerFiles);

if numberOfFiles == 0
	display('Current directory is empty or does not have enough files');
	return;
end

%% loop scanning and loading each file into the structure PowerDefinition.
display(['loading power spectrum files...']);
for ind = 1:numberOfFiles
	powerDefinition(ind).freqpow = load(powerFiles(ind).name);
	display([int2str(ind) '.  ' powerFiles(ind).name]);
end
%print bands
for indb = 1:length(bands)
 	display(['Band#' int2str(indb) ': [' num2str(bands(indb).def) ']']);
end

%% Redefine frequencies according to the BOI.
%% Since the frequency vector is the same, we can use the first one in the list.
FreqGeneral = powerDefinition(1).freqpow(:,1);
FreqLogindex = FreqGeneral>=BOI(1) & FreqGeneral<BOI(2);

colax='bgrcmyk'; 
for indp = 1:length(powerDefinition)
	powerDefinition(indp).freqboi(:,1) = powerDefinition(indp).freqpow(FreqLogindex,1);
	powerDefinition(indp).freqboi(:,2) = powerDefinition(indp).freqpow(FreqLogindex,2);
	%plot(powerDefinition(indp).freqboi(:,1), powerDefinition(indp).freqboi(:,2),colax(indp));
end
keyboard
%%calculate means per band
FreqGeneral = powerDefinition(1).freqboi(:,1);

for indp = 1:length(powerDefinition)
 	for indb = 1:length(bands)
	 	MeanLogindex = FreqGeneral >= bands(indb).def(1) & FreqGeneral < bands(indb).def(2);
		meandef(indp,indb) = mean(powerDefinition(indp).freqboi(MeanLogindex,2));
  	end
end
save 'meandef' meandef;
return;
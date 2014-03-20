function [f,power]=cnm_power_spectra(cfg, data)
% compute power spectrum for data
% cfg = configuration structure containing parameter for power spectrum
% data = data structure from preprocessing
% cfg.channels 'channels', 'all', 'MZ'         for MEG central
    % 'ML'         for MEG left
    % 'MR'         for MEG right
    % 'MLx', 'MRx' and 'MZx' with x=C,F,O,P,T for left/right central, frontal, occipital, parietal and temporal
    %  You can also exclude channels or channel groups using the following syntax
    %  {'all', '-POz', '-Fp1', -EOG'}

if(~isfield(cfg, 'NFFT'))
 cfg.NFFT = 8192;
end

if(~isfield(cfg, 'method'))
 cfg.method = 1;
end

if(~isfield(cfg, 'title'))
 cfg.title = 'no-title';
 display('no title defined in cfg.title');
end

NFFT = cfg.NFFT;
method = cfg.method;
factor = 1e15;   %%% multiplication factor
title = cfg.title;
channel_str = 'all';

%%%% check and validation step %%%%%
nTrials = length(data.trial);
nChannels = length(data.label);
Fs = data.hdr.Fs;

for j=1:nChannels

	fiTrial = data.trial{1}(1, :)*factor;
	if method == 1
  		[hh bb f] = psd(fiTrial, NFFT, Fs);  
	elseif method == 3
  		[hh bb f] = pmtm(fiTrial, 4, NFFT, Fs); 
	end

 	for i=1:nTrials
         
        fTrial = data.trial{i}(j, :)*factor;
        if method == 1
        	 [h(:,i)  b(:,i)] = psd(fTrial, NFFT, Fs);
     	elseif method == 2
         	 [h(:,i) f] = pwelch(fTrial, [], [], NFFT,Fs);
     	elseif method == 3
         	 [h(:,i) b(:,i)] = pmtm(fTrial, 4, NFFT, Fs);
     	end
     	
     	dbPxx(:, i) = h(:,i);
  	
  	end %end trials

	if nTrials > 1 
	 	dbPxxAll(j, :) = mean(dbPxx');
	else
 		dbPxxAll(j, :) = dbPxx';  
	end

end %end channels

power = mean(dbPxxAll);	
power = power*0.0001;

xlswrite(strcat('PSD_', title, '_' , channel_str ,'_excel.xls'),[f(:),power(:)]);
return
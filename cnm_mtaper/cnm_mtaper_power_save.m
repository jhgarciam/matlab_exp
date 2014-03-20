function cnm_mtaper_power_save(data)

%data: structure from fieldtrip's PREPROCESSING

[nwin,mt_win,mt_shift,mt_pad,mt_nw,mt_k,tim,nf,fmin,fmax,freq,norm]=cnm_i_mtaper_power(data);

trials = length(data.trial);
meg = [];
for i = 1:trials;
   meg = [meg, data.trial{i}];
end
meg=meg*1e15;
meg = meg';

%getting spec_fin
xk=tsarr2xk(meg,mt_nw,mt_k,mt_pad,nwin,nf,mt_win,mt_shift,fmin,fmax,norm);
spec=xk2sp(xk);  
spec_fin_log=spec;
spec_fin_avg=exp(mean(spec_fin_log,2));
if ~exist('spec_fin.mat','file')
  save spec_fin spec_fin_avg spec_fin_log freq;
end

semilogy(freq, spec_fin_avg);
grid;
xlim([0.1 100]);


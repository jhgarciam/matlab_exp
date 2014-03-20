
% new power spectra function based on what we had before (multitaper)

function [nwin,mt_win,mt_shift,mt_pad,mt_nw,mt_k,tim,nf,fmin,fmax,freq,norm]=cnm_i_mtaper_setup(data)
% cnm_mtaper_setup
% data = structure from fieldtrip's PREPROCESSING

sp = 1/data.fsample; 
nt = length(data.trial)*length(data.trial{1});

load mt_conf
shift=mt_shift;
mt_win=round(mt_win/sp);
mt_shift=round(mt_shift/sp);
mt_pad=max([mt_pad 2^nextpow2(mt_win)]);
nwin=ceil((nt-mt_win)/mt_shift);
tim=[1:nwin]*shift;

%if exist('trigger','var')
 %  mt_shift=trigger;
  % nwin=length(mt_shift);
  % tim=trigger*meg_hdr.sp;
%else
   mt_shift=(0:nwin-1)*mt_shift+1;
% end

fprintf('Number of windows: %d\n',nwin);
fprintf('Window length: %d\n',mt_win);
fprintf('First window starts @: %d\n',mt_shift(1));
fprintf('Last window ends @: %d\n',mt_shift(end)+mt_win-1);
fprintf('Total number of points: %d\n',nt);

%[nf,fmin,fmax,freq,norm]=tf_setup(meg_hdr,mt_pad);
%tf_setup
load tf_conf
fmin=floor(fmin*sp*mt_pad)+1;
fmax=floor(fmax*sp*mt_pad);
nf=fmax-fmin+1;
freq=(1:mt_pad/2)/(mt_pad*sp);
freq=freq(fmin:fmax);
norm=sqrt(sp);
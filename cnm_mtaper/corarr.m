function spcorr=corarr(xk);
%CORARR spcorr=corarr(xk);
%   xk is 4D array:
%      frequency x taper x time x channel
%   spcorr is 3D array:
%      frequency x frequency x channel
%
%   spcorr - correlation coefficients
%   of log(S(f1,t)) and log(S(f2,t))
%   with their means removed, where
%   f1 and f2 = fmin, ... , fmax

[nf,nk,nt,nch]=size(xk);

spectm=xk2sptm(xk);

for ch=1:nch
   spectmp0=spectm(:,:,ch)';
   spectmp=spectmp0-repmat(mean(spectmp0),nt,1);
   spcorr(:,:,ch)=corrcoef(spectmp);
end;

function xk=tsarr2xk(TS,NW,K,pad,nwin,nf,win,wstep,fmin,fmax,norm); 

% Computation of tapered FT's for subsequent multitaper analysis: X(k,f,nwin,arr)
% for array ot time series ts(time,arrayindex)
% 
% Wrapper for 1D routine ts2tf
%
% function xk=tsarr2tf(TS,NW,K,pad,nwin,nf,win,wstep,fmin,fmax,norm); 
% TS : input time series array
% NW = time bandwidth parameter (e.g. 3 or 4)
% K = number of data tapers kept, usually 2*NW -1 (e.g. 5 or 7 for above)
% pad = padding for individual window. Usually, choose power
% of two greater than but closest to size of moving window.
% 
% win = length of moving window (in sec)
% wstep = number of of timeframes between successive windows (in sec)
% fmin, fmax = range of frequencies to retain. 
% tim = timebase
% fr = frequency base
% Output: xk = complex array(nf,K,nwin)
% In units of (time domain unit)/sqrt(Hz). 

[N nch]=size(TS);
xk=zeros(nf,K,nwin,nch);

for j=1:nch,
    xktmp=ts2xk(TS(:,j),NW,K,pad,nwin,nf,win,wstep,fmin,fmax,norm);
    xk(:,:,:,j)=xktmp;
end

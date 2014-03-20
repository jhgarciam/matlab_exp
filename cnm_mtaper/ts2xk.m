function xk=ts2xk(TS,NW,K,pad,nwin,nf,window,winstart,fmin,fmax,norm);

% Computation of tapered FT's for subsequent multitaper analysis: X(k,f)
% function xk=ts2tf(TS,NW,K,pad,drate,win,wstep,fmin,fmax); 
% TS : input time series
% NW = time bandwidth parameter (e.g. 3 or 4)
% K = number of data tapers kept, usually 2*NW -1 (e.g. 5 or 7 for above)
% pad = padding for individual window. Usually, choose power
%       of two greater than but closest to size of moving window.
% drate = digitisation rate (in Hz)
% win = length of moving window (in sec)
% winstart = vector of the first-point-indecies for each window
% fmin, fmax = range of frequencies to retain.
% tim = timebase
% fr = frequency base
% Output: xk = complex array(nf,K,nwin)
% In units of (time domain unit)/sqrt(Hz).

TS=TS(:)';
[E V]=dpss(window,NW);
N=size(TS,2);
xk=zeros(nf,K,nwin);

for j=1:nwin,
    TSM=TS(winstart(j)+[0:window-1])';
%    TSM=TS((j-1)*winstart+[1:window])';
    xk0=fft(TSM(:,ones(1,K)).*(E(:,1:K)),pad)';
    xk(:,:,j)=xk0(:,fmin:fmax)'*norm;
end






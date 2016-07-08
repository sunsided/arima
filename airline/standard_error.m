function [ s ] = standard_error( acf, lags, N )
%STANDARD_ERROR Calculates the standard error

    % Note that this follows Bartlett's formula for MA(I) processes.
    % https://en.wikipedia.org/wiki/Correlogram

    if ~exist('N', 'var')
       N = lags; 
    end
    
    % square the autocorrelation values in the range
    % we're interested in
    acf_squared = acf(1:lags).^2;

    s = zeros(1, lags+1);
    
    % standard error for no lag is not defined
    s(1) = nan;
    
    % special case for lag one
    s(2) = 1/sqrt(N);

    % remaining lags; +1 for the zero-lag entry
    for h=3:lags+1
        % note that the formula actually states acf_squared(1:(h-1))
        % which does not work due to Matlabs iffy vector indexing.
        s(h) = sqrt( (1 + 2*sum(acf_squared(2:(h-1)))) / N);
    end

end


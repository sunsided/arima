function [ c ] = bartlett_confidence( acf, lags, N )
%BARTLETT_CONFIDENCE Calculates the Bartlett approximation for confidence intervals

    % confidence bands for 95% confidence of the null hypothesis (i.e. no correlation)
    % the ACF confidence bands are using the Bartlett approximation describe on
    % https://en.wikipedia.org/wiki/Correlogram

    if ~exist('N', 'var')
       N = lags; 
    end

    % square the autocorrelation values in the range
    % we're interested in
    acf_squared = acf(1:lags).^2;
    
    % the value at zero lag (index 1) will be zero,
    % as we cannot possibly assume no autocorrelation for
    % zero log.
    c = zeros(1, lags);
    for i=1:lags
        c(i+1) = 1.96 * sqrt( (1 + 2*sum( acf_squared(2:i) )) / N);
    end

end


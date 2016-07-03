function [pi] = my_pacf(x, max_lags)

    % https://www.empiwifo.uni-freiburg.de/lehre-teaching-1/winter-term/dateien-financial-data-analysis/handout-pacf.pdf

    if ~exist('max_lags', 'var')
        max_lags = numel(x);
    end
    
    acf  = nan(max_lags);
    pacf = nan(max_lags, max_lags);

    % pre-calculate the autocorrelation values (rho)
    for tau=1:max_lags
        acf(tau) = my_corr(x, x, tau);
    end

    % If an equation has only one explanatory variable, it makes no 
    % sense to test for additional information of this one variable.
    % Therefore, the autocorrelation coefficient ? and the partial 
    % autocorrelation coefficient ? of the first lag are the same:
    pacf(1, 1) = acf(1);

    for tau=1:max_lags

    term = 0;
    for j=1:tau-1
        % Durbin recursion
        if isnan( pacf(tau-1, j) )
           % pi_{tau,j} = pi_{tau-1,j} - pi_{tau,tau} pi_{tau-1,tau-j}
           pacf(tau-1,j) = pacf(tau-2,j) - pacf(tau-1,tau-1) * pacf(tau-2,tau-1-j);
        end

        term = term + pacf(tau-1, j) * acf(tau-j);
    end

    pacf(tau, tau) = (acf(tau) - term) / (1 - term);

    end

    pi = [1 diag(pacf)'];

end
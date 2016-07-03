function [ phi ] = my_acov( x, lag, my )
%MY_ACOV Autocovariance with a given lag

    if ~exist('my', 'var')
        my = mean(x);
    end

    if ~exist('lag', 'var')
        lag = 0;
    end
    
    % my_acov(x, 5)
    % xcov(x, 5, 'unbiased')
    %phi = mean((x(1:(end-lag)) - my).*(x(1+lag:end) - my));
    
    if iscolumn(x)
        x = x';
    end
       
    % remove the mean from both input signal
    x_error = x(1:(end-lag)) - my;
    y_error = x((1+lag):end) - my;

    N = numel(x_error);
    phi = (x_error * y_error') / N;
    
    % note that dividing by N gives the unbiased estimator
    % while dividing by N+1 gives the biased estimator.
    
end


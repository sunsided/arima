function [ rho ] = my_corr( x, y, lag, my_x, my_y, sigma_x, sigma_y )
%MY_CORR Cross-Correlation

    if ~exist('my_x', 'var')
        my_x = mean(x);
    end

    if ~exist('sigma_x', 'var')
        sigma_x = std(x);
    end
    
    if ~exist('my_y', 'var')
        my_y = mean(y);
    end
    
    if ~exist('sigma_y', 'var')
        sigma_y = std(y);
    end
    
    if ~exist('lag', 'var')
        lag = 0;
    end
    
    lags = numel(lag);
    if lags > 1
       
        rho_arr = nan(1, lags);
        for i=1:lags
            rho_arr(i) = my_corr(x, y, i-1, my_x, my_y, sigma_x, sigma_y);
        end
        
        rho = rho_arr;
        return
    end
    
    % The number of elements must match
    N = numel(x);
    assert(N == numel(y));

    % remove the mean from both input signal
    x_error = x(1:(end-lag)) - my_x;
    y_error = y((1+lag):end) - my_y;
    
    if iscolumn(x_error)
        x_error = x_error';
    end
    
    if iscolumn(x_error)
        y_error = y_error';
    end
    
    phi = (x_error * y_error') / (N-1);
    rho = phi / (sigma_x*sigma_y);    
    
end


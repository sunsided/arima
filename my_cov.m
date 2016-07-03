function [ phi ] = my_cov( x, y, my_x, my_y )
%MY_COV Covariance

    if ~exist('my_x', 'var')
        my_x = mean(x);
    end

    if ~exist('my_y', 'var')
        my_y = mean(y);
    end
    
    % cov(x,1)
    % phi = mean((x - my_x).*(y - my_y));
    
    % The number of elements must match
    N = numel(x);
    assert(N == numel(y));

    % remove the mean from both input signal
    x_error = x - my_x;
    y_error = y - my_y;
    
    %phi = sum(x_error .* y_error) / (N-1);
    
    % The inner product is equivalent to multiplying piecewise,
    % then summing the products.
    
    if iscolumn(x_error)
        x_error = x_error';
    end
    
    if iscolumn(x_error)
        y_error = y_error';
    end
    
    phi = (x_error * y_error') / (N-1);
    
end


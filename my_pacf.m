function [pi] = my_pacf(x, max_lags)

    % https://www.empiwifo.uni-freiburg.de/lehre-teaching-1/winter-term/dateien-financial-data-analysis/handout-pacf.pdf

    % Note that matlab parcorr results differ due to the different
    % approach taken (ordinary least squares fitting as opposed
    % to the Levinson-Durbin recursion).
    % There is a short discussion on the effects here:
    % http://de.mathworks.com/matlabcentral/answers/122337-wrong-function-partial-autocorrelation-pacf-parcorr-greater-than-1-1
    % There also is a paper about the problems of using Yule-Walker
    % variants (such as the Levinson-Durbin recursion) here
    % http://www-stat.wharton.upenn.edu/~steele/Courses/956/Resource/YWSourceFiles/WhyNotToUseYW.pdf
    
    if ~exist('max_lags', 'var')
        max_lags = numel(x);
    end


    % 
    % Create a lagged regression matrix & allocate storage for the partial ACF. 
    % 

    X  =  lagmatrix(x , [1:max_lags]); 
    pi =  [1 ; zeros(max_lags , 1)]; 

    % 
    % Compute partial ACF by fitting successive order AR models  
    % by OLS, retaining the last coefficient of each regression. 
    % 

    for order = 1:max_lags
        column_of_ones = ones(length(x)-order, 1);
        A           = [column_of_ones  X(order+1:end, 1:order)];
        [Q , R]     =  qr(A , 0); 
        b           =  R \ (Q' * x(order+1:end)); 
        pi(order+1) =  b(end); 
    end 
    
    return;

    %{
    
    acf  = nan(max_lags);
    pacf = nan(max_lags, max_lags);
    
    % pre-calculate the autocorrelation values (rho)
    for p=1:max_lags
        acf(p) = my_corr(x, x, p);
    end

    % If an equation has only one explanatory variable, it makes no 
    % sense to test for additional information of this one variable.
    % Therefore, the autocorrelation coefficient ? and the partial 
    % autocorrelation coefficient ? of the first lag are the same:
    pacf(1, 1) = acf(1);

    for p=2:max_lags

        term = 0;
        term2 = 0;
        for j=1:p-1
            % Durbin recursion
            if isnan( pacf(p-1, j) )
               pacf(p-1,j) = pacf(p-2,j) - pacf(p-1,p-1) * pacf(p-2,p-1-j);
               
               % see Time Series Analysis: Forecasting and Control, fourth
               % edition, p. 69 and appendix A3.2
            end

            term  = term + pacf(p-1, j) * acf(p-j);
            
            term2 = term2 + pacf(p-1, j) * acf(j);
        end

        pacf(p, p) = (acf(p) - term) / (1 - term2);

    end

    pi = [1 diag(pacf)'];

    %}
    
end
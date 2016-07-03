signal_gen

% https://www.empiwifo.uni-freiburg.de/lehre-teaching-1/winter-term/dateien-financial-data-analysis/handout-pacf.pdf

%{

% From the lag 0 one can achieve all the present information 
% and hence X_t is fully specified: 
% lag = 0;
% pacf(1+lag, 1+lag) = 1;

% If an equation has only one explanatory variable, it makes no 
% sense to test for additional information of this one variable.
% Therefore, the autocorrelation coefficient ? and the partial 
% autocorrelation coefficient ? of the first lag are the same:
lag = 1;
pacf(1+lag) = my_corr(y,y,lag);

lag = 2;
tau = lag;
%}

%{
rho_tau = my_corr(y,y,tau);
for j=1:tau-1
    rho_tau_j = my_corr(y,y,tau-j);
end
%}

% pi_1 = pi_{1,1} = rho_1 = my_corr(y,y,1)

% pi_2 = pi_{2,2} 
%  = (rho_2 - pi_{1,1} rho_1) /
%    (    1 - pi_{1,1} rho_1)
%  = (rho_2 - rho_1 rho_1) /
%    (    1 - rho_1 rho_1)

% by Durbin's recursion equation
% pi_{2,1} 
%  = (pi_{1,1} - pi_{2,2} pi_{1,1})
%  = (rho_1    - rho_2    rho_1)

% pi_3 = pi_{3,3} 
%  = (rho_2 - (pi_{2,2} rho_1) - (pi_{2,1} rho_1)) \
%    (    1 - (pi_{2,2} rho_1) - (pi_{2,1} rho_1))
%  = (rho_2 - (pi_{2,2} rho_1) - (pi_{2,1} rho_1)) \
%    (    1 - (pi_{2,2} rho_1) - (pi_{2,1} rho_1))

%% ------------------------------------------------------------------------

max_lags = 1000;

acf  = nan(max_lags);
pacf = nan(max_lags, max_lags);

% pre-calculate the autocorrelation values (rho)
for tau=1:max_lags
   acf(tau) = my_corr(y, y, tau);
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

pacf = diag(pacf)';

figure;
stem(pacf)
title('Partial autocorrelation');
ylabel('coefficient');
xlabel('lag');
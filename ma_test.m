% signal_gen

% http://people.brandeis.edu/~pmherb/MatlabBootCamp/simulatingdata.html

t_max = 2;
N = 100;

t = linspace(0, t_max, N);
x = 1:numel(t);

% MA(1)
theta = [0.8];
ma_degree = numel(theta);

mean = -42;
num_differentiations = 0;
sigma = 1;

% in order to simulate an MA process, we need to know the shocks
shocks = sigma*randn(size(t));

y = nan(size(t));
y(1) = mean + shocks(i);
for i=2:numel(t)
    y(i) = mean;
    for lag=1:numel(theta)
        lagged_shocks = 0;
        if i-lag > 0
            lagged_shocks = shocks(i-lag);
        end
        y(i) = y(i) + theta(lag)*lagged_shocks + shocks(i);
    end
end

for d=1:num_differentiations
    y = [0 diff(y)];
end

% determine the autocorrelation
acf = [1];
for i=x
    acf = [acf; my_corr(y,y,i)];
end

% determine the partial autocorrelation
pacf = my_pacf(y, N);

% check against the MATLAB function
%acf_sys = xcorr(y, N, 'coeff');
%acf_sys = acf_sys(N+1:end-1);

%pacf_sys = parcorr(y, N-1);

close all;
figure;
subplot(3,1,1);
plot(t, y, 'LineWidth', 2);
title(sprintf('MA(%d) time series (%dx differentiated)', ma_degree, num_differentiations));
xlabel('t [s]');
ylabel('signal');
grid on;

% adjust for zero-lag element
acf = acf(1:end-1);
pacf = pacf(1:end-1);

% determine the confidence intervals for the ACF
confidence_interval = 1.96/sqrt(N);
in_confidence = abs(acf) >= confidence_interval;
out_confidence = ~in_confidence;

subplot(3,1,2);
stem(t(out_confidence),acf(out_confidence), 'LineWidth', 2, 'Color', [0.7 0.7 1]); hold on;
stem(t(in_confidence),acf(in_confidence), 'LineWidth', 2); hold on;
%stem(t,acf_sys, 'r:', 'LineWidth', 2)
title('autocorrelation (ACF)');
xlabel('lag [s]');
ylabel('coefficient')
grid on;

% determine the confidence intervals for the PACF
in_confidence = abs(pacf) >= confidence_interval;
out_confidence = ~in_confidence;

subplot(3,1,3);
stem(t(out_confidence),pacf(out_confidence), 'LineWidth', 2, 'Color', [0.7 0.7 1]); hold on;
stem(t(in_confidence),pacf(in_confidence), 'LineWidth', 2); hold on;
%stem(t, pacf_sys, 'r:', 'LineWidth', 2)
title('partial autocorrelation (PACF)');
xlabel('lag [s]');
ylabel('coefficient')
grid on;
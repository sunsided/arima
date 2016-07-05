clear all;

% http://people.brandeis.edu/~pmherb/MatlabBootCamp/simulatingdata.html

t_max = 2;
N = 100;

t = linspace(0, t_max, N);
x = 0:numel(t);

% AR(1) / random walk
phi = [0.7];

% AR(2)
%phi = [0.5 0.1];

% AR(?)
%phi = [1 0.2 -0.5];

ar_degree = numel(phi);

num_differentiations = 0;
sigma = 1;

y = nan(size(t));
y(1) = sigma*randn(1);
for i=2:numel(t)
    y(i) = sigma*randn(1);
    for lag=1:numel(phi)
        lagged_y = 0;
        if i-lag > 0
            lagged_y = y(i-lag);
        end
        y(i) = y(i) + phi(lag)*lagged_y;
    end
end

for d=1:num_differentiations
    y = [0 diff(y)];
end

% determine the autocorrelation
acf = [];
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
title(sprintf('AR(%d) time series (%dx differentiated)', ar_degree, num_differentiations));
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
stem(x(out_confidence),acf(out_confidence), 'LineWidth', 1, 'Color', [0.7 0.7 1]); hold on;
stem(x(in_confidence),acf(in_confidence), 'filled', 'LineWidth', 1); hold on;
%stem(t,acf_sys, 'r:', 'LineWidth', 2)
title('autocorrelation (ACF)');
xlabel('lag');
ylabel('coefficient')
ylim([-1 1]);
grid on;

% determine the confidence intervals for the PACF
in_confidence = abs(pacf) >= confidence_interval;
out_confidence = ~in_confidence;

subplot(3,1,3);
stem(x(out_confidence),pacf(out_confidence), 'LineWidth', 1, 'Color', [0.7 0.7 1]); hold on;
stem(x(in_confidence),pacf(in_confidence), 'filled', 'LineWidth', 1); hold on;
%stem(t, pacf_sys, 'r:', 'LineWidth', 2)
title('partial autocorrelation (PACF)');
xlabel('lag');
ylabel('coefficient')
ylim([-1 1]);
grid on;

signal_gen

t_max = 2;
N = 100;

t = linspace(0, t_max, N);
x = 1:numel(t);

% AR(1) / random walk
phi = [1]; %[0.5 0.3 -1];
y = nan(size(t));
y(1) = 42;
for i=2:numel(t)
    for lag=1:numel(phi)
        lagged_y = 0;
        if i-lag > 0
            lagged_y = y(i-lag);
        end
        y(i) = 0.5*randn(1) + phi(lag)*lagged_y;
    end
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
title('time series');
xlabel('t [s]');
ylabel('signal');
grid on;

subplot(3,1,2);
stem(t,acf(1:end-1), 'LineWidth', 2); hold on;
%stem(t,acf_sys, 'r:', 'LineWidth', 2)
title('autocorrelation (ACF)');
xlabel('lag [s]');
ylabel('coefficient')
grid on;

subplot(3,1,3);
stem(t, pacf(1:end-1), 'LineWidth', 2); hold on;
%stem(t, pacf_sys, 'r:', 'LineWidth', 2)
title('partial autocorrelation (PACF)');
xlabel('lag [s]');
ylabel('coefficient')
grid on;

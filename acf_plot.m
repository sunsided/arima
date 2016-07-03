signal_gen

acf = []
for i=x
    acf = [acf; my_corr(y,y,i)];
end

acf_sys = xcorr(y, N, 'coeff');
acf_sys = acf_sys(N+1:end-1);

figure;
subplot(3,1,1);
plot(t, y, 'LineWidth', 2);
title('time series');
xlabel('t [s]');
ylabel('signal');
grid on;

subplot(3,1,2);
plot(t,acf, 'LineWidth', 2); hold on;
plot(t,acf_sys, 'r:', 'LineWidth', 2)
title('autocorrelation (ACF)');
xlabel('lag [s]');
ylabel('coefficient')
grid on;

subplot(3,1,3);

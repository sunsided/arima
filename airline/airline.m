clear all;
close all;
addpath '..';

MAX_DISPLAYED_PACF_LAGS=60;

% read in the airline series
fileID = fopen('international-airline-passengers.csv', 'r');
A = textscan(fileID, '"%d-%d";%d', 'headerLines', 1);
fclose(fileID);

years = A{1};
months = A{2};
passengers = A{3};

clear fileID A;

N = numel(passengers);

% differentiate once
d_passengers = [0; diff(passengers)];

% simple plot

figure;
subplot(2,1,1);
plot(passengers);
xlabel('month');
ylabel('c(t) \cdot 10^{-3}');
title('airline passengers');

subplot(2,1,2);
plot(d_passengers);
xlabel('month');
ylabel('\Deltac(t) \cdot 10^{-3}');
title('change of airline passengers');

lags = 0:N;
acf = my_corr(double(passengers), double(passengers), lags);
dacf = my_corr(double(d_passengers), double(d_passengers), lags);

pacf = my_pacf(double(passengers), N);
dpacf = my_pacf(double(d_passengers), N);

% confidence bands for 95% confidence of the null hypothesis 
% (i.e. no correlation)
ACF_conf_x  = [lags, fliplr(lags)];
ACF_conf_y  = [ones(1, numel(lags))*1.96/sqrt(N), fliplr(-ones(1, numel(lags)))*1.96/sqrt(N)];
PACF_conf_x = [lags(1:MAX_DISPLAYED_PACF_LAGS+1), fliplr(lags(1:MAX_DISPLAYED_PACF_LAGS+1))];
PACF_conf_y = [ones(1,MAX_DISPLAYED_PACF_LAGS+1)*1.96/sqrt(N), fliplr(-ones(1,MAX_DISPLAYED_PACF_LAGS+1))*1.96/sqrt(N)];

figure;
subplot(2,2,1);
stem(lags, acf, ':o', 'filled', 'MarkerSize', 3);
title('Sample ACF c(t)');
xlabel('lag')
ylabel('\rho( k)')
xlim([0 N]);

hold on 
fill(ACF_conf_x, ACF_conf_y, 1,....
        'FaceColor', [0 0 0], ...
        'EdgeColor', 'none', ...
        'FaceAlpha', 0.1);
hold off 

subplot(2,2,3);
stem(lags(1:MAX_DISPLAYED_PACF_LAGS), pacf(1:MAX_DISPLAYED_PACF_LAGS), ':o', 'filled', 'MarkerSize', 3);
title('Sample PACF c(t)');
xlabel('lag k')
ylabel('\alpha(k)')
xlim([0 MAX_DISPLAYED_PACF_LAGS]);

hold on 
fill(PACF_conf_x, PACF_conf_y, 1,....
        'FaceColor', [0 0 0], ...
        'EdgeColor', 'none', ...
        'FaceAlpha', 0.1);
hold off 

% The autocorrelogram of the differentiated time series
% shows a strong seasonality of 12 lags (i.e. months).
% This can also be seen in the sample partial autocorrelogram.

subplot(2,2,2);
stem(lags, dacf, ':o', 'filled', 'MarkerSize', 3);
title('Sample ACF \Deltac(t)');
xlabel('lag')
ylabel('\rho( k)')
xlim([0 N]);

hold on 
fill(ACF_conf_x, ACF_conf_y, 1,....
        'FaceColor', [0 0 0], ...
        'EdgeColor', 'none', ...
        'FaceAlpha', 0.1);
hold off 

subplot(2,2,4);
stem(lags(1:MAX_DISPLAYED_PACF_LAGS), dpacf(1:MAX_DISPLAYED_PACF_LAGS), ':o', 'filled', 'MarkerSize', 3);
title('Sample PACF \Deltac(t)');
xlabel('lag k')
ylabel('\alpha(k)')
xlim([0 MAX_DISPLAYED_PACF_LAGS]);

hold on 
fill(PACF_conf_x, PACF_conf_y, 1,....
        'FaceColor', [0 0 0], ...
        'EdgeColor', 'none', ...
        'FaceAlpha', 0.1);
hold off
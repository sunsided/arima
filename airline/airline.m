% attempting to follow the StackExchange answer http://stats.stackexchange.com/a/9017/26843

clear all;
close all;
addpath '..';

MAX_DISPLAYED_LAGS=40;

% read in the airline series
fileID = fopen('international-airline-passengers.csv', 'r');
A = textscan(fileID, '"%d-%d";%d', 'headerLines', 1);
fclose(fileID);

years = A{1};
months = A{2};
passengers = double(A{3});

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

lags = 0:MAX_DISPLAYED_LAGS;
acf = my_corr(passengers, passengers, lags);
dacf = my_corr(d_passengers, d_passengers, lags);

pacf = my_pacf(passengers, MAX_DISPLAYED_LAGS);
dpacf = my_pacf(d_passengers, MAX_DISPLAYED_LAGS);

% confidence bands for 95% confidence of the null hypothesis (i.e. no correlation)
% https://en.wikipedia.org/wiki/Correlogram
% https://en.wikipedia.org/wiki/1.96
PACF_conf_x = [lags, fliplr(lags)];
PACF_conf_y = [ones(size(lags))*1.96/sqrt(N), fliplr(-ones(size(lags)))*1.96/sqrt(N)];

% confidence bands for 95% confidence of the null hypothesis (i.e. no correlation)
% the ACF confidence bands are using the Bartlett approximation describe on
% https://en.wikipedia.org/wiki/Correlogram
bartlett_conf = zeros(1, MAX_DISPLAYED_LAGS+1);
acf_squared = acf.^2;
for i=1:MAX_DISPLAYED_LAGS
    bartlett_conf(i+1) = 1.96*sqrt( (1 + 2*sum(acf_squared(2:i))) / N);
end

ACF_conf_x  = [lags, fliplr(lags)];
%ACF_conf_y  = [ones(1, numel(lags))*1.96/sqrt(N), fliplr(-ones(1, numel(lags)))*1.96/sqrt(N)];
ACF_conf_y  = [bartlett_conf, fliplr(-bartlett_conf)];

figure;
subplot(2,2,1);
stem(lags, acf, ':o', 'filled', 'MarkerSize', 3);
title('Sample ACF c(t)');
xlabel('lag')
ylabel('\rho( k)')
xlim([0 MAX_DISPLAYED_LAGS]);

hold on 
fill(ACF_conf_x, ACF_conf_y, 1,...
        'FaceColor', [0 0 0], ...
        'EdgeColor', 'none', ...
        'FaceAlpha', 0.1);

% send the filled are to the background
set(gca, 'children', flipud(get(gca, 'children')));

subplot(2,2,3);
stem(lags(1:MAX_DISPLAYED_LAGS), pacf(1:MAX_DISPLAYED_LAGS), ':o', 'filled', 'MarkerSize', 3);
title('Sample PACF c(t)');
xlabel('lag k')
ylabel('\alpha(k)')
xlim([0 MAX_DISPLAYED_LAGS]);

hold on 
fill(PACF_conf_x, PACF_conf_y, 1,....
        'FaceColor', [0 0 0], ...
        'EdgeColor', 'none', ...
        'FaceAlpha', 0.1);
set(gca, 'children', flipud(get(gca, 'children')));

% The autocorrelogram of the differentiated time series
% shows a strong seasonality of 12 lags (i.e. months).
% This can also be seen in the sample partial autocorrelogram.

subplot(2,2,2);
stem(lags, dacf, ':o', 'filled', 'MarkerSize', 3);
title('Sample ACF \Deltac(t)');
xlabel('lag')
ylabel('\rho( k)')
xlim([0 MAX_DISPLAYED_LAGS]);

hold on 
fill(ACF_conf_x, ACF_conf_y, 1,....
        'FaceColor', [0 0 0], ...
        'EdgeColor', 'none', ...
        'FaceAlpha', 0.1);
set(gca, 'children', flipud(get(gca, 'children')));

subplot(2,2,4);
stem(lags(1:MAX_DISPLAYED_LAGS), dpacf(1:MAX_DISPLAYED_LAGS), ':o', 'filled', 'MarkerSize', 3);
title('Sample PACF \Deltac(t)');
xlabel('lag k')
ylabel('\alpha(k)')
xlim([0 MAX_DISPLAYED_LAGS]);

hold on 
fill(PACF_conf_x, PACF_conf_y, 1,....
        'FaceColor', [0 0 0], ...
        'EdgeColor', 'none', ...
        'FaceAlpha', 0.1);
set(gca, 'children', flipud(get(gca, 'children')));
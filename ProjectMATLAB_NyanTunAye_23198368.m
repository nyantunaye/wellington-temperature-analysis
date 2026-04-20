% =========================================================================
% MATH803 Project Part A - Wellington Temperature Analysis
% Author: Nyan Tun Aye (23198368)
% Dataset: WLGJan2025Temp.csv (720 hourly records, 1-30 January 2025)
% =========================================================================

% Load data
WLGJan2025Temp = readtable("data/WLGJan2025Temp.csv");

% =========================================================================
% Question 1: Statistics Summary
% =========================================================================

disp("=== Question 1: Statistics Summary ===")
meantemp   = mean(WLGJan2025Temp.Temperature)
mediantemp = median(WLGJan2025Temp.Temperature)
rangetemp  = range(WLGJan2025Temp.Temperature)
mintemp    = min(WLGJan2025Temp.Temperature)
maxtemp    = max(WLGJan2025Temp.Temperature)
stdtemp    = std(WLGJan2025Temp.Temperature)

% Calculate average daily range
daily      = reshape(WLGJan2025Temp.Temperature, [24, 30]);
maxdaily   = max(daily);
mindaily   = min(daily);
disp("Average of Daily Range")
dailyranges = maxdaily - mindaily;
disp(mean(dailyranges))

% Plot histogram of temperatures
figure(1)
clf
histogram(WLGJan2025Temp.Temperature, 'BinWidth', 1, ...
    'FaceColor', 'blue', 'EdgeColor', 'black')
xlabel('Temperature (°C)')
ylabel('Frequency')
title('Distribution of Hourly Temperatures in Wellington')
subtitle('1-30 January 2025')
grid on
hold off

disp(['The temperature data for Wellington in January 2025 includes 720 hourly ' ...
    'records (24 hours for 30 days). Each record has a temperature (in Celsius) ' ...
    'and a timestamp. The data is complete, with no missing values, and making ' ...
    'it reliable for analysis. The average temperature is 16.11°C, which is ' ...
    'very close to the median of 16°C, showing that the temperatures are evenly ' ...
    'spread out. A histogram of the hourly temperatures shows that the data is ' ...
    'mostly symmetrical, with most temperatures between 14°C and 18°C, peaking ' ...
    'around 16–17°C. This confirms the even spread of temperatures. The range of ' ...
    'temperatures is 16°C, from a minimum of 10°C to a maximum of 26°C, showing ' ...
    'that there was quite a bit of change in the temperature during the month. ' ...
    'The standard deviation of 2.62°C shows the usual fluctuations around the ' ...
    'average. The average daily temperature range is 5.1467°C, which means there ' ...
    'were moderate daily changes. Some days were as hot as 26°C, while others were ' ...
    'as cool as 10°C. The histogram visually supports this, confirming that most ' ...
    'temperatures stayed within a similar range but with some variation.'])

% =========================================================================
% Question 2: Trend Analysis
% =========================================================================

disp("=== Question 2: Trend Analysis ===")

% Moving average with window size (48 hours)
figure(2)
clf
plot(WLGJan2025Temp.Datetime, WLGJan2025Temp.Temperature, 'blue')
xlabel('Dates')
ylabel('in Degrees Celsius')
title('Wellington Maximum Hourly Temperature')
subtitle('1-30 January 2025')
datetick('x', 'dd-mm', 'keepticks');
hold on
M_pastdata48 = movmean(WLGJan2025Temp.Temperature, [47 0]);
plot(WLGJan2025Temp.Datetime, M_pastdata48, 'red')
legend('Wellington Hourly Temp.', 'MA Window Size 48', 'Location', 'south');
grid on
hold off

% Linear regression on hourly data
no_hours = (1:length(WLGJan2025Temp.Hour))';
coef1    = polyfit(no_hours, WLGJan2025Temp.Temperature, 1);
pred1    = polyval(coef1, no_hours);

% Compute R-squared for hourly linear regression
ss_tot    = sum((WLGJan2025Temp.Temperature - mean(WLGJan2025Temp.Temperature)).^2);
ss_res    = sum((WLGJan2025Temp.Temperature - pred1).^2);
r2_hourly = 1 - (ss_res / ss_tot);
disp('R-squared for hourly linear regression:')
disp(r2_hourly)

% Compute daily averages
daily_avg = mean(daily)'; % 30x1 column vector of daily averages
days      = (1:30)';

% Linear regression on daily averages
coef_daily  = polyfit(days, daily_avg, 1);
pred_daily  = polyval(coef_daily, days);

% Compute R-squared for daily linear regression
ss_tot_daily = sum((daily_avg - mean(daily_avg)).^2);
ss_res_daily = sum((daily_avg - pred_daily).^2);
r2_daily     = 1 - (ss_res_daily / ss_tot_daily);
disp('R-squared for daily linear regression:')
disp(r2_daily)

% Plot linear regression on hourly data
figure(3)
clf
plot(WLGJan2025Temp.Datetime, WLGJan2025Temp.Temperature, 'blue')
xlabel('Dates')
ylabel('in Degrees Celsius')
title('Wellington Maximum Hourly Temperature')
subtitle('1-30 January 2025')
datetick('x', 'dd-mm', 'keepticks');
hold on
plot(WLGJan2025Temp.Datetime, pred1, 'green', 'LineWidth', 2)
legend('Wellington Hourly Temp.', 'Order 1 / Linear Regression', 'Location', 'south');
grid on
hold off

% Plot linear regression on daily averages
figure(4)
clf
plot(1:30, daily_avg, 'bo-', 'MarkerSize', 4)
hold on
plot(1:30, pred_daily, 'g-', 'LineWidth', 2)
xlabel('Day of January 2025')
ylabel('Daily Average Temperature (°C)')
title('Daily Average Temperature in Wellington')
subtitle('1-30 January 2025')
legend('Daily Averages', 'Linear Regression on Daily Averages', 'Location', 'south')
grid on
hold off

disp(['The temperature data for January 2025 in Wellington shows a slight ' ...
    'increase over the month, which is seen through moving averages and linear ' ...
    'regression. A 48-hour moving average (MA) smooths out the hourly changes ' ...
    'and shows a gradual increase in temperature from around 14°C on January ' ...
    '1st to 16°C on January 30th. Linear regression on the hourly data also ' ...
    'shows this upward trend, but with a small positive slope. The R-squared ' ...
    'value of 0.2151 suggests that the data is not perfectly explained by the ' ...
    'trend because of daily temperature changes. To better understand this, daily ' ...
    'average temperatures were calculated, which ranged from 13°C to 21°C. When ' ...
    'linear regression was applied to these daily averages, the upward trend was ' ...
    'clearer, with temperatures rising from about 15°C to 17°C. The R-squared ' ...
    'value for this trend was higher at 0.4041, indicating that the daily averages ' ...
    'provide a better fit to the data, as they reduce the daily fluctuations.'])

% =========================================================================
% Question 3: Forecasting 31 January 2025
% =========================================================================

disp("=== Question 3: Forecasting 31 January 2025 ===")

% Polynomial fits (orders 1 to 7)
no_hours = (1:length(WLGJan2025Temp.Hour))'; % 720x1 vector
n        = length(no_hours);

r2_poly      = zeros(7, 1);
adj_r2_poly  = zeros(7, 1);
pred_jan31   = zeros(24, 7);

for order = 1:7
    % Fit polynomial of given order
    coef = polyfit(no_hours, WLGJan2025Temp.Temperature, order);

    % Predict for 1-30 January (hours 1-720)
    pred = polyval(coef, no_hours);

    % Compute R-squared
    ss_tot_p       = sum((WLGJan2025Temp.Temperature - mean(WLGJan2025Temp.Temperature)).^2);
    ss_res_p       = sum((WLGJan2025Temp.Temperature - pred).^2);
    r2_poly(order) = 1 - (ss_res_p / ss_tot_p);

    % Compute adjusted R-squared
    adj_r2_poly(order) = 1 - (1 - r2_poly(order)) * (n - 1) / (n - order - 1);

    % Extrapolate for 31 January (hours 721-744)
    Hours_ext          = (721:744)';
    pred_ext           = polyval(coef, Hours_ext);
    pred_jan31(:, order) = pred_ext;
end

% Display R-squared and adjusted R-squared for polynomial fits
disp('R-squared for polynomial fits (orders 1-7):')
disp(r2_poly)
disp('Adjusted R-squared for polynomial fits (orders 1-7):')
disp(adj_r2_poly)

% Estimate daily average for 31 January using order 4
Mean31Jan_poly4 = mean(pred_jan31(:, 4));
disp('Estimate for the Daily Average Temperature for 31 January 2025 (Polynomial Order 4):')
disp(Mean31Jan_poly4)

% Exponential smoothing (alpha = 0.1)
alpha      = 0.1;
exp_smooth = zeros(size(WLGJan2025Temp.Temperature));
exp_smooth(1) = WLGJan2025Temp.Temperature(1);

for t = 2:length(WLGJan2025Temp.Temperature)
    exp_smooth(t) = alpha * WLGJan2025Temp.Temperature(t) + (1 - alpha) * exp_smooth(t-1);
end

% Compute R-squared for exponential smoothing
ss_tot_e = sum((WLGJan2025Temp.Temperature - mean(WLGJan2025Temp.Temperature)).^2);
ss_res_e = sum((WLGJan2025Temp.Temperature - exp_smooth).^2);
r2_exp   = 1 - (ss_res_e / ss_tot_e);

% Adjusted R-squared for exponential smoothing (1 parameter)
adj_r2_exp = 1 - (1 - r2_exp) * (n - 1) / (n - 1 - 1);

disp('R-squared for exponential smoothing:')
disp(r2_exp)
disp('Adjusted R-squared for exponential smoothing:')
disp(adj_r2_exp)

% Extrapolate using exponential smoothing for 31 January
last_smooth     = exp_smooth(end);
exp_smooth_ext  = zeros(24, 1);
exp_smooth_ext(1) = alpha * last_smooth + (1 - alpha) * last_smooth;

for t = 2:24
    exp_smooth_ext(t) = alpha * exp_smooth_ext(t-1) + (1 - alpha) * exp_smooth_ext(t-1);
end

Mean31Jan_exp = mean(exp_smooth_ext);
disp('Estimate for the Daily Average Temperature for 31 January 2025 (Exponential Smoothing):')
disp(Mean31Jan_exp)

% Plot polynomial fit (order 4) and exponential smoothing
no_hours_tot = (1:744)';
pred4_tot    = polyval(polyfit(no_hours, WLGJan2025Temp.Temperature, 4), no_hours_tot);

figure(5)
clf
plot(WLGJan2025Temp.Hour, WLGJan2025Temp.Temperature, 'blue')
hold on
plot(no_hours_tot, pred4_tot, 'g--', 'LineWidth', 2)
plot(1:720, exp_smooth, 'r-', 'LineWidth', 2)
plot(721:744, exp_smooth_ext, 'r--', 'LineWidth', 2)
xlabel('Dates')
ylabel('in Degrees Celsius')
title('Wellington Hourly Temperature Estimate')
subtitle('Prediction for 31 Jan 2025')
datetick('x', 'dd-mm', 'keepticks');
legend('Hourly Temp.', '4th Order Polynomial', 'Exponential Smoothing', 'Location', 'south')
grid on
hold off

fprintf(['To estimate the daily average temperature for Wellington on 31 January 2025, ' ...
    'I looked at the hourly temperature data from 1–30 January 2025 (720 hours) ' ...
    'and used two methods: polynomial fits and exponential smoothing. ' ...
    'For the polynomial method, I used a 4th-order polynomial model to predict ' ...
    'temperatures for hours 721–744, giving an estimated daily average of 14.8911°C. ' ...
    'This suggests a downward trend since the monthly average was 16.11°C. ' ...
    'Exponential smoothing with alpha=0.1 gave a higher R-squared (0.6054) and ' ...
    'estimated the daily average for 31 January as 16.5854°C. ' ...
    'Based on the 4th-order polynomial, the estimated daily average temperature ' ...
    'for 31 January 2025 is 14.8911°C.\n'])

% =========================================================================
% Question 4: Periodicity Analysis
% =========================================================================

disp("=== Question 4: Periodicity Analysis ===")

% Autocorrelation for 24-hour lag
figure(6)
clf
autocorr(WLGJan2025Temp.Temperature, 'NumLags', 24)
title('Autocorrelation: First 24 Hours')
xlabel('Lag (hours)')
ylabel('Autocorrelation')
grid on

% Autocorrelation for 168-hour lag
figure(7)
clf
autocorr(WLGJan2025Temp.Temperature, 'NumLags', 168)
title('Autocorrelation: First 168 Hours')
xlabel('Lag (hours)')
ylabel('Autocorrelation')
grid on

% FFT Power Spectrum
figure(8)
clf

% Remove mean to center the temperature data
WLGTemp_0 = WLGJan2025Temp.Temperature - mean(WLGJan2025Temp.Temperature);

% Compute FFT
y = fft(WLGTemp_0);
n = length(WLGTemp_0); % 720 hours

% Compute power spectrum (first half, excluding DC component)
power = abs(y(1:floor(n/2))).^2 / n;

% Frequency grid (cycles per hour)
nyquist = 1/2; % Nyquist frequency = 0.5 cycles/hour
freq    = (1:floor(n/2)) / n * nyquist;

% Plot power spectrum
plot(freq, power, 'b')
xlabel('Frequency (cycles per hour)')
ylabel('Power')
title('Temperature Power Spectrum')
grid on
hold off

% Hours per Cycle (focus on periods up to 100 hours)
figure(9)
clf

% Convert frequency to periods (hours per cycle)
periods    = 1 ./ freq;
periods(1) = periods(2); % Avoid division by zero at DC

% Focus on periods up to 100 hours
idx_range = periods <= 100;

% Plot power vs periods
plot(periods(idx_range), power(idx_range), 'b')

% Find dominant period (maximum power within 100 hours)
[~, max_idx]     = max(power(idx_range));
dominant_period  = periods(idx_range);
dominant_period  = dominant_period(max_idx);
dominant_power   = power(idx_range);
dominant_power   = dominant_power(max_idx);

% Highlight dominant period
if dominant_period <= 100
    hold on
    plot(dominant_period, dominant_power, 'ro', 'MarkerSize', 10, 'LineWidth', 2)
    text(dominant_period, dominant_power, ...
        sprintf('Dominant: %.1f hours/cycle', dominant_period), ...
        'VerticalAlignment', 'bottom')
    hold off
end

xlabel('Period (hours/cycle)')
ylabel('Power')
title('Power Spectrum vs Hours per Cycle')
grid on

% FFT Fourier Coefficients (Real vs. Imaginary)
figure(10)
clf
plot(real(y), imag(y), 'ro')
xlabel('Real Part')
ylabel('Imaginary Part')
title('Fourier Coefficients (Real vs. Imaginary)')
grid on
hold off

fprintf(['When I graphed the temperature data for Wellington from January 1 ' ...
    'to 30, 2025 (720 hourly records), I saw a wavy pattern repeating every day. ' ...
    'To check if there is really a cycle, I used autocorrelation and FFT. ' ...
    'The daily autocorrelation graph showed a clear peak every 24 hours, ' ...
    'proving a strong daily cycle. The weekly (168-hour) graph confirmed this, ' ...
    'with peaks and dips every 24 hours showing the daily pattern holds all week. ' ...
    'The FFT power spectrum and the hours-per-cycle plot both confirmed a 24-hour ' ...
    'dominant cycle, driven by daytime solar heating. ' ...
    'Wellington temperatures (10°C to 26°C) fit this daily cycle well, ' ...
    'confirming clear periodicity in the data.\n'])

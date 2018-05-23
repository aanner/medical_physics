
data = csvread('data_rc_filtered/r01_edfm.csv', 1);
data = data(1:3000, :);

%Measured in sec
time = data(:, 1);
%Measured in muV
direct = data(:, 2);
abd_1 = data(:, 3); % Abdomen 1
abd_2 = data(:, 4); % Abdomen 2
abd_3 = data(:, 5); % Abdomen 3
abd_4 = data(:, 6); % Abdomen 4

dt = time(2)-time(1);
fs = 1/dt;
conv_Hz_to_bpm = 60;
N = length(time);
%% Autocorrelation function
[abd_11_cor, delay] = xcorr(abd_1);
[abd_22_cor, ~] = xcorr(abd_2);
[abd_33_cor, ~] = xcorr(abd_3);
[abd_44_cor, ~] = xcorr(abd_4);
delay = delay*dt;
delay_frequency = conv_Hz_to_bpm*1./delay;

plot(delay_frequency, abd_11_cor)
hold on
plot(delay_frequency, abd_22_cor)
plot(delay_frequency, abd_33_cor)
plot(delay_frequency, abd_44_cor)

xlim([30, 200])
%% Cross correlation function
[abd_12_cor, delay] = xcorr(abd_1, abd_2);
[abd_13_cor, ~] = xcorr(abd_1, abd_3);
[abd_14_cor, ~] = xcorr(abd_1, abd_4);

[abd_23_cor, ~] = xcorr(abd_2, abd_3);
[abd_24_cor, ~] = xcorr(abd_2, abd_4);

[abd_34_cor, ~] = xcorr(abd_3, abd_4);

delay = delay*dt;
delay_frequency = conv_Hz_to_bpm*1./delay;

plot(delay_frequency, abd_11_cor)
hold on
plot(delay_frequency, abd_12_cor)
plot(delay_frequency, abd_13_cor)
plot(delay_frequency, abd_14_cor)

plot(delay_frequency, abd_22_cor)
plot(delay_frequency, abd_23_cor)
plot(delay_frequency, abd_24_cor)

plot(delay_frequency, abd_34_cor)
plot(delay_frequency, abd_33_cor)

plot(delay_frequency, abd_44_cor)
xlim([30, 200])
%%
cor_sum = abs(abd_11_cor) + abs(abd_12_cor) + abs(abd_13_cor) + abs(abd_14_cor) + ...
          abs(abd_22_cor) + abs(abd_23_cor) + abs(abd_24_cor) + ...
          abs(abd_33_cor) + abs(abd_34_cor) + ...
          abs(abd_44_cor);
plot(delay_frequency, cor_sum)
xlim([30, 200])

%%
for i=2:N
    subplot(311)
    plot(abd_1(1:i), abd_3(1:i))
    subplot(312)
    plot(time(1:i), abd_1(1:i))
    subplot(313)
    plot(time(1:i), abd_3(1:i))
    pause(1/fs)
end
%% Principal component analysis
X = [abd_1, abd_2];
%%
sigma = X*transpose(X);
[V, D] = eigs(sigma);
disp(D)
subplot(4,1,1)
plot(V(:,1))
subplot(4,1,2)
plot(V(:,2))
subplot(4,1,3)
plot(V(:,3))
subplot(4,1,4)
plot(V(:,4))

%%
[coeff,score,latent] = pca(X);
%% Independent component analysis
n_sources = 2;
Mld = rica(X, n_sources);

source_signals = transform(Mld, X);
for i=1:n_sources
    subplot(n_sources + 1,1,i)
    plot(time, source_signals(:,i))
end
subplot(n_sources + 1,1,n_sources+1)
plot(time, (abd_1+abd_2+abd_3+abd_4)/4)

%% Autocorrelation of independent components
corr_1 = xcorr(source_signals(:,1));
corr_2 = xcorr(source_signals(:,2));
plot(corr_1)
hold on
plot(corr_2)
%% Wavelet transform of independent components
for i=1:n_sources
    figure
    cwt(source_signals(:,i), 'morse', fs);
end
pause
close all

%%
subplot(421)

subplot(422)
cwt(source_signals(:,2))
%% Wavelet transform of individual signals
fig_abd_1 = figure
cwt(abd_1, 'morse', fs)
saveas(fig_abd_1, 'figures/abd_1_cwt.png')
fig_abd_2 = figure
cwt(abd_2, 'morse', fs)
saveas(fig_abd_1, 'figures/abd_2_cwt.png')
fig_abd_3 = figure
cwt(abd_3, 'morse', fs)
saveas(fig_abd_3, 'figures/abd_3_cwt.png')
fig_abd_4 = figure
cwt(abd_4, 'morse', fs)
saveas(fig_abd_4, 'figures/abd_4_cwt.png')

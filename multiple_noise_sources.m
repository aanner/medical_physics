t = 1:10000;
y = zeros(size(t));

n_sensors = 50;
noise_rms = zeros([n_sensors, 1]);

for k = 1:n_sensors
    for i = 1:length(t)
        y(i) = y(i) + 2*rand()-1;
    end
    y_prime = y/k;
    noise_rms(k) = rms(y_prime);
end

plot(noise_rms)
xlim([1, n_sensors])
xlabel('Number of sensors')
ylabel('Noise of synthetic signal')
grid on
grid minor
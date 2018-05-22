% Function that adds rc filter to propagate signals through air.
% The capacitance represents the coupling between the potential on the skin
% and the electrode.
% The resistor represents the internal resistance in the opamp (INA116).
% In the ideal case, the resistor is (almost) infinite.
% We do not want an infinite resistance as there will be no DC current
% path.

%% LOAD DATA
data = csvread('data/r01_edfm.csv', 1);
time = data(:,1);
fs = 1/(time(2)-time(1));
epsilon_0 = 8.8541*1e-12; % Permittivity of free space
epsilon_r_air = 1; % Relative permittivity of free space
electrode_area = (1*1e-2)^2; % 1cm*1cm electrode are
electrode_distance = 0.5*1e-2; % Distance between electrode and skin
C_electrode = epsilon_r_air*epsilon_0*electrode_area/electrode_distance; % Neglectin boundary leakage sqrt(A) >> d
R_input = 10^16; % Input impedance of INA116
f_cutoff = 1/(2*pi*R_input*C_electrode);

data_filtered = zeros(size(data));
data(:,1) = time;
for i=2:length(data(1,:))
   disp(i)
   data_filtered(:,i) = highpass(data(:,i), f_cutoff, fs);
end
%%
dlmwrite('data_rc_filtered/r01_edfm.csv', data, 'newline', 'pc', 'delimiter', ',', '-append')
%%
loglog(abs(fft(data_filtered(:,2))))
hold on
loglog(abs(fft(data(:,2))))


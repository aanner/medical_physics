%plotATM('r01_edfm')
Name = 'r01_edfm';
infoName = strcat(Name, '.info');
matName = strcat(Name, '.mat');
load(matName);
val = val(1:end-1, 1:end); % remove "annotation" curve
fid = fopen(infoName, 'rt');
fgetl(fid);
fgetl(fid);
fgetl(fid);
[freqint] = sscanf(fgetl(fid), 'Sampling frequency: %f Hz  Sampling interval: %f sec');
interval = freqint(2);
fgetl(fid);

for i = 1:size(val, 1)
   [row(i), signal(i), gain(i), base(i), units(i)]=strread(fgetl(fid),'%d%s%f%f%s','delimiter','\t');
end

fclose(fid);
val(val==-32768) = NaN;

for i = 1:size(val, 1)
    val(i, :) = (val(i, :) - base(i)) / gain(i);
end

x = (1:size(val, 2)) * interval;
plot(x', val');
for i = 1:length(signal)
    labels{i} = strcat(signal{i}, ' (', units{i}, ')'); 
end

legend(labels);
xlabel('Time (sec)');
% grid on

%%

dlmwrite('r01_edfm.csv', [x', val'], 'newline', 'pc', 'delimiter', ',')

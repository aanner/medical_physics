%% Initial plot

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

%% Create CSV
clc;
cHeader = {'ab' 'bcd' 'cdef' 'dav'}; %dummy header
textHeader = 'Time (s),';
for i=1:length(labels)
    textHeader = [textHeader labels{i} ','];
end
textHeader = textHeader(1:end-1);
fileID = fopen('r01_edfm.csv','w');
fprintf(fileID,'%s\n',textHeader);
fclose(fileID);
data = [x', val'];
dlmwrite('r01_edfm.csv', data, 'delimiter', ',', '-append')

%%
val_cwt = cwt(data(:,3))
plot(val_cwt)
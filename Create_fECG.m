%plotATM('r01_edfm')
load('r01_edfm.mat')
val(val==-32768) = NaN;
plot(val')
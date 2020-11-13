clear all;
clc;
close all;
[filename, pathname] = uigetfile('*.dat', '100.dat');% only image Bitmap
fid=fopen(filename,'r');
time=10;
f=fread(fid,2*360*time,'ubit12');
X=f(1:2:length(f));
maxi=max(X);
%% baseline using wavelet transform
[c, l] = wavedec (X,9,'db1'); % Decomposition of signal into high pass and low pass filter
% c Wavelet decomposition Vector
figure;
Detail_coef1 = wrcoef ('d', c, l,'db2',1); % Detailed components using db2 wavelets
subplot(9,1,1)
plot(Detail_coef1)
title('level 1 Detailed components');
Detail_coef2 = wrcoef ('d', c, l,'db2',2); %%Daubechies 
subplot(9,1,2)
plot(Detail_coef2)
title('level 2 Detailed components');
Detail_coef3 = wrcoef ('d', c, l,'db2',3);
subplot(9,1,3)
plot(Detail_coef3)
title('level 3 Detailed components');
Detail_coef4 = wrcoef ('d', c, l,'db2',4);
subplot(9,1,4)
plot(Detail_coef4)
title('level 4 Detailed components');
Detail_coef5 = wrcoef ('d', c, l,'db2',5);
subplot(9,1,5)
plot(Detail_coef5)
title('level 5 Detailed components');
Detail_coef6 = wrcoef ('d', c, l,'db2',6);
subplot(9,1,6)
plot(Detail_coef6)
title('level 6 Detailed components');
Detail_coef7 = wrcoef ('d', c, l,'db2',7);
subplot(9,1,7)
plot(Detail_coef7)
title('level 7 Detailed components');
Detail_coef8 = wrcoef ('d', c, l,'db2',8);
subplot(9,1,8)
plot(Detail_coef8)
title('level 8 Detailed components');
Detail_coef9 = wrcoef ('d', c, l,'db1',9);
subplot(9,1,9)
plot(Detail_coef9)
title('level 9 Detailed components');
y= Detail_coef9+Detail_coef8+Detail_coef7+Detail_coef6+Detail_coef5+Detail_coef4+Detail_coef3+Detail_coef2+Detail_coef1;
figure;
subplot(2,1,1)
plot(X./1000)
title('Electrocardiogram(ECG) Signal containing Baseline Wander Noise')
grid on;
subplot(2,1,2);
plot(y./1000);
title('Electrocardiogram(ECG) Signal after removing Baseline Wander Noise after using wavelet decompostion ')
grid on;
%% Baseline using inbuilt high pass filter 
F_sampling = 250;  % Sampling Frequency 
N = 50;  % Order of filter
Fc = 0.7;  % Cutoff Frequency

HP_Resp=designfilt('highpassfir', 'CutoffFrequency', Fc,'FilterOrder',N, 'SampleRate', F_sampling);
% Ideal High Pass Filter Response using DesignFilt
HP=filter(HP_Resp,X./max(X));
HP_f=HP(30:end,1);
figure;
subplot (2,1,1);
plot(X./max(X));
title ('Electrocardiogram(ECG) Signal containing Baseline Wander Noise'); 
grid on
subplot (2,1,2), plot(HP_f), title ('Electrocardiogram(ECG) Signal Baseline Wander Noise Removed');
grid on

%% Blood pressure detection
heart_rate=X;
count=0;
for i=1:3600
    if(heart_rate(i)>1200)
        count=count+1;
    end 
end
disp(int32(count/3.6))
if(count>=35)
    disp('Alert!!! Higher Heart relaxation rate') 
else
    disp('Normal heart contraction and relaxation rate');
end






%% REFERENCE 
%%https://www.mathworks.com/matlabcentral/fileexchange/49822-open_ecg-ecg-dat-file-readern
%%% Matlab wavelet tutorial
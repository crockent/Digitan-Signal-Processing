function [num_d, denom_d] = lpButterworth(Attenuation, smpl_freq, samples)
fs = smpl_freq;             %Sampling frequency
fn = fs/2;                  %Nyquist frequency
Rp = 3;                     %Ripple  
Rs = Attenuation;           %Attenuation

%Normalised frequencies
Wp = 2*pi*3000;
Ws = 2*pi*4000;

%Find the order of the filter
[n, Wn] = buttord(Wp, Ws, Rp, Rs, "s");

%Find the poles and gain of the n order filter
[z, p, k] = buttap(n);

%Transfare function from zero pole gain
[num_1, denom_1] = zp2tf(z, p, k);

%Create filter with cutoff frequency Wn
[num_2, denom_2] = lp2lp(num_1, denom_1, Wn);

%Convert filter to digital
[num_d, denom_d] = bilinear(num_2, denom_2,fs);

[H_a,~] = freqs(num_2, denom_2, samples);          %Analog filter
[H_d,~] = freqz(num_d, denom_d, samples, fs);      %Digital filter

f = linspace(0,fn,samples);

hold on;
plot(f, 20*log10(H_a),'b',"LineStyle","-", "DisplayName", "Analog Filter");
plot(f, 20*log10(H_d),'r',"LineStyle",":", "DisplayName", "Digital Filter");

title('Lowpass Butterworth Filter Frequency Response');
legend("AnalogFilter", "Digital Filter");
xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
grid on;
hold off;

end

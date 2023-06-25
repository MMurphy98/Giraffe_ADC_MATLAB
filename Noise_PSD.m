function [freq, psdx, NV_rms] = Noise_PSD(data, fs)
%Noise_PSD 利用自相关+FFT计算噪声信号的频谱并绘制图像；
%   freq: frequency length
%   psdx: PSD in V^2/Hz
%   NV_rms: the integrated Noise in Vrms
%     N = length(data);
    [SS, ~] = xcorr(data, 'biased');
    N = length(SS);
    xdft = fft(SS, N);
    xdft = xdft(1:floor(N/2)+1);
    psdx = (1/N) * abs(xdft);
    psdx(2:end-1) = 2*psdx(2:end-1);
%     psdx = psdx;
    
    delta_freq = fs/N;
    freq = 0:delta_freq:fs/2;
    
    % integrated Noise
    NV_rms = sqrt(sum(delta_freq.*psdx));
    
%     figure
%     plot(freq, 10*log10(psdx));
%     grid on;
%     xlabel('Frequency [Hz]');
%     ylabel('PSD V^2/Hz [dB]');
%     title(['Integrated Noise: ', num2str(NV_rms/(1E-3)), ' mVrms']);

end
function Cycle = Cycle_Process(filename, const_gain)
%Cycle_Process 根据每次cycle存的文件路径(struct)导入数据并进行后处理
%
%   struct结构体包含如下数据：
%       data_N4_cb: calibration original data;
%       data_N4_ad: AD conversion original data;
%       GAIN: calculated GAIN of interstage opamp;
%       GAIN_LIST: each gain result of calibration;
%       data_withcalib: with calibration waveform data;
%       data_withoutcalib: without calibration waveform data;
%       siand/thd_with/withoutcalib: dynamic specifications of signal;
    load(filename, 'data_N4_ad', 'sinad_withcalib', 'thd_withcalib');
    Vref = 1.8;
    N_SUB = 5;
    LSB_SUB = Vref / 2^N_SUB;
    Fs = 2E6;
    Vout_N4 = data_N4_ad * LSB_SUB;
    N_Sample = length(data_N4_ad);

%% Check Flash ADC
    Cycle.sinad_flash = sinad(Vout_N4(:, 1), Fs);
    Cycle.thd_flash = thd(Vout_N4(:, 1), Fs, 9, 'aliased');
    

%% With Const Gain calibration
    Vout_const_gain = zeros(1, N_Sample);
    
    % calibration
    for i=1:N_Sample
        Vout_const_gain(i) = Calib_Gain(Vout_N4(i,:), const_gain);
    end

    Cycle.sinad_const_gain = sinad(Vout_const_gain, Fs);
    Cycle.thd_const_gain = thd(Vout_const_gain, Fs, 9, 'aliased');

%% Sweep Gain 
    gain_sweep = 14:0.01:17;
    sinad_sweep = zeros(size(gain_sweep));
    thd_sweep = zeros(size(gain_sweep));
    parfor j = 1:length(gain_sweep)
        Vout_sweep = zeros(N_Sample, 1);
        % calibration
        for i=1:N_Sample
            Vout_sweep(i) = Calib_Gain(Vout_N4(i,:), gain_sweep(j));
        end

        sinad_sweep(j) = sinad(Vout_sweep, Fs);
        thd_sweep(j) = thd(Vout_sweep, Fs, 9, 'aliased');
    end
    [msinad, sinad_index] = max(sinad_sweep);
    [mthd, thd_index] = min(thd_sweep);
    Cycle.MAX_SINAD = [msinad, gain_sweep(sinad_index)];
    Cycle.MAX_THD = [mthd, gain_sweep(thd_index)];
    Cycle.ORI_SINAD = sinad_withcalib;
    Cycle.ORI_THD = thd_withcalib;
end
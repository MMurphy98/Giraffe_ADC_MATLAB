function [sinad_temp, thd_temp, Vout] = Calib_Gain_seq(Vout_N4, Gain)
    N_sample = length(Vout_N4);
    Vout = zeros(1, N_sample);
    Fs = 2E6;

    for i = 1:N_sample
        Vout(i) = Calib_Gain(Vout_N4(i,:), Gain);
    end
    sinad_temp = sinad(Vout, Fs);
    thd_temp = thd(Vout, Fs, 9, 'aliased');
end
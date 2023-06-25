function result = Main_Periodically(GPIB, UART, t_AD)
    N_Calibration = 1000;
    N_Sample = 102400;
    UART_CMD_CB = 203;
    UART_CMD_AD = 173;
    Vref = 1.8;
    N_SUB = 5;
    LSB_SUB = Vref / 2^N_SUB;
    Fs = 2E6;
    %% Start Calibbration
    writeline(GPIB,"OUTE 0");    % output: 1-enable, 0-disable;
    clean_uart(UART);

    write(UART, UART_CMD_CB, 'uint8');
    data_uart_in_cb = read(UART, 4*N_Calibration, 'uint8');

    readingCheck_uart(UART);

    data_N4_calib = data_bin2array(data_uart_in_cb);
    [Gain_list, GAIN] = deltaGain(data_N4_calib(:,2:end), 10, 'off');
    fprintf("[Calibration Finished!] GAIN: %.3f\n", GAIN);
    %% Start A/D Conversion (Low Speed)

    SINAD_with_calib_List = zeros(1, t_AD);
    SINAD_without_calib_List = zeros(1, t_AD);
    THD_with_calib_List = zeros(1, t_AD);
    THD_without_calib_List = zeros(1, t_AD);
    Vout_without_calib_array = zeros(N_Sample, t_AD);
    Vout_with_calib_array = zeros(N_Sample, t_AD);
    writeline(GPIB,"OUTE 1");    % output: 1-enable, 0-disable;
    pause(1);
    for i = 1:t_AD
        clean_uart(UART);
        write(UART, UART_CMD_AD, 'uint8');
        data_uart_in_ad = read(UART,4*N_Sample,'uint8');
    
        readingCheck_uart(UART);
        data_N4_ad = data_bin2array(data_uart_in_ad);
        Vout_N4 = data_N4_ad * LSB_SUB;
        
        for j=1:N_Sample
            Vout_without_calib_array(j,i) = Calib_Gain(Vout_N4(j,:), 16);
            Vout_with_calib_array(j,i) = Calib_Gain(Vout_N4(j,:), GAIN);
        end
        
        SINAD_with_calib_List(i) = sinad(Vout_with_calib_array(:,i), Fs);
        SINAD_without_calib_List(i) = sinad(Vout_without_calib_array(:,i), Fs);


        THD_with_calib_List(i) = thd(Vout_with_calib_array(:,i), Fs, 9, 'aliased');
        THD_without_calib_List(i) = thd(Vout_without_calib_array(:,i), Fs, 9, 'aliased');
        fprintf("[%d/%d] SINAD_wi:%.1f, THD_wi:%.1f, SINAD_wo:%.1f, THD_wo:%.1f\n", i, t_AD,...
            SINAD_with_calib_List(i), THD_with_calib_List(i), ...
            SINAD_without_calib_List(i), THD_without_calib_List(i));
    end
    %% Build Output Results;
    result.data_N4_cb = data_N4_calib;
    result.data_N4_ad = data_N4_ad;
    result.GAIN = GAIN;
    result.GAIN_LIST = Gain_list;
    result.data_withcalib = Vout_with_calib_array;
    result.data_withoutcalib = Vout_without_calib_array;
    result.sinad_withcalib = SINAD_with_calib_List;
    result.sinad_withoutcalib = SINAD_without_calib_List;
    result.thd_withcalib = THD_with_calib_List;
    result.thd_withoutcalib = THD_without_calib_List;
end


function readingCheck_uart(UART)
    if (UART.NumBytesAvailable == 0)
%         disp("Data reading from Serial Port Ready!")
    else
        disp("Reading error!");
    end
end 
function results = Calibration_statistics(Vout_N4, Gain_list, num_cycle)
    num_ave = 500;
    num_Gain_tot = num_ave * num_cycle;

%%  Gain Reshape and Average
    Gain = Gain_list(1:num_Gain_tot);
    Gain = reshape(Gain, [num_cycle, num_ave]);
    Gain = mean(Gain,1);

%%  Calculate sinad and thd of each gain
    sinad_list = zeros(1, num_ave);
    thd_list = zeros(1, num_ave);
    
    for i = 1:num_ave
        [sinad_list(i), thd_list(i), ~] = Calib_Gain_seq(Vout_N4, Gain(i));
    end
    
    figure("Name","SINAD")
    plot(sinad_list);
    figure("Name","THD");
    plot(thd_list);

%%  histogram
    Gain_mean = mean(Gain);
    Gain_std = std(Gain);

    sinad_mean = mean(sinad_list);
    sinad_std = std(sinad_list);
    thd_mean = mean(thd_list);
    thd_std = std(thd_list);

    figure("Name", "SINAD_histogram")
    h1 = histogram(sinad_list,'Normalization','probability');
    str1 = {"Number: "+num2str(num_ave, '%d'), ...
            "Mean: "+num2str(sinad_mean, '%.2f'), ...
            "Std: "+num2str(sinad_std, '%.2f')};
    t1 = text(h1.BinEdges(end-2), max(h1.Values), str1);
    t1.BackgroundColor = [1 1 1];
    t1.EdgeColor = [0 0 0];
    t1.HorizontalAlignment = 'center';
    grid on

    figure("Name", "THD_histogram");
    h2 = histogram(thd_list,'Normalization','probability');
    str2 = {"Number: "+num2str(num_ave, '%d'), ...
            "Mean: "+num2str(thd_mean, '%.2f'), ...
            "Std: "+num2str(thd_std, '%.2f')};
    t2 = text(h2.BinEdges(end-2), max(h2.Values), str2);
    t2.BackgroundColor = [1 1 1];
    t2.EdgeColor = [0 0 0];
    t2.HorizontalAlignment = 'center';
    grid on;

    figure("Name", "Gain_histogram");
    h3 = histogram(Gain,'Normalization','probability');
    str3 = {"Number: "+num2str(num_ave, '%d'), ...
            "Mean: "+num2str(Gain_mean, '%.2f'), ...
            "Std: "+num2str(Gain_std, '%.2f')};
    t3 = text(h3.BinEdges(end-2), max(h3.Values), str3);
    t3.BackgroundColor = [1 1 1];
    t3.EdgeColor = [0 0 0];
    t3.HorizontalAlignment = 'center';
    grid on;
    
%%  output results
    results.sinad_mean = sinad_mean;
    results.sinad_std = sinad_std;
    results.thd_mean = thd_mean;
    results.thd_std = thd_std;
    results.Gain_mean = Gain_mean;
    results.Gain_std = Gain_std;
    results.sinad_list = sinad_list;
    results.thd_list = thd_list;

end


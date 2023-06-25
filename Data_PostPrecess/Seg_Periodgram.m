function [f, pxx, mean_sinad, mean_thd ] = Seg_Periodgram(Seg_num, M, Num_2pi, Ydata, fs)
    Seg_len = M*(Num_2pi / Seg_num);
    Seg_sinad = zeros(Seg_num, 1);
    Seg_thd = zeros(Seg_num, 1);
    Seg_pxx = zeros(Seg_num, Seg_len/2+1, 2);
    
    for i=1:Seg_num
        index_head = (i-1)*Seg_len+1;
        index_tail = i*Seg_len;
        data_calib_seg = Ydata(index_head:index_tail,1);
        data_seg = Ydata(index_head:index_tail,2);

        Seg_sinad(i) =  sinad(data_calib_seg, fs);
        Seg_thd(i) = thd(data_calib_seg, fs, 9, "aliased");
        
        data_win = blackmanharris(Seg_len);
        [Seg_pxx(i,:,2), f] =  periodogram(data_calib_seg, data_win, Seg_len, 'onesided',fs, 'Power');
        [Seg_pxx(i,:,1), ~] =  periodogram(data_seg, data_win, Seg_len, 'onesided',fs, 'Power');

    end

    if (Seg_num == 1)
        pxx = Seg_pxx;
    else    
        pxx = mean(Seg_pxx);
    end
    pxx = reshape(pxx, [Seg_len/2+1 2]);
    mean_sinad = mean(Seg_sinad);
    mean_thd = mean(Seg_thd);

    sinad_tot = sinad(Ydata(:,1), fs);
    sfdr_tot = sfdr(Ydata(:,1), fs);
    thd_tot = thd(Ydata(:,1), fs, 9, 'aliased');
    % ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % 创建 figure
    figure1 = figure('InvertHardcopy','off','NumberTitle','off','Name','FFT','Color',[1 1 1]);
    % figure1.width = 600;
    % figure1.height = 400;
    figure1.Position = [100 100 600 450];
    
    % 创建 axes
    axes1 = axes('Parent',figure1);
    hold(axes1,'on');
    
    % 使用 plot 的矩阵输入创建多行
%     semilogx(f,10*log10(pxx),'DisplayName','Power','LineWidth',2,'Color',[0 0 1]);

    plot1 = semilogx(f,10*log10(pxx),'LineWidth',2);
    % plot1(1): withoutcalibration; plot1(2): withcalibration
    set(plot1(2),'DisplayName','Calibration ON','Color',[0 0 1]);
    set(plot1(1),'DisplayName','Calibration OFF','Color', '#9F9F9F');
%     set(plot1(1),'DisplayName','withoutcalibration','Color', [1 0 0]);
   
    % 创建 ylabel
    ylabel('Amplitude (dB)','FontWeight','bold','FontName','Times New Roman');
    
    % 创建 xlabel
    xlabel('Frequency (Hz)','FontWeight','bold',...
        'FontName','Times New Roman');

    % 创建 title
    title('FFT (102400 Samples)','FontWeight','bold',...
        'FontName','Times New Roman');

    % 创建 text annotation
    text_sndr = join(['SNDR: ', num2str(sinad_tot,'%.2f'), ' dB']);
    text_snr = join(['SFDR: ', num2str(sfdr_tot,'%.2f'), ' dB']);
    text_thd = join(['THD: ', num2str(thd_tot,'%.2f'), ' dB']);
    text_str = {text_sndr, text_snr, text_thd};

%     text_noise = join(['Noise Floor: ', num2str(20*log10(std(data))), ' dB']);

    t1 = text(400,-20,text_str, 'HorizontalAlignment','left','FontSize',13, ...
    'FontWeight','bold','FontName','Times New Roman');
    t1.BackgroundColor = [1,1,1];

    % 设置图例
    legend1 = legend(axes1,'show');
    set(legend1,'Location','northeast','LineWidth',2,'FontSize',13);

    % 取消以下行的注释以保留坐标区的 X 范围
    xlim(axes1,[300 1E6]);
    % 取消以下行的注释以保留坐标区的 Y 范围
    ylim(axes1,[-160 10]);
    box(axes1,'on');
    grid(axes1,'on');
    hold(axes1,'off');
    % 设置其余坐标区属性
    set(axes1,'FontName','Times New Roman','FontSize',15,'FontWeight','bold',...
        'LineWidth',1.5,'XScale','log');
end
function V_calib = Calib_Gain(V_uncalib, GainA)
    l = length(V_uncalib);
    V_calib = 0;
    for i = 1:l
        V_calib = V_calib + V_uncalib(i) / GainA^(i-1);
    end    

end
function V_calib = Calib_Gain_hybrid(V_uncalib, GainA)
    l = length(V_uncalib);
    V_calib = 0;
    for i = 1:l
        if (V_uncalib(2) > 0)
            V_calib = V_calib + V_uncalib(i) / GainA(2)^(i-1);
        else
            V_calib = V_calib + V_uncalib(i) / GainA(1)^(i-1);
        end
    end
    
end

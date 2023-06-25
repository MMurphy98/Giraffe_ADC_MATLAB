function Dout = ADConversion_thres(Vin, Vthres)
    Vin_len = length(Vin);
    Dout = zeros(1, Vin_len);
    for i = 1:Vin_len
        index_temp = Vin(i) > Vthres;
        Dout(i) = sum(index_temp);
    end
end

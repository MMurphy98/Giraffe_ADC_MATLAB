function Gain = Newton_Calib(Vout_array, N)
    NUM_BIT_SSAR = 5;
    Code_in = 1;
    Vref = 1.8;
    LSB = Vref / 2^NUM_BIT_SSAR;
    Vout_array_code = Vout_array ;
%     G0 = 16;
%     fG0 = f_G(Vout_array_code, G0);
    Gain = zeros(1,N);
    Gain(1) = 16;
    for i=2:N
        Gain_temp = Gain(i-1);
        Gain(i) = Gain_temp - (f_G(Vout_array_code, Gain_temp) ...
                            /fd_G(Vout_array_code, Gain_temp));
    end
%     plot(Gain)
end 

function f_G = f_G(D_array, G)
    f_G = D_array(1) + D_array(2)/G + D_array(3)/G^2 - 2*G;
end

function fd_G = fd_G(D_array, G)
    fd_G = -2 -D_array(2)/G^2 -2*(D_array(3)/G^3);
end 
function data_N4 = data_bin2array(data)

    data_origin = dec2bin(data);
    data_sign = str2num(data_origin(:,1));
    data_value = data_origin(:,2:end);
    
    data_sign(data_sign==1) = -1;
    data_sign(data_sign==0) = 1;
    data_value = bin2dec(data_value) .* data_sign;
    
    N_Sample = length(data_value) / 4;
    data_N4 = reshape(data_value, [4, N_Sample])';
end
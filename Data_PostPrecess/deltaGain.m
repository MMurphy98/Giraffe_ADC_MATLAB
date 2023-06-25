function Gain = deltaGain(data_N4, num_itr)

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% target equation : 2G = ΔD2 + ΔD3/G + ΔD4/G^2
% f(x) = ΔD2 + ΔD3/G + ΔD4/G^2 - 2G
% f'(x) = -ΔD3/G^2 -2ΔD4/G^3 - 2
% G(i+1) = G(i) - f(G(i))/f'(G(i)) 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


    Gain_length = length(data_N4)/2;
    delta_array_code = zeros(Gain_length, width(data_N4));
    Gain_resutls = zeros(Gain_length, num_itr);

    % data pre-process
    for i = 1:Gain_length
        delta_array_code(i,:) = data_N4(2*i-1,:) - data_N4(2*i,:);
    end

    % Newton Iteration
    Gain_resutls(:, 1) = 16;
    for j = 1:Gain_length
        for i = 2:num_itr
            Gain_temp = Gain_resutls(j,i-1);
            Gain_resutls(j,i) = Gain_temp - (f_G(delta_array_code(j,:), Gain_temp) ...
                            /fd_G(delta_array_code(j,:), Gain_temp));
        end
    end
    Gain = Gain_resutls(:, num_itr);
end


function f_G = f_G(D_array, G)      % f(x)
    f_G = D_array(1) + D_array(2)/G + D_array(3)/G^2 - 2*G;
end

function fd_G = fd_G(D_array, G)    % f'(x)
    fd_G = -D_array(2)/G^2 -2*(D_array(3)/G^3) - 2;
end 
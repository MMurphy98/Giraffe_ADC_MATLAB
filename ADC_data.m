classdef ADC_data
    %ADC_data 表示ADC发射数据的存储数据类型
    %   此处提供详细说明

    properties
        tag
        int
        sign
        value
    end
%%
    methods
        function obj = ADC_data(int, bin)
            %ADC_data 构造此类的实例
            %   此处提供详细说明
            obj.tag = bin(1:2);
            obj.int = int;
            if (bin(3) == 1)
                obj.sign = 1;
            else
                obj.sign = -1;
            end
            obj.value = bin2dec(bin(4:end));
        end


        function Check(obj)
            %Check 此处提供此方法的摘要
            %   此处提供详细说明
            if (obj.tag ~= '00' && obj.tag~= '11')
                disp("Data Error!");
            else
                fprintf('Data Int: %d, Tag: %s', obj.int, obj.tag);
            end
        end

        function vout = Calculate(obj, Vref, N)
            dem = obj.value * obj.sign;
            vout = Vref * dem / N;
        end
    end
end
classdef Giraffe_Sample_Data
    %Giraffe_Sample_Data 用于存储并后处理关于Giraffe ADC采样的结果
    %   此处提供详细说明

    properties
        FileName
        Data_bin
        Data
        Data_woCalib
        Data_wiCalib
        len
    end

    methods
        function obj = Giraffe_Sample_Data(filename)
            %Giraffe_Sample_Data 构造此类的实例
            obj.FileName = filename;
            data_read = importdata(filename, 'data');
            obj.Data_bin = dec2bin(data_read);
            
            % 读取符号位和数值
            data_sign = bin2dec(obj.Data_bin(:,1));
            data_value = bin2dec(obj.Data_bin(:,2:end));

            data_sign(data_sign==1) = -1;
            data_sign(data_sign==0) = 1;
            data_value = data_value .* data_sign;

            % 将穿行输出的数据转化为并行输出的数据，方便后续才做
            obj.len = length(data_value) / 4;
            obj.Data = reshape(data_value, [4, obj.len])';
            
            % 默认进行Gain=16进行数字码转换
            obj = WithoutCalibration(obj);

        end

        function obj = WithoutCalibration(obj)
            %WithCalibration 用增益16进行数字码转换
            for i = 1:obj.len
                obj.Data_woCalib(i) = Calib_Gain(obj.Data(i,:), 16);
            end
        end

        function obj = WithCalibration(obj, Gain)
            %WithCalibration 用增益Gain进行数字码转换
            for i = 1:obj.len
                obj.Data_wiCalib(i) = Calib_Gain(obj.Data(i,:), Gain);
            end
        end
    end
end
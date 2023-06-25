function clean_uart(UART)
    if (UART.NumBytesAvailable > 0)
        read(UART,UART.NumBytesAvailable,'uint8');
    end  
end
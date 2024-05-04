bitrate = 100e6; 
baudrate = 125e6; %частота передатчика в Гц

data = randi([0 1], 1000, 1); %генерация данных для передачи

function encoded_data = encode4b5b(data)
%реализация кодирования 4B/5B

coding_table = [
    1 1 1 1 0; %0000
    0 1 0 0 1; %0001
    1 0 1 0 0; %0010
    1 0 1 0 1; %0011
    0 1 0 1 0; %0100
    0 1 0 1 1; %0101
    0 1 1 1 0; %0110
    0 1 1 1 1; %0111
    1 0 0 1 0; %1000
    1 0 0 1 1; %1001
    1 0 1 1 0; %1010
    1 0 1 1 1; %1011
    1 1 0 1 0; %1100
    1 1 0 1 1; %1101
    1 1 1 0 0; %1110
    1 1 1 0 1  %1111
];

data_blocks = reshape(data, 4, [])'; %разбиение исходных данных на блоки по 5 бит

encoded_data_blocks = coding_table(bin2dec(compose("%d%d%d%d",data_blocks)) + 1,:); % 

encoded_data = reshape(encoded_data_blocks',ceil(size(data)/4)*5,[]);

end
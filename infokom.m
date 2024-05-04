bitrate = 100e6; 
baudrate = 125e6; %частота передатчика в Гц

data = randi([0 1], 1000, 1); %генерация данных для передачи

function processed_data = coding4b5b(data,type)
%реализация кодирования/декодирования 4B/5B

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
if type == "encode"
    if mod(size(data,1),4) > 0
        data = [zeros(4-mod(size(data,1),4),1);data]; %добавление в начало незначущих нулей для разбиения по 4
    end
    
    data_blocks = reshape(data, 4, [])'; %разбиение исходных данных на блоки по 4 бита
    
    encoded_data_blocks = coding_table(bin2dec(compose("%d%d%d%d",data_blocks)) + 1,:); %преобразование блоков с длиной 4 в блоки с длиной 5 с помощью таблицы кодирования
    
    processed_data = reshape(encoded_data_blocks',ceil(size(data)/4)*5,[]); %преобразование блоков по 5 в обычный одномерный массив

elseif type == "decode"
    data_blocks = reshape(data, 5, [])';

    processed_data = [];
    for i = 1:size(data_blocks,1)
        for j = 1: size(coding_table,1)
            if prod(data_blocks(i,:) == coding_table(j,:)) == 1
                temp = dec2binvec(j-1,4); %нахождение исходных данных из 5-ти битового кода
                processed_data = [processed_data;[temp(end:-1:1)]']; %инверсия порядка из-за особенностей функции dec2binvec
                break;
            end
        end
    end

else
    disp("incorrect type argument")
end

end

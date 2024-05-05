%bitrate = 100e6; 
%dbaudrate = 125e6; %частота передатчика в Гц

data = randi([0 1], 1000, 1); %генерация данных для передачи

encoded4b5b_data = coding4b5b(data,"encode");

encoded_mtl3_data = mtl3(encoded4b5b_data,"encode");

%иммитация шума и потерь
dt = 100; %длина одного бита

t = 1:dt*length(encoded_mtl3_data);

f = repelem(encoded_mtl3_data,dt);

f = f + randn(length(t),1)/5;%добавление шума
f = f * 0.8;

plot(t,f)
hold on
plot(t,repelem(encoded_mtl3_data,dt))
xlim([0 50*dt])
ylim([-1.2 1.2])
hold off

recieved_data = [];

for i = 1:dt:length(f)
    average_value_per_bit = mean(f(i:i+dt-1));
    if average_value_per_bit > 0.5
        recieved_data = [recieved_data;1];
    elseif average_value_per_bit < -0.5
        recieved_data = [recieved_data;-1];
    else
        recieved_data = [recieved_data;0];
    end
end

%disp(prod(encoded_mtl3_data == recieved_data))

decoded_mtl3_data = mtl3(recieved_data,"decode");

decoded_data = coding4b5b(decoded_mtl3_data, "decode");

disp(prod(decoded_data == data))

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
        data = [zeros(round4-mod(size(data,1),4),1);data]; %добавление в начало незначущих нулей для разбиения по 4
    end
    
    data_blocks = reshape(data, 4, [])'; %разбиение исходных данных на блоки по 4 бита
    
    encoded_data_blocks = coding_table(bin2dec(compose("%d%d%d%d",data_blocks)) + 1,:); %преобразование блоков с длиной 4 в блоки с длиной 5 с помощью таблицы кодирования
    
    processed_data = reshape(encoded_data_blocks',ceil(size(data,1)/4)*5,[]); %преобразование блоков по 5 в обычный одномерный массив

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

function processed_data = mtl3(data,type)

if type == "encode"
    processed_data = [-1];
    t = [-1 0 1 0];
    l = 1;

    for i = 1:length(data)
        if data(i) == 1
            l = l + 1;
            if l > 4
                l = 1;
            end
        end
        processed_data = [processed_data;t(l)];
    end
elseif type == "decode"
    processed_data = [];
    prev_level = -1;
    
    for i = 2:length(data)
        if data(i) == prev_level
            processed_data = [processed_data; 0];
        else
            processed_data = [processed_data; 1];
        end
        prev_level = data(i);
    end
else
    disp("incorrect type argument")
end

end


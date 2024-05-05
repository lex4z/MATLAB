
data = randi([0 1], 1000, 1); %генерация данных для передачи

encoded4b5b_data = coding4b5b(data,"encode");

encoded_mtl3_data = mtl3(encoded4b5b_data,"encode");

%иммитация шума и потерь
dt = 100; %длина одного бита

t = 1:dt*length(encoded_mtl3_data);%время, которое разбивает каждый бит на dt частей, чтобы можно было добавить к ним шум для моделирования передачи

f = repelem(encoded_mtl3_data,dt);%превращает массив [1, 2, 3] в [1,1,2,2,3,3] если после запятой стоит аргумент 2, в данном случае нужна для формирования прямоугольных импульсов

f = f + randn(length(t),1)/5;%добавление шума
f = f * 0.8; %добавления ослабления(потерь)

plot(t,f)%график искажённого передачей сигнала
hold on
plot(t,repelem(encoded_mtl3_data,dt))%график исходного сигнала для сравнения
xlim([0 50*dt]) %пределы по t, чтобы было видно сами импульсы
ylim([-1.2 1.2])%пределы по y, чтобы они не изменялись из-за разного максимального уровня шума
hold off

recieved_data = [];

%перевод полученного сигнала к уровням -1 0 1 для последующего декодирования
for i = 1:dt:length(f)
    average_value_per_bit = mean(f(i:i+dt-1));%нахождение среднего значения y на длине одного бита
    if average_value_per_bit > 0.5 %сравнение этого значения с 0.5, т.к. именно с такого значения мы считаем что получили 1
        recieved_data = [recieved_data;1];
    elseif average_value_per_bit < -0.5%аналогично предыдущему, но для -1
        recieved_data = [recieved_data;-1];
    else %если не 1 и -1, то значит между, следовательно 0
        recieved_data = [recieved_data;0];
    end
end

%disp(prod(encoded_mtl3_data == recieved_data))

decoded_mtl3_data = mtl3(recieved_data,"decode");

decoded_data = coding4b5b(decoded_mtl3_data, "decode");

disp(prod(decoded_data == data)) %отображает 1, если исходные данные и полученные после декодирования равны

function processed_data = coding4b5b(data,type)
%реализация кодирования/декодирования 4B/5B

% таблица для кодирования 4B/5B где индекс-1 это значение кода из 4 бит
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
    data_blocks = reshape(data, 5, [])';%разбиение входных данных на блоки по 5 бит

    processed_data = [];
    for i = 1:size(data_blocks,1) %прохождение по всем блокам входных данных
        for j = 1: size(coding_table,1) %прохождение через таблицу кодирования для нахождения соответствующего 5-ти битового кода
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
    processed_data = [-1];%есть стартовое значение, чтобы была информация о изменении или отсутсвии изменений в первом бите
    t = [-1 0 1 0]; %значения по которым циклически меняется значение уровня, если входной бит равен 1
    l = 1;%индекс для циклического прохождения по значениям выше

    for i = 1:length(data)%прохождение по всем входным битам
        if data(i) == 1
            l = l + 1;%увеличение индекса на 1, когда входной бит 1
            if l > 4
                l = 1; %при выходе за границы массива индекс ставится в начальное значение
            end
        end
        processed_data = [processed_data;t(l)];% добавление соответсвующего уровня в выход 
    end
elseif type == "decode"
    processed_data = [];
    prev_level = -1;%т.к. было стартовое значение, то по-умолчанию предыдущее равно ему
    
    for i = 2:length(data) %прохождение по данным от второго значения, т.к. первое всегда одинаковое и равно -1
        if data(i) == prev_level %если нет изменения уровня, то был закодирован 0, что и добавляем в декодированные данные
            processed_data = [processed_data; 0];
        else %если уровень изменяется, то был закодирован 1
            processed_data = [processed_data; 1];
        end
        prev_level = data(i); %берём текущий уровень за предыдущий, т.к. он станет предыдущим для следующей итерации 
    end
else
    disp("incorrect type argument")
end

end


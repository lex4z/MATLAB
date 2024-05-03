aa = ones(3,3);
ll = ones(3);

%% задание начал и длин прмежутков
%L1
ll(1) = 9;
aa(1,1) = 0;
aa(2,1) = 5;
aa(3,1) = -5;

%L2
ll(2) = 8;
aa(1,2) = -1;
aa(2,2) = -2;
aa(3,2) = -4;

%L3
ll(3) = 11;
aa(1,3) = -2;
aa(2,3) = -5;
aa(3,3) = -3;

%% 2. ошибка при разной степени полинома при одном количестве точек
k = 1;

for i = 1:3
    for j = 1:3
        for N = 8:-1:6
            a = aa(i,j);%начало промежутка
            b = aa(i,j)+ll(j);%конец промежутка (начало + длина)
            nFunc = i;  %(i-1)*3+j; %1-9 номер ф-ии, плоские массивы люблю очень

            %исходная функция для сравнения с полиномом и нахождения
            %разницы
            x1 = linspace(a,b,10000);
            y1 = getff(x1,nFunc,0);% 0 - процент ошибки измерений (епселон)
            
            for n = N-1:-1:N-3
                %значения полинома в обычной сетке
                xt = linspace(a,b,N);
                ft = getff(xt,nFunc,0);
                fx1 = polyval(polyfit(xt,ft,n),x1);

                %ошибка в обычной сетке
                err1 = abs(y1-fx1)/(max(y1)-min(y1));
                eSKO1 = sqrt(sum(err1.^2)/length(err1));
                eMAX1 = max(err1);
                
                %вывод результатов в k-ую строку таблицы
                RES(k,1) = i; %номер ф-ии
                RES(k,2) = j; %номер промежутка для этой ф-ии
                RES(k,3) = N;
                RES(k,4) = n;
                RES(k,5) = eSKO1;
                RES(k,6) = eMAX1;

                k = k + 1;
            end
        end
    end
end
writematrix(RES,"RES11.xlsx")

%% 3. ошибка при N->inf
clear RES;
k = 1;
n = 3;

for i = 1:3
    for j = 1:3
        N = n + 1;
        eMAX = 1;
        eSKO = 1;
        for q = 1:10
            a = aa(i,j);%начало промежутка
            b = aa(i,j)+ll(j);%конец промежутка (начало + длина)
            nFunc = i; % (i-1)*3+j; %1-9 номер ф-ии, плоские массивы люблю очень

            %исходная функция для сравнения с полиномом и нахождения
            %разницы
            x1 = linspace(a,b,10000);
            y1 = getff(x1,nFunc,0);% 0 - процент ошибки измерений (епселон)
            
            %значения полинома в обычной сетке
            xt = linspace(a,b,N);
            ft = getff(xt,nFunc,0);
            fx1 = polyval(polyfit(xt,ft,n),x1);

            %ошибка в обычной сетке
            err1 = abs(y1-fx1)/(max(y1)-min(y1));
            eSKO1 = sqrt(sum(err1.^2)/length(err1));
            eMAX1 = max(err1);

            RES(k,1) = i;
            RES(k,2) = j;
            RES(k,3) = N;
            RES(k,4) = eSKO1;
            RES(k,5) = eMAX1;
            RES(k,6) = 100*abs(eMAX1-eMAX)/eMAX1;
            RES(k,7) = 100*abs(eSKO1-eSKO)/eSKO1;
            k = k + 1;

            if abs(eMAX1-eMAX)/eMAX <= 0.1 || abs(eSKO1-eSKO)/eSKO <= 0.1
                break;
            end
            N = N * 3;

            eSKO = eSKO1;
            eMAX = eMAX1;

        end
    end
end
writematrix(RES,"RES22.xlsx")

%% 4. увеличение ошибки при увеличении епселон
clear RES;
k = 1;
epsf = [0,0.1,0.5,1,5,10,100];
n = 8;
N = n + 1;

for i = 1:3
    for j = 1:3
        for t = 1:length(epsf)
            a = aa(i,j);%начало промежутка
            b = aa(i,j)+ll(j);%конец промежутка (начало + длина)
            nFunc = i;% (i-1)*3+j; %1-9 номер ф-ии, плоские массивы люблю очень
        
            %исходная функция для сравнения с полиномом и нахождения
            %разницы
            x1 = linspace(a,b,10000);
            y1 = getff(x1,nFunc,0);% 0 - процент ошибки измерений (епселон)

            xt = linspace(a,b,N);
            ft = getff(xt,nFunc,epsf(t));
            fx1 = polyval(polyfit(xt,ft,n),x1);

            err1 = abs(y1-fx1)/(max(y1)-min(y1));
            eSKO1 = sqrt(sum(err1.^2)/length(err1));
            eMAX1 = max(err1);
            
            RES(k,1) = i;
            RES(k,2) = j;
            RES(k,3) = epsf(t);
            RES(k,4) = eSKO1;
            RES(k,5) = eMAX1;

            k = k + 1;
        end
    end
end
writematrix(RES,"RES33.xlsx")

%% 5. сравнение ошибок в обычной и сетке Чебышева 
clear RES;
k = 1;

for i = 1:3
    for j = 1:3
        for N = 8:-1:6
            a = aa(i,j);%начало промежутка
            b = aa(i,j)+ll(j);%конец промежутка (начало + длина)
            nFunc = i;%(i-1)*3+j; %1-9 номер ф-ии, плоские массивы люблю очень

            %исходная функция для сравнения с полиномом и нахождения
            %разницы
            x1 = linspace(a,b,10000);
            y1 = getff(x1,nFunc,0);% 0 - процент ошибки измерений (епселон)
            
            for n = N-1:-1:N-3
                %значения полинома в обычной сетке
                xt = linspace(a,b,N);
                ft = getff(xt,nFunc,0);
                fx1 = polyval(polyfit(xt,ft,n),x1);

                %ошибка в обычной сетке
                err1 = abs(y1-fx1)/(max(y1)-min(y1));
                eSKO1 = sqrt(sum(err1.^2)/length(err1));
                eMAX1 = max(err1);
                
                %знаичеия полинома в сетке Чебышева
                m = 1:N;
                x2 = (b+a)/2+(b-a)*cos(pi*(2*m-1)/(2*N))/2;
                y2 = getff(x2,nFunc,0);
                fx2 = polyval(polyfit(x2,y2,n),x1);

                %ошибка в сетке Чебышева
                err2 = abs(y1-fx2)/(max(y1)-min(y1));
                eSKO2 = sqrt(sum(err2.^2)/length(err2));
                eMAX2 = max(err2);

                %дельта ошибок
                dSKO = eSKO1 - eSKO2;
                dMAX = eMAX1 - eMAX2;

                %вывод результатов в k-ую строку таблицы
                RES(k,1)=i;
                RES(k,2)=j;
                RES(k,3)=N;
                RES(k,4)=n;
                RES(k,5)=dSKO;
                RES(k,6)=dMAX;

                k = k + 1;
            end
        end
    end
end
writematrix(RES,"RES44.xlsx")

%% 6. ошибки в сетке Чебышева (work in progress)
clear RES;
k = 1;
n = 3;

for i = 1:3
    for j = 1:3
        N = n + 1;
        eMAX = 1;
        eSKO = 1;
        for q = 1:10
            a = aa(i,j);%начало промежутка
            b = aa(i,j)+ll(j);%конец промежутка (начало + длина)
            nFunc = i;%(i-1)*3+j; %1-9 номер ф-ии, плоские массивы люблю очень

            %исходная функция для сравнения с полиномом и нахождения
            %разницы
            x1 = linspace(a,b,10000);
            y1 = getff(x1,nFunc,0);% 0 - процент ошибки измерений (епселон)
            
            %знаичения полинома в сетке Чебышева
            m = 1:N;
            x2 = (b+a)/2+(b-a)*cos(pi*(2*m-1)/(2*N))/2;
            y2 = getff(x2,nFunc,0);
            fx2 = polyval(polyfit(x2,y2,n),x1);
            
            %ошибка в сетке Чебышева
            err2 = abs(y1-fx2)/(max(y1)-min(y1));
            eSKO2 = sqrt(sum(err2.^2)/length(err2));
            eMAX2 = max(err2);


            RES(k,1) = i;
            RES(k,2) = j;
            RES(k,3) = N;
            RES(k,4) = eSKO2;
            RES(k,5) = eMAX2;
            RES(k,6) = 100*abs(eMAX2-eMAX)/eMAX;
            RES(k,7) = 100*abs(eSKO2-eSKO)/eSKO;
            k = k + 1;

            if abs(eMAX2-eMAX)/eMAX <= 0.1 || abs(eSKO2-eSKO)/eSKO <= 0.1
                break;
            end
            N = N * 3;

            eSKO = eSKO2;
            eMAX = eMAX2;

        end
    end
end
writematrix(RES,"RES55.xlsx")

%% 7. увеличение ошибки при увеличении епселон в сетке Чебышева
clear RES;
k = 1;
epsf = [0,0.1,0.5,1,5,10,100];
n = 8;
N = n + 1;

for i = 1:3
    for j = 1:3
        for t = 1:length(epsf)
            a = aa(i,j);%начало промежутка
            b = aa(i,j)+ll(j);%конец промежутка (начало + длина)
            nFunc = i; %(i-1)*3+j; %1-9 номер ф-ии, плоские массивы люблю очень
        
            %исходная функция для сравнения с полиномом и нахождения
            %разницы
            x1 = linspace(a,b,10000);
            y1 = getff(x1,nFunc,0);% 0 - процент ошибки измерений (епселон)

            %знаичения полинома в сетке Чебышева
            m = 1:N;
            x2 = (b+a)/2+(b-a)*cos(pi*(2*m-1)/(2*N))/2;
            y2 = getff(x2,nFunc,epsf(t));
            fx2 = polyval(polyfit(x2,y2,n),x1);
            
            %ошибка в сетке Чебышева
            err2 = abs(y1-fx2)/(max(y1)-min(y1));
            eSKO2 = sqrt(sum(err2.^2)/length(err2));
            eMAX2 = max(err2);
            
            RES(k,1) = i;
            RES(k,2) = j;
            RES(k,3) = epsf(t);
            RES(k,4) = eSKO2;
            RES(k,5) = eMAX2;

            k = k + 1;
        end
    end
end
writematrix(RES,"RES66.xlsx")
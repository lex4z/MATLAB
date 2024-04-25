%clear
%clc
f1 = @(x) sin(x/3-1.1337142642462) + x/2 + 0.583715;
f2 = @(x) cos(x/50);

opt = optimset('TolFun',5e-16);
x0 = fzero(f1,0,opt);

x01 = fzero(f2,0,opt);
f2a = @(x) f2(x)/(x-x01);
x02 = fzero(f2a,0,opt);

%% Бисекция
l = 1;

A = [-3,-8,-4,-90,90,-90];
B = [ 5, 2, 6,-40,40, 90];
clear RES;

f = f1;

for i = 1:6
    %at = -(randperm(9,1)+1); %randperm(N = макс. значение, n = кол-во чисел(<= N))
    %bt = randperm(9,1)+1;    %генерирует n чисел в пределах от 1 до N включительно

    epsf = 1e-1;

    if i > 3
        f = f2;
    end

    for j = 1:5
        a = A(i);
        b = B(i);
        
        for k = 1:1e5
            c = (a+b)/2;
            if abs(f(c)) <= epsf
                break;
            end
            
            if f(a) * f(c) < 0
                b = c;
            elseif f(b) * f(c) < 0
                a = c;
            else
                a = (a+c)/2;
                b = (b+c)/2;
            end
        end
        %err = abs(x0-c) * mod(ceil(i/3),2) + floor((i-1)/3) * abs(x01-c); %да

        err = abs(x0-c);
        
        if i > 3
            err = min(abs(x01 - c), abs(x02 - c));
        end

        RES(l,1) = ceil(i/3);
        RES(l,2) = A(i);
        RES(l,3) = B(i);
        RES(l,4) = epsf;
        RES(l,5) = c;
        RES(l,6) = f(c);
        RES(l,7) = err;
        RES(l,8) = k;

        epsf = epsf^2;%*1e-2;
        l = l+1;
    end
end

writematrix(RES,"RES221.xlsx")

%% Метод Ньютона

clear RES;
df = @(x) cos(x/3 - 2552897569001901/2251799813685248)/3 + 1/2;
XK = [A(1:3),B(1:3),A(4:6),B(4:6)];
f = f1;
o = 0;
l = 1;
for i = 1:12

    epsf = 1e-1;  

    if i > 6
        f = f2;
        df = @(x) -sin(x/50)/50;
        %o = 6;
    end
    
    

    for j = 1:5
        xk = XK(i); %XK(i-o);  %xk = XK(mod(i,7) + floor(i/7));%чтобы дважды идти от 1 до 6
        
        for k = 1:1e5
            if df(xk) == 0
                disp("ПРОИЗВОДНАЯ НОЛЬ, иди на")
                break;
            end
            if abs(f(xk)) <= epsf
                break;
            end
            xk = xk - f(xk)/df(xk);
        end
        %err = abs(x0-c) * mod(ceil(i/3),2) + floor((i-1)/3) * abs(x01-c); %да

        err = abs(x0-xk);
        
        if i > 6
            err = min(abs(x01 - xk), abs(x02 - xk));
        end

        RES(l,1) = ceil(i/6);
        RES(l,2) = XK(i-o);
        RES(l,3) = epsf;
        RES(l,4) = xk;
        RES(l,5) = f(xk);
        RES(l,6) = err;
        RES(l,7) = k;

        %RES(l,8) = k;

        epsf = epsf^2;%*1e-2;
        l = l+1;
    end
end

writematrix(RES,"RES222.xlsx")

%% Метод Секущих work in progress

clear RES;

for i = 1:6
   AA(i*2-1)=A(i);
   AA(i*2)=B(i);
end
for i = 1:6
   BB(i*2-1)=B(i);
   BB(i*2)=A(i);
end

f = f1;
o = 0;
l = 1;
for i = 1:12

    epsf = 1e-1;  

    if i > 6
        f = f2;
        %o = 6;
    end
    
    for j = 1:5
        xk0 = AA(i);  %xk = XK(mod(i,7) + floor(i/7));%чтобы дважды идти от 1 до 6
        xk1 = BB(i);
        buff = 0;

        for k = 1:1e5
            buff = xk1;
            if abs(f(xk1)) <= epsf
                break;
            end

            xk1 = xk1 - f(xk1)*(xk1-xk0)/(f(xk1)-f(xk0));
            xk0 = buff;
        end
        %err = abs(x0-c) * mod(ceil(i/3),2) + floor((i-1)/3) * abs(x01-c); %да

        err = abs(x0-xk1);
        
        if i > 6
            err = min(abs(x01 - xk1), abs(x02 - xk1));
        end

        RES(l,1) = ceil(i/6);
        RES(l,2) = AA(i-o);
        RES(l,3) = BB(i-o);
        RES(l,4) = epsf;
        RES(l,5) = xk1;
        RES(l,6) = f(xk1);
        RES(l,7) = err;
        RES(l,8) = k;
        

        epsf = epsf^2;%*1e-2;
        l = l+1;
    end
end

writematrix(RES,"RES223.xlsx")

%% Метод релаксации work in progress

clear RES;

df = @(x) cos(x/3 - 2552897569001901/2251799813685248)/3 + 1/2;
f = f1;
o = 0;
l = 1;
for i = 1:6

    epsf = 1e-1;

    if i > 3
        f = f2;
        o = 3;
        df = @(x) -sin(x/50)/50;
    end
    
    for j = 1:5
        xk = B(i-o);
        tau(1) = -2/df(xk);
        tau(2) = tau(1)/2;
        tau(3) = tau(1)/15;

        for q = 1:3
            xk = B(i);
            for k = 1:1e5
                if abs(f(xk)) <= epsf
                    break;
                end

                xk = xk + tau(q)*f(xk);
            end

            err = abs(x0-xk);
            
            if i > 3
                xk = mod(xk,50*pi);
                err = min(abs(x01 - xk), abs(x02 - xk));
            end

            RES(l,1) = ceil(i/3);
            RES(l,2) = B(i);
            RES(l,3) = tau(q);
            RES(l,4) = epsf;
            RES(l,5) = xk;
            RES(l,6) = f(xk);
            RES(l,7) = err;
            RES(l,8) = k;
            
            
            l = l+1;
        end
        epsf = epsf^2;%*1e-2;
    end
end

writematrix(RES,"RES224.xlsx")
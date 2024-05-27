clc
clear

a = 1;
b = 6;
c = 2;
d = 4.5;

f = @(x,y) x.^3 + x.*y + y.^3 -7./(x.*y);
I_real = 1433.96968174788;


eps = [1e2,1e1,1e0,1e-1,1e-2];
n = [10,50,100,500,1000];

j = 1;

for i = 1:length(eps)
    
    disp(j)
    
    [I1,n1,~] = runge(f,a,b,c,d,4,eps(i),@double_simpson,4);
    [I2,n2,~] = runge(f,a,b,c,d,4,eps(i),@double_trapezoid,2);
    [I3,n3,~] = runge(f,a,b,c,d,4,eps(i),@double_rectangle,1,0);
    [I4,n4,~] = runge(f,a,b,c,d,4,eps(i),@double_rectangle,1,1);
    [I5,n5,~] = runge(f,a,b,c,d,4,eps(i),@double_rectangle,2,0.5);

    [I12,~,epsf1] = runge(f,a,b,c,d,n(i),1e5,@double_simpson,4);
    [I22,~,epsf2] = runge(f,a,b,c,d,n(i),1e5,@double_trapezoid,2);
    [I32,~,epsf3] = runge(f,a,b,c,d,n(i),1e5,@double_rectangle,1,0);
    [I42,~,epsf4] = runge(f,a,b,c,d,n(i),1e5,@double_rectangle,1,1);
    [I52,~,epsf5] = runge(f,a,b,c,d,n(i),1e5,@double_rectangle,2,0.5);

    RES(j,1) = n(i);
    RES(j,2) = epsf1;
    RES(j,3) = epsf2;
    RES(j,4) = epsf3;  
    RES(j,5) = epsf4;
    RES(j,6) = epsf5;

    RES(j,11) = eps(i);
    RES(j,12) = n1;
    RES(j,13) = n2;
    RES(j,14) = n3;
    RES(j,15) = n4;
    RES(j,16) = n5;

    RES(j,21) = n(i);
    RES(j,22) = vpa(I12,8);
    RES(j,23) = vpa(I22,8);
    RES(j,24) = vpa(I32,8);
    RES(j,25) = vpa(I42,8);
    RES(j,26) = vpa(I52,8);

    RES(j,31) = eps(i);
    RES(j,32) = vpa(I1,8);
    RES(j,33) = vpa(I2,8);
    RES(j,34) = vpa(I3,8);
    RES(j,35) = vpa(I4,8);
    RES(j,36) = vpa(I5,8);


    j = j + 1;
end
writematrix(RES,"KURSACH.xlsx")

%% правило Рунге
function [result,n,t] = runge(f, a, b, c, d, n, eps, integr, k, bias)

flag = 0;
if nargin == 10
    flag = 1;
end

t = 1e5;
if flag == 1
    i2 = integr(f,a,b,c,d,n/2,n/2,bias);
else
    i2 = integr(f,a,b,c,d,n/2,n/2);
end


for j = 1:1e3
    if flag == 1
        i1 = integr(f,a,b,c,d,n,n,bias);
    else
        i1 = integr(f,a,b,c,d,n,n);
    end

    t = abs(i1-i2);
    if(t <= eps)
        break
    end
    n = n*2;
    i2 = i1;
end

result = i1 + (i1-i2)/15;

end


%% метод Симпсона 
function result = simpson(f,a,b,n,y)
n = n + mod(n,2);
h = (b-a)/n;

s = 0;
t1 = f(a,y);

for i = 1:2:n-1
    t2 = f(a+i*h,y);
    t3 = f(a+(i+1)*h,y);
    s = s + t1 + 4*t2 + t3;
    t1 = t3;
end

result = h/3*s;
end



function result = double_simpson(f, a, b, c, d, n, m)
m = m + mod(m,2);

k = (d-c)/m;

g = 0;
l1 = simpson(f,a,b,n,c);

for j = 1:2:m-1
    l2 = simpson(f,a,b,n,c+j*k);
    l3 = simpson(f,a,b,n,c+(j+1)*k);
    g = g + l1 + 4*l2 + l3;
    l1 = l3;
end

result = g*k/3;

end


%% метод трапеций
function result = trapezoid(f, a, b, n, y)
h = (b-a)/n;
s = 0.5*(f(a,y)+f(b,y));
for i = 1:n-1
    s = s + f(a + i*h,y);
end

result = s * h;

end



function result = double_trapezoid(f, a, b, c, d, n, m)
k = (d-c)/m;
t = 0.5*(trapezoid(f,a,b,n,c) + trapezoid(f,a,b,n,d));
for j = 1:m-1
    t = t + trapezoid(f,a,b,n,c + j*k);
end

result = t * k;

end


%% метод прямоугольников
function result = rectangle_int(f, a, b, n, bias, y)
%bias = 0 (left), 1 (right), 0.5 (central)
h = (b-a)/n;
s = 0;
x = a + bias*h;

for i = 1:n
    s = s + f(x,y);
    x = x + h;
end

result = s*h;

end



function result = double_rectangle(f, a, b, c, d, n, m, bias)
%bias = 0 (left), 1 (right), 0.5 (central)
k = (d-c)/m;
t = 0;
y = c + bias*k;

for i = 1:m
    t = t + rectangle_int(f,a,b,n,bias,y);
    y = y + k;
end

result = t*k;
end
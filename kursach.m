clear
clc
f = @(x,y) x.^3 + x.*y + y.^3 -7./(x.*y);
f2 = @(x) x.^2 - x + sqrt(x);

integral2(f,1,6,2,4.5)
double_simpson(f,1,6,2,4.5,100,100)
%integral(f2,0,5)
%simpson(f2,0,5,1e3)

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

function result = trapezoid(f, a, b, n)


end

function result = rectangle(f, a, b, n, type)
%type = left, right, central

end
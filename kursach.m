clear
clc

a = 1;
b = 6;
c = 2;
d = 4.5;

f = @(x,y) x.^3 + x.*y + y.^3 -7./(x.*y);
f2 = @(x,y) x.^2 - x + sqrt(x);

fprintf("%f\n",integral2(f,a,b,c,d))
fprintf("%f\n",double_simpson(f,a,b,c,d,100,100))
fprintf("%f\n",double_trapezoid(f,a,b,c,d,1000,1000))
fprintf("%f\n",double_rectangle(f,a,b,c,d,1000,1000, 0))
fprintf("%f\n",double_rectangle(f,a,b,c,d,1000,1000, 0.5))
fprintf("%f\n",double_rectangle(f,a,b,c,d,1000,1000, 1))

% fprintf("%f\n",integral(f2,0,5))
% fprintf("%f\n",simpson(f2,0,5,1e3,0))
%fprintf("%f\n",trapezoid(f2,0,5,1e3,0))
% fprintf("%f\n",rectangle_int(f2,0,5,1e3,0,0))
% fprintf("%f\n",rectangle_int(f2,0,5,1e3,0.5,0))
% fprintf("%f\n",rectangle_int(f2,0,5,1e3,1,0))

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
f = @(x,y) x.^3 + x.*y +y.^3 -7./(x.*y);
f2 = @(x) x.^2 - x;

integral2(f,1,6,2,4.5)
double_simpson(f,1,6,2,4.5,10000,10000)
%integral(f2,0,5)
%simpson(f2,0,5,1e7)

%plot(f2(linspace(0,5,100)))

function result = double_simpson(f, a, b, c, d, m, n)
m = m + mod(m,2);
n = n + mod(n,2);

h = (b-a)/m;
k = (d-c)/n;

s = 0;
x = a;
y = c;

for i = 1:m/2
    l1 = f(x,c) + f(x,d);
    for j = 1:n-1
        y = y + k;
        
    end

end

result = s*k/3;

end

function result = trapezoid(f, a, b, n)


end

function result = rectangle(f, a, b, n, type)
%type = left, right, central

end
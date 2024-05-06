f = @(x,y) x^3 + x*y +y^3 -7/(x*y);

t = zeros(100);
x = linspace(2,4.5,100);
y = linspace(1,6,100);
for i = 1:100
    for j = 1:100
        t(i,j) = f(x(i),y(j));
    end
end

plot(t)

%plot(f(linspace(1,6,100),linspace(2,4.5,100)))

function result = simpson(f, a, b, n)

n = n + mod(n,2); % делает число разбиений чётным для любого n (прибавление 1, если нечётное)

h = (b-a)/n; %длина одного промежутка при разделении [a,b] на n частей

s = f(a) + 4*f(a+h) + f(b);

for i = 1:n/2
    s = s + 2*f(a + 2*i*h) + 4*f(a + (2*i + 1)*h);
end


end

function result = trapezoid(f, a, b, n)


end

function result = rectangle(f, a, b, n, type)
%type = left, right, central

end
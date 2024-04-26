function ans = getff(x,n,epsy)
    if n == 1
        f = @(x) exp(x);
    end
    if n == 2
        f = @(x) cos(x);
    end
    if n == 3
        f = @(x) abs(x);
    end
    if n == 4
        f = @(x) 100*x.^-1;
    end
    if n == 5
        f = @(x)cos(x./2).*exp(x);
    end
    if n == 6
        f =  @(x)cosh(x);
    end
    if n == 7
        f = @(x)10*sin(x./10);
    end
    if n == 8
        f = @(x) cos(2*x/5-4);
    end
    if n == 9
        f = @(x) 7*exp(-x.^66+2)-exp(x/66);
    end
    ans = f(x).*((2*rand(size(x))-1)*epsy/100+1);
end
N = 10;
A = rand(N);
x0 = rand(N,1);
b = A*x0;
x = A\b;
err = norm(x-x0)/norm(x0);
r = norm(A*x-b);
ob = cond(A);
err_est = ob*r/norm(b);


clear RES;

N = 10;

l = 1;

for i = 1:8
    A = getMat(N,0.05,i);
    x0 = rand(N,1);
    b = A*x0;
    x = A\b;
    err = norm(x-x0)/norm(x0);
    r = norm(A*x-b);
    ob = cond(A);
    err_est = ob*r/norm(b);

    RES(l,1) = i;
    RES(l,2) = cond(A);
    RES(l,3) = err;
    RES(l,4) = err_est;
    RES(l,5) = norm(r);
end
N = 10;
A = rand(N);
x0 = rand(N,1);
b = A*x0;
x = A\b;
err = norm(x-x0)/norm(x0);
r = norm(A*x-b);
ob = cond(A);
err_est = ob*r/norm(b);

%% 1.
clear RES;

N = 10;
l = 1;

H(:,:,1) = matrix3(N)/matrix2(N);
H(:,:,2) = matrix4(N)*matrix1(N);
H(:,:,3) = matrix1(N).*matrix7(N,0.2);
H(:,:,4) = matrix1(N)/matrix4(N).*matrix7(N,0.4);
H(:,:,5) = matrix8(N);
H(:,:,6) = matrix4(N)*matrix5(N);
H(:,:,7) = matrix4(N)*matrix6(N)/matrix7(N,0.4);
H(:,:,8) = matrix7(N,0.85);

for i = 1:size(H,3)
    %A = getMat(N,0.05,i)*getMat(N,0.05,j);
    A = H(:,:,i);

    x0 = rand(N,1);
    b = A * x0;
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

    l = l + 1;
end

writematrix(RES,"RES331.xlsx")

%% 2.
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

N = 5;
l = 1;
%% generating matrix
% clear H
% H(:,:,1) = matrix1(N)*matrix2(N);
% H(:,:,2) = matrix8(N)*matrix3(N);
% H(:,:,3) = matrix5(N)*matrix3(N);
% H(:,:,4) = matrix6(N)*matrix1(N);
% H(:,:,5) = matrix8(N)*matrix6(N);
% H(:,:,6) = matrix5(N)*matrix6(N);
% 
% N = 12;
% H2(:,:,1) = matrix2(N);
% H2(:,:,2) = matrix1(N)*matrix2(N);
% H2(:,:,3) = matrix8(N)*matrix3(N);
% H2(:,:,4) = matrix6(N)*matrix3(N);
% H2(:,:,5) = matrix6(N)*matrix1(N);
% H2(:,:,6) = matrix8(N)*matrix6(N);

%N = 5;
%% da
% for N = 6:3:15
% for j = 1:8
% for i = 1:8
%     A = getMat(N,0.05,i)*getMat(N,0.05,j);
%     %N = 5;
%     %A = H(:,:,i);
% 
%     x0 = rand(N,1);
%     b = A * x0;
%     x = A\b;
%     err = norm(x-x0)/norm(x0);
%     r = norm(A*x-b);
%     ob = cond(A);
%     err_est = ob*r/norm(b);
% 
% 
%     RES(l,1) = N;
%     RES(l,2) = i;
%     RES(l,3) = j;
%     RES(l,4) = cond(A);
%     RES(l,5) = err;
%     RES(l,6) = err_est;
%     RES(l,7) = norm(r);
% 
%     % N = 12;
%     % 
%     % A = H2(:,:,i);
%     % 
%     % x0 = rand(N,1);
%     % b = A * x0;
%     % x = A\b;
%     % err = norm(x-x0)/norm(x0);
%     % r = norm(A*x-b);
%     % ob = cond(A);
%     % err_est = ob*r/norm(b);
%     % 
%     % RES(l,11) = i;
%     % RES(l,12) = j;
%     % RES(l,13) = cond(A);
%     % RES(l,14) = err;
%     % RES(l,15) = err_est;
%     % RES(l,16) = norm(r);
% 
%     %fprintf("%d %e %e %e %e\n",i,cond(A),err,err_est,norm(r))
% 
%     l = l + 1;
% end
% end
% end

%writematrix(RES,"RES3331.xlsx")

%% 2.
clear RES

l = 1;

N=7;
clear H
H(:,:,1) = matrix2(N);
H(:,:,2) = matrix3(N);
H(:,:,3) = matrix1(N)*matrix3(N);
H(:,:,4) = matrix6(N)*matrix1(N);
H(:,:,5) = matrix8(N)*matrix6(N);
H(:,:,6) = matrix5(N)*matrix6(N);
for i = 1:size(H,3)    
    epsA = 1e-1;
    A = H(:,:,i);
    x0 = ceil(rand(N,1)*1000)/1000;

    for j = 1:5
        P = (2*rand(N)-1)*epsA;
        Ap = (eye(N)+P)*A;
        b = A * x0;

        x = A\b;
        err = norm(x-x0);
        r = norm(A*x-b);
        ob = cond(A);
        err_est = ob*r/norm(b);

        xp = Ap\b;
        obp = cond(Ap);
        rp = norm(Ap*xp-b);
        errp = norm(x0-xp);
        err_estp = obp*r/norm(b);
        err_est2 = err_estp + norm(P);

        RES(l,1) = i;
        RES(l,2) = cond(A);
        RES(l,3) = err;
        RES(l,4) = err_est;
        RES(l,5) = norm(r);
        RES(l,6) = epsA;
        RES(l,7) = cond(Ap);
        RES(l,8) = errp;
        RES(l,9) = err_estp;
        RES(l,10) = err_est2;
        RES(l,11) = norm(rp);

        l = l + 1;
        epsA = epsA^2;
    end


end

writematrix(RES,"RES3332.xlsx")

N=3;
clear H
H(:,:,1) = [4 0 2; 7 6 1; 2 3 6];
H(:,:,2) = [3 1 1; 5 7 2; 3 3 5];

H(:,:,3) = [16 0 1; 600 766 6; 30000 100 2560];
H(:,:,4) = [37 5 0; 124 500 7; 81500 1700 966];

A = H(:,:,3);



%epsx = [1e-4,1e-8];
l = 1;


for i = 1:4
    A = H(:,:,i);
    x0 = rand(N,1);
    b = A*x0;

    D = diag(diag(A));
    al = inv(D)*(D-A);
    bt = inv(D)*b;

    

    epsx = 1e-4;
    eim = max(abs(eig(al)));
    for j = 1:2
        xk1 = zeros(N);
        xk = xk1;

        for k = 1:1e5
	        xk1 = al*xk+bt;
	        if norm(xk1-xk)<epsx
		        break;
	        end
	        xk = xk1;
        end
        err = norm(x0-xk);

        RES(l,1) = i;
        RES(l,2) = eim;
        RES(l,3) = epsx;
        RES(l,4) = cond(A);
        RES(l,5) = err;
        RES(l,6) = k;

        l = l + 1;
        epsx = epsx^2;
    end


end

writematrix(RES,"RES3333.xlsx")

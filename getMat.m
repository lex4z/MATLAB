function a = getMat(n,alf,type)

    if type == 1
        for i=1:n
            for j=1:n
                if i==j 
                    a(i,j)=i;
                elseif j==i+1
                    a(i,j)=n;
                else a(i,j)=0;
                end
            end
        end
    end
    
    if type == 2
        for i=1:n
            for j=1:n
                if j<i
                    a(i,j)=j;
                else a(i,j)=i;
                end
            end
        end
    end

    if type == 3
        for i=1:n
            for j=1:n
                if i==j 
                    a(i,j)=0.01/((n-i+1)*(i+1));
                elseif i>j
                    a(i,j)=i*(n-j);
                else a(i,j)=j*(n-i);
                end
            end
        end
    end

    if type == 4
        for i=1:n
            for j=1:n
                a(i,j)=2*(rand-0.5);        
            end
        end
    end

    if type == 5
        for i=1:n
            for j=1:n
                a(i,j)=sin(i*j/(2*n));
            end
        end
    end

    if type == 6
        for i=1:n
            for j=1:n
                if i==j 
                    a(i,j)=1/((n-i+1)*(i+1));
                elseif i>j
                    a(i,j)=i*(n-j);
                else a(i,j)=0;
                end
            end
        end
    end

    if type == 7
        if alf>0.01 alf=-alf;
        end
        for i=1:n
            for j=1:n
                a(i,j)=exp(alf*i*j);        
            end
        end
    end

    if type == 8
        for i=1:n
            for j=1:n
                a(i,j)=1/(i+j-1);        
            end
        end
    end
end